#!/usr/bin/env python3
"""Update one chart from its upstream OCI package with Helm and Git merge-tree."""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

import yaml


def run(command: list[str], cwd: Path, env: dict[str, str], data: str | None = None) -> str:
    """Capture tool output; never run tools from downloaded source directories."""
    return subprocess.run(command, cwd=cwd, env=env, input=data, text=True, capture_output=True, check=True).stdout


def components(policy: dict) -> dict[str, dict]:
    """Registry with defaults: path libs/<id>, upstream chart nuc-<id>."""
    return {key: {"path": f"libs/{key}", "upstream": f"nuc-{key}", **(value or {})}
            for key, value in policy["components"].items()}


def rules(policy: dict, key: str) -> list[dict]:
    """Ordered rewrites: GitHub URLs, shared rules, upstream chart names, component rules."""
    registry = components(policy)
    github = [{"from": f"https://github.com/nixys/{c['upstream']}", "to": f"{policy['home']}/tree/master/{c['path']}"}
              for c in registry.values()]
    names = [{"from": c["upstream"], "to": name} for name, c in registry.items()]
    return github + policy["rewrite"] + names + registry[key].get("rewrite", [])


def normalize(tree: Path, rewrites: list[dict]) -> None:
    """Rewrite UTF-8 files in place; binary files are left untouched."""
    for path in tree.rglob("*"):
        if not path.is_file():
            continue
        try:
            original = path.read_bytes().decode()
        except UnicodeDecodeError:
            continue
        relative = path.relative_to(tree).as_posix()
        text = original
        for rule in rewrites:
            if rule.get("file", relative) != relative:
                continue
            text = re.sub(rule["regex"], rule["to"], text) if "regex" in rule else text.replace(rule["from"], rule["to"])
        if text != original:
            path.write_bytes(text.encode())


def copy_tree(source: Path, destination: Path, exclusions: list[str]) -> None:
    """Copy data without following links; exclusions are chart-relative paths."""
    if source.is_symlink():
        raise ValueError("Chart root must not be a symlink")
    excluded = {item.rstrip("/") for item in exclusions}
    def ignore(directory, names):
        parent = Path(directory).relative_to(source)
        return [name for name in names if name == "__pycache__" or (parent / name).as_posix() in excluded]
    shutil.copytree(source, destination, ignore=ignore, symlinks=True)
    if any(path.is_symlink() or ".git" in path.relative_to(destination).parts for path in destination.rglob("*")):
        raise ValueError("Chart trees must contain regular files, not symlinks or .git metadata")


def pull(registry: str, name: str, version: str, destination: Path, control: Path,
         env: dict[str, str], expected: str | None = None) -> tuple[Path, str]:
    """Helm verifies OCI content; compare the base manifest with the recorded pin."""
    destination.mkdir()
    result = subprocess.run(["helm", "pull", f"{registry}/{name}", "--version", version,
                             "--untar", "--destination", str(destination), "--registry-config", str(control / "registry.json")],
                            cwd=control, env=env, text=True, capture_output=True, check=True)
    match = re.search(r"Digest:\s*(sha256:[0-9a-f]{64})", result.stdout + result.stderr)
    if not match or expected and match[1] != expected:
        raise ValueError("OCI digest is missing or does not match the base pin")
    chart = destination / name
    metadata = yaml.safe_load((chart / "Chart.yaml").read_text())
    if metadata["name"] != name or str(metadata["version"]) != version:
        raise ValueError("Pulled chart identity does not match the requested artifact")
    return chart, match[1]


def git_tree(git: list[str], directory: Path, control: Path, env: dict[str, str]) -> str:
    """Let Git index a complete directory and write its tree."""
    args = git + ["--work-tree", str(directory)]
    run(args + ["read-tree", "--empty"], control, env)
    run(args + ["add", "--all", "--force"], control, env)
    return run(git + ["write-tree"], control, env).strip()


def merge(git: list[str], base: Path, ours: Path, incoming: Path, result: Path,
          control: Path, env: dict[str, str]) -> str:
    """Git owns directory merging, deletions, renames and conflict detection."""
    def commit(directory, label, parent=None):
        command = git + ["commit-tree", git_tree(git, directory, control, env), "-m", label]
        if parent:
            command += ["-p", parent]
        return run(command, control, env).strip()
    ancestor = commit(base, "base")
    local = commit(ours, "fork", ancestor)
    remote = commit(incoming, "upstream", ancestor)
    tree = run(git + ["merge-tree", "--write-tree", local, remote], control, env).splitlines()[0]
    result.mkdir()
    run(git + ["read-tree", tree], control, env)
    run(git + ["--work-tree", str(result), "checkout-index", "--all", "--force"], control, env)
    return local


