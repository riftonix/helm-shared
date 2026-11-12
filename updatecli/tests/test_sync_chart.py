"""Adapter tests with a fixture Helm, plus optional native Updatecli integration tests."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import yaml

ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("sync_chart", ROOT / "updatecli/sync_chart.py")
sync = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(sync)
BINARY = os.environ.get("UPDATECLI_BIN") or shutil.which("updatecli")


def snapshot(directory):
    return {path.relative_to(directory).as_posix(): path.read_bytes() for path in directory.rglob("*") if path.is_file()}


def git_env():
    return dict(os.environ, GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL="/dev/null",
                GIT_AUTHOR_NAME="probe", GIT_AUTHOR_EMAIL="probe@example.invalid",
                GIT_COMMITTER_NAME="probe", GIT_COMMITTER_EMAIL="probe@example.invalid")


class ConfigurationTests(unittest.TestCase):
    def test_every_chart_has_one_component_and_one_independent_pin(self):
        policy = yaml.safe_load((ROOT / "updatecli/values.yaml").read_text())
        registry = sync.components(policy)
        actual = {path.parent.relative_to(ROOT).as_posix() for group in ("charts", "libs") for path in (ROOT / group).glob("*/Chart.yaml")}
        self.assertEqual(actual, {component["path"] for component in registry.values()})
        self.assertEqual(len(actual), len(registry))
        for name, component in registry.items():
            metadata = yaml.safe_load((ROOT / component["path"] / "Chart.yaml").read_text())
            self.assertEqual(metadata["name"], name)
            for dependency in metadata.get("dependencies", []):
                self.assertRegex(str(dependency["version"]), r"^\d+\.\d+\.\d+$", "No Chart.lock: pin exact versions")
            pin = json.loads((ROOT / "updatecli/pins" / f"{name}.json").read_text())
            self.assertRegex(pin["digest"], r"^sha256:[0-9a-f]{64}$")
            self.assertRegex(pin["version"], r"^\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?$")
        self.assertIn("CHANGELOG.md", policy["upstream"]["exclude"])
        self.assertNotIn("docs/README.md.gotmpl", policy["upstream"]["exclude"])

    def test_normalization_rebrands_upstream_without_touching_binary_files(self):
        policy = yaml.safe_load((ROOT / "updatecli/values.yaml").read_text())
        with tempfile.TemporaryDirectory() as directory:
            tree = Path(directory)
            (tree / "Chart.yaml").write_text(
                "apiVersion: v2\nname: nxs-universal-chart\nversion: 3.2.3\nhome: https://github.com/nixys/nxs-universal-chart\n"
                "icon: logo\nmaintainers:\n  - name: upstream\nannotations:\n  signing: foreign\n"
                "dependencies:\n- name: nuc-common\n  repository: oci://registry.nixys.ru/nuc\n- name: nuc-certificates\n")
            (tree / "README.md").write_text(
                "# NXS Universal Chart\n\n![Nxs Universal Chart Logo](logo)\n[![Artifact Hub](badge)](hub)\n\n"
                "## Introduction\n\nnxs-universal-chart is a Helm chart \u2014 see https://github.com/nixys/nuc-common\n")
            (tree / "logo.png").write_bytes(b"\xff\xfenuc-common")
            sync.normalize(tree, sync.rules(policy, "appchart"))
            self.assertEqual((tree / "Chart.yaml").read_text(),
                             "apiVersion: v2\nname: appchart\nversion: 3.2.3\n"
                             "dependencies:\n- name: common\n  repository: oci://ghcr.io/riftonix/helm-shared/libs\n- name: cert-manager\n")
            self.assertEqual((tree / "README.md").read_text(),
                             "# Appchart\n\nThis is the fork of [nxs-universal-chart](https://github.com/nixys/nxs-universal-chart/).\n\n"
                             "## Introduction\n\nAppchart is a Helm chart - see https://github.com/riftonix/helm-shared/tree/master/libs/common\n")
            self.assertEqual((tree / "logo.png").read_bytes(), b"\xff\xfenuc-common")

    def test_noop_does_not_fetch_or_depend_on_sibling_versions(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "updatecli").mkdir()
            (root / "updatecli/pins").mkdir(parents=True)
            (root / "updatecli/values.yaml").write_text(yaml.safe_dump({"components": {"common": {"path": "libs/common"}}}))
            (root / "updatecli/pins/common.json").write_text(json.dumps({"version": "1.0.5", "digest": "recorded"}))
            with patch.object(sync, "pull") as pull:
                sync.synchronize(root, "common", "1.0.5")
            pull.assert_not_called()

    def test_source_pin_cannot_resolve_outside_checkout(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "repo"
            (root / "updatecli").mkdir(parents=True)
            (root / "updatecli/pins").mkdir(parents=True)
            (root / "updatecli/values.yaml").write_text(yaml.safe_dump({"components": {"common": {"path": "libs/common"}}}))
            outside = Path(directory) / "outside.json"
            outside.write_text("not a source pin")
            (root / "updatecli/pins/common.json").symlink_to(outside)
            with self.assertRaises(ValueError):
                sync.synchronize(root, "common", "1.0.5")

    def test_copy_rejects_symlinks_and_git_metadata(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source"
            source.mkdir()
            (source / "link").symlink_to(root)
            with self.assertRaises(ValueError):
                sync.copy_tree(source, root / "copy", [])
            (source / "link").unlink()
            (source / ".git").mkdir()
            with self.assertRaises(ValueError):
                sync.copy_tree(source, root / "copy2", [])

    def test_policy_excludes_exact_file_not_similar_names(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source"
            source.mkdir()
            (source / "CHANGELOG.md").write_text("exclude")
            (source / "CHANGELOG.md.example").write_text("keep")
            sync.copy_tree(source, root / "copy", ["CHANGELOG.md"])
            self.assertEqual(snapshot(root / "copy"), {"CHANGELOG.md.example": b"keep"})


class GitMergeTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="test-directory-merge-")
        self.addCleanup(temporary.cleanup)
        self.control = Path(temporary.name)
        self.env = git_env()
        self.git = ["git", "--git-dir", str(self.control / "objects.git")]
        sync.run(["git", "init", "--bare", "--quiet", str(self.control / "objects.git")], self.control, self.env)

    def merge(self, base, ours, incoming):
        for name, files in (("base", base), ("ours", ours), ("incoming", incoming)):
            directory = self.control / name
            directory.mkdir()
            for relative, content in files.items():
                path = directory / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(content)
        sync.merge(self.git, self.control / "base", self.control / "ours", self.control / "incoming",
                   self.control / "result", self.control, self.env)
        return snapshot(self.control / "result")

    def test_additions_deletions_and_local_only_files(self):
        self.assertEqual(self.merge({"remove": b"old"}, {"remove": b"old", "local": b"fork"}, {"new": b"upstream"}),
                         {"local": b"fork", "new": b"upstream"})

    def test_preserves_local_edit_across_upstream_rename(self):
        body = b"one\ntwo\nthree\n"
        self.assertEqual(self.merge({"old": body}, {"old": body + b"local\n"}, {"renamed": body}),
                         {"renamed": body + b"local\n"})

    def test_conflict_does_not_export_result(self):
        with self.assertRaises(subprocess.CalledProcessError):
            self.merge({"file": b"base\n"}, {"file": b"fork\n"}, {"file": b"upstream\n"})
        self.assertFalse((self.control / "result").exists())


class Workspace:
    """Temporary fork, package fixtures, and a network-free Helm executable."""
    def __init__(self, directory):
        self.directory = Path(directory)
        self.root = self.directory / "repo"
        self.root.mkdir()
        shutil.copytree(ROOT / "updatecli", self.root / "updatecli", ignore=shutil.ignore_patterns("__pycache__"))
        shutil.copy(ROOT / "LICENSE", self.root / "LICENSE")
        self.policy = yaml.safe_load((self.root / "updatecli/values.yaml").read_text())
        self.policy["github"]["enabled"] = False
        (self.root / "updatecli/values.yaml").write_text(yaml.safe_dump(self.policy, sort_keys=False))
        self.packages = self.directory / "packages"
        self.packages.mkdir()
        tools = self.directory / "bin"
        tools.mkdir()
        shutil.copy(ROOT / "updatecli/tests/fixtures/helm", tools / "helm")
        (tools / "helm").chmod(0o755)
        home = self.directory / "home"
        home.mkdir()
        self.env = dict(os.environ, HOME=str(home), PATH=str(tools) + os.pathsep + os.environ["PATH"])

    def package(self, name, version, dependencies=None):
        component = sync.components(self.policy)[name]
        folder = self.packages / component["upstream"] / version
        chart = folder / "chart"
        chart.mkdir(parents=True)
        metadata = {"apiVersion": "v2", "name": component["upstream"], "version": version,
                    "type": "library" if name == "common" else "application"}
        if name != "common":
            metadata.update(icon="logo", maintainers=[{"name": "upstream"}], annotations={"signing": "foreign"})
        if dependencies:
            metadata["dependencies"] = dependencies
        (chart / "Chart.yaml").write_text(yaml.safe_dump(metadata, sort_keys=False))
        (chart / "values.yaml").write_text("image: old\n\nfeature: old\n")
        (chart / "README.md").write_text("# NXS Universal Chart\n\n![Nxs Universal Chart Logo](logo)\n\n[![Artifact Hub](badge)](hub)\n\n## Introduction\n\nnxs-universal-chart is a Helm chart\n")
        (chart / "CHANGELOG.md").write_text("not imported")
        (chart / "LICENSE").write_text("upstream license")
        digest = "sha256:" + hashlib.sha256((name + version).encode()).hexdigest()
        (folder / "digest").write_text(digest)
        return chart, digest

    def checkout(self, name, version, dependencies=None):
        chart, digest = self.package(name, version, dependencies)
        component = sync.components(self.policy)[name]
        source = self.directory / ("base-" + name)
        sync.copy_tree(chart, source, self.policy["upstream"]["exclude"] + component.get("exclude", []))
        sync.normalize(source, sync.rules(self.policy, name))
        target = self.root / component["path"]
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(source, target)
        (target / "values.yaml").write_text("image: renovate\n\nfeature: old\n")
        (target / "local.txt").write_text("fork-owned")
        (self.root / "updatecli/pins" / f"{name}.json").write_text(json.dumps({"version": version, "digest": digest}))
        return target

    def invoke(self, name, version, apply=False):
        env = dict(self.env, DRY_RUN="false" if apply else "true")
        return subprocess.run(["python3", "-I", "updatecli/sync_chart.py", "--component", name, "--version", version],
                              cwd=self.root, env=env, capture_output=True, text=True, timeout=60)

    def manifests(self, production=False):
        command = [BINARY, "manifest", "show", "--config", "updatecli/manifest.yaml", "--values", "updatecli/values.yaml", "--disable-version-check"]
        env = self.env
        if production:
            override = self.directory / "production-values.yaml"
            override.write_text(yaml.safe_dump({"github": {"enabled": True, "owner": "fixture", "repository": "fixture"}}))
            command += ["--values", str(override), "--disable-prepare"]
            env = dict(self.env, UPDATECLI_GITHUB_TOKEN="fixture-not-a-token", HTTPS_PROXY="http://127.0.0.1:1", HTTP_PROXY="http://127.0.0.1:1", NO_PROXY="")
        result = subprocess.run(command, cwd=self.root, env=env, capture_output=True, text=True, timeout=15)
        if result.returncode:
            raise AssertionError(result.stdout + result.stderr)
        chunks = re.split(r"(?m)^== .* ==\s*$", result.stdout)
        return [yaml.safe_load(chunk) for chunk in chunks if chunk.strip().startswith("name:")]

    def workflow(self, manifests, mode, *flags):
        config = self.directory / "workflow.yaml"
        config.write_text(yaml.safe_dump_all(manifests, sort_keys=False))
        command = [BINARY, "pipeline", mode, "--config", str(config), "--disable-version-check",
                   "--disable-changelog", "--disable-udash-report", "--unique-tmp-dir"]
        if mode == "apply":
            command += ["--commit=false", "--push=false"]
        return subprocess.run(command + list(flags), cwd=self.root, env=self.env, capture_output=True, text=True, timeout=120)


class WorkspaceTestCase(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="test-component-update-")
        self.addCleanup(temporary.cleanup)
        self.workspace = Workspace(temporary.name)


class AdapterTests(WorkspaceTestCase):
    def test_preview_apply_and_idempotency_touch_only_one_component(self):
        workspace = self.workspace
        target = workspace.checkout("traefik", "1.0.5")
        untouched = workspace.checkout("common", "1.0.5")
        package, _ = workspace.package("traefik", "1.0.6")
        (package / "values.yaml").write_text("image: old\n\nfeature: new\n")
        before = snapshot(workspace.root)
        preview = workspace.invoke("traefik", "1.0.6")
        self.assertEqual(preview.returncode, 0, preview.stderr)
        self.assertEqual(snapshot(workspace.root), before)
        applied = workspace.invoke("traefik", "1.0.6", apply=True)
        self.assertEqual(applied.returncode, 0, applied.stderr)
        self.assertEqual((target / "values.yaml").read_text(), "image: renovate\n\nfeature: new\n")
        self.assertFalse((target / "LICENSE").exists())
        self.assertEqual(snapshot(untouched), {key.removeprefix("libs/common/"): value for key, value in before.items() if key.startswith("libs/common/")})
        changed = {name for name, body in snapshot(workspace.root).items() if before.get(name) != body}
        self.assertTrue(all(name.startswith("libs/traefik/") or name == "updatecli/pins/traefik.json" for name in changed))
        after = snapshot(workspace.root)
        repeated = workspace.invoke("traefik", "1.0.6", apply=True)
        self.assertEqual(repeated.returncode, 0, repeated.stderr)
        self.assertEqual(repeated.stdout, "")
        self.assertEqual(snapshot(workspace.root), after)
        self.assertFalse((target / "CHANGELOG.md").exists())

    def test_appchart_keeps_local_readme_template_and_excludes_upstream_license(self):
        workspace = self.workspace
        common = workspace.checkout("common", "1.0.5")
        local_library = yaml.safe_load((common / "Chart.yaml").read_text())
        local_library["version"] = "9.9.9"
        (common / "Chart.yaml").write_text(yaml.safe_dump(local_library))
        dependencies = [{"name": "nuc-common", "version": "1.0.5", "repository": "oci://registry.nixys.ru/nuc"}]
        target = workspace.checkout("appchart", "3.2.2", dependencies)
        (target / "docs").mkdir()
        (target / "docs/README.md.gotmpl").write_text("local README template")
        package, _ = workspace.package("appchart", "3.2.3", dependencies)
        (package / "LICENSE").write_text("changed upstream license")
        result = workspace.invoke("appchart", "3.2.3", apply=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((target / "docs/README.md.gotmpl").read_text(), "local README template")
        self.assertFalse((target / "LICENSE").exists())
        self.assertEqual((workspace.root / "LICENSE").read_bytes(), (ROOT / "LICENSE").read_bytes())
        self.assertEqual(yaml.safe_load((target / "Chart.yaml").read_text())["name"], "appchart")

    def test_digest_mismatch_does_not_write_checkout(self):
        workspace = self.workspace
        workspace.checkout("common", "1.0.5")
        workspace.package("common", "1.0.6")
        pin = workspace.root / "updatecli/pins/common.json"
        pin.write_text(json.dumps({"version": "1.0.5", "digest": "sha256:" + "0" * 64}))
        before = snapshot(workspace.root)
        result = workspace.invoke("common", "1.0.6", apply=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("digest", result.stderr)
        self.assertEqual(snapshot(workspace.root), before)

    def test_conflict_does_not_write_checkout(self):
        workspace = self.workspace
        target = workspace.checkout("common", "1.0.5")
        (target / "values.yaml").write_text("image: renovate\n\nfeature: fork\n")
        package, _ = workspace.package("common", "1.0.6")
        (package / "values.yaml").write_text("image: old\n\nfeature: upstream\n")
        before = snapshot(workspace.root)
        result = workspace.invoke("common", "1.0.6", apply=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(snapshot(workspace.root), before)

    def test_artifact_version_collision_requires_manual_resolution(self):
        workspace = self.workspace
        target = workspace.checkout("traefik", "1.0.5")
        metadata = yaml.safe_load((target / "Chart.yaml").read_text())
        metadata["version"] = "1.0.6"
        (target / "Chart.yaml").write_text(yaml.safe_dump(metadata, sort_keys=False))
        package, _ = workspace.package("traefik", "1.0.6")
        (package / "values.yaml").write_text("image: old\n\nfeature: new\n")
        before = snapshot(workspace.root)
        result = workspace.invoke("traefik", "1.0.6", apply=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("artifact version", result.stderr)
        self.assertEqual(snapshot(workspace.root), before)



@unittest.skipUnless(BINARY, "Set UPDATECLI_BIN or install Updatecli for native integration tests")
class NativeTests(WorkspaceTestCase):

    def test_native_manifest_has_one_unique_oci_pipeline_per_component(self):
        documents = self.workspace.manifests()
        expected = len(self.workspace.policy["components"])
        self.assertEqual(len(documents), expected)
        self.assertEqual(len({doc["pipelineid"] for doc in documents}), expected)
        for doc in documents:
            self.assertEqual(doc["sources"]["version"]["kind"], "helmchart")
            self.assertTrue(doc["sources"]["version"]["spec"]["url"].startswith("oci://"))
            self.assertNotIn("dependson", doc)

    def test_pr_configuration_is_independent_and_manual_without_network(self):
        documents = self.workspace.manifests(production=True)
        self.assertEqual(len(documents), len(self.workspace.policy["components"]))
        for document in documents:
            self.assertEqual(document["targets"]["component"]["scmid"], "fork")
            self.assertTrue(document["scms"]["fork"]["spec"]["workingbranch"])
            self.assertFalse(document["scms"]["fork"]["spec"]["force"])
            action = document["actions"]["pullrequest"]
            self.assertEqual(action["kind"], "github/pullrequest")
            self.assertEqual(action["spec"]["merge"]["strategy"], "manual")

    def test_failed_pipeline_does_not_block_independent_component(self):
        workspace = self.workspace
        common = workspace.checkout("common", "1.0.5")
        traefik = workspace.checkout("traefik", "1.0.5")
        workspace.package("common", "1.0.6")
        workspace.package("traefik", "1.0.6")
        pin = workspace.root / "updatecli/pins/common.json"
        recorded = pin.read_text()
        pin.write_text(json.dumps({"version": "1.0.5", "digest": "sha256:" + "0" * 64}))
        manifests = [doc for doc in workspace.manifests() if doc["pipelineid"] in ("upstream-common", "upstream-traefik")]
        for manifest in manifests:
            name = manifest["pipelineid"].removeprefix("upstream-")
            version_file = workspace.directory / (name + ".version")
            version_file.write_text("1.0.6")
            manifest["sources"]["version"] = {"kind": "file", "spec": {"file": str(version_file)}}
        before_common = snapshot(common)
        result = workspace.workflow(manifests, "apply")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(snapshot(common), before_common)
        self.assertEqual(yaml.safe_load((traefik / "Chart.yaml").read_text())["version"], "1.0.6")
        pin.write_text(recorded)
        retry = workspace.workflow(manifests, "apply", "--pipeline-ids", "upstream-common")
        self.assertEqual(retry.returncode, 0, (retry.stdout + retry.stderr)[-6000:])
        self.assertEqual(json.loads(pin.read_text())["version"], "1.0.6")
        self.assertEqual(yaml.safe_load((common / "Chart.yaml").read_text())["version"], "1.0.6")

if __name__ == "__main__":
    unittest.main()