def synchronize(root: Path, key: str, version: str, apply: bool = False) -> None:
    """Prepare one candidate, then optionally apply its checked patch and pin."""
    policy = yaml.safe_load((root / "updatecli/values.yaml").read_text())
    component = components(policy)[key]
    path = Path(component["path"])
    if len(path.parts) != 2 or path.parts[0] not in ("charts", "libs") or ".." in path.parts or not re.fullmatch(r"[a-z0-9][a-z0-9-]*", key):
        raise ValueError("Component must have a safe repository-relative path and ID")
    if not (root / path).resolve().is_relative_to(root.resolve()):
        raise ValueError("Component resolves outside the repository")
    if not re.fullmatch(r"\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?", version):
        raise ValueError("An explicit semantic version is required")
    pin_path = root / "updatecli/pins" / f"{key}.json"
    if pin_path.is_symlink() or not pin_path.resolve().is_relative_to(root.resolve()):
        raise ValueError("Source pin resolves outside the repository")
    pin = json.loads(pin_path.read_text())
    if version == pin["version"]:
        return
    with tempfile.TemporaryDirectory(prefix="chart-sync-") as temporary:
        control = Path(temporary)
        home = control / "home"
        home.mkdir()
        env = dict(os.environ, HOME=str(home), DOCKER_CONFIG=str(control / "docker"),
                   HELM_CACHE_HOME=str(control / "cache"), HELM_CONFIG_HOME=str(control / "config"),
                   HELM_DATA_HOME=str(control / "data"), GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL="/dev/null",
                   GIT_AUTHOR_NAME="chart-sync", GIT_AUTHOR_EMAIL="chart-sync@example.invalid",
                   GIT_COMMITTER_NAME="chart-sync", GIT_COMMITTER_EMAIL="chart-sync@example.invalid",
                   GIT_AUTHOR_DATE="@1700000000 +0000", GIT_COMMITTER_DATE="@1700000000 +0000")
        registry = policy["upstream"]["registry"].rstrip("/")
        original, _ = pull(registry, component["upstream"], pin["version"], control / "old-package", control, env, pin["digest"])
        updated, digest = pull(registry, component["upstream"], version, control / "new-package", control, env)
        base, incoming, ours, result = [control / name for name in ("base", "incoming", "ours", "result")]
        exclusions = policy["upstream"]["exclude"] + component.get("exclude", [])
        for package, tree in ((original, base), (updated, incoming)):
            copy_tree(package, tree, exclusions)
            normalize(tree, rules(policy, key))
        copy_tree(root / path, ours, ["charts/", "Chart.lock"])
        git = ["git", "--git-dir", str(control / "objects.git")]
        run(["git", "init", "--bare", "--quiet", str(control / "objects.git")], control, env)
        local = merge(git, base, ours, incoming, result, control, env)
        patch = run(git + ["diff", "--binary", "--full-index", "--find-renames", local,
                           git_tree(git, result, control, env)], control, env)
        versions = [yaml.safe_load((tree / "Chart.yaml").read_text())["version"] for tree in (ours, result)]
        if patch and versions[0] == versions[1]:
            raise ValueError("Merged chart changed without advancing its artifact version; resolve the fork/upstream version collision manually")
        if patch:
            run(["git", "apply", "--check", "--directory", str(path), "-"], root, env, patch)
        # Updatecli treats any stdout from a shell target as a change.
        print(f"{'Apply' if apply else 'Preview'} {key}: {pin['version']} -> {version}")
        if apply:
            if patch:
                run(["git", "apply", "--directory", str(path), "-"], root, env, patch)
            pin_path.write_text(json.dumps({"version": version, "digest": digest}, indent=2) + "\n")


def main() -> int:
    """Updatecli sets DRY_RUN=false only for `pipeline apply`; anything else previews."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--component", required=True)
    parser.add_argument("--version", required=True)
    args = parser.parse_args()
    try:
        synchronize(Path.cwd(), args.component, args.version.removeprefix("v"), os.environ.get("DRY_RUN") == "false")
        return 0
    except (OSError, ValueError, KeyError, yaml.YAMLError, subprocess.CalledProcessError) as error:
        detail = ((error.stdout or "") + (error.stderr or "")) if isinstance(error, subprocess.CalledProcessError) else str(error)
        print(f"sync_chart: {detail[-6000:]}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
