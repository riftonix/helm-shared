# Independent upstream chart updates

Every chart under `charts/` and `libs/` is an independently updated component. Each component has its own Updatecli pipeline, working branch and PR. Merge order between components is decided manually.

## Configuration

| File | Purpose |
| --- | --- |
| `updatecli/values.yaml` | Component registry, upstream registry, exclusions and rewrite rules. |
| `updatecli/manifest.yaml` | One Updatecli pipeline, GitHub working branch and PR per component. |
| `updatecli/pins/<component>.json` | The component's imported upstream version and OCI manifest digest. |
| `updatecli/sync_chart.py` | Pulls packages with Helm, rewrites them, merges with Git and applies the checked patch. |

Upstream packages come from `oci://registry.nixys.ru/nuc`. The `kind: helmchart` source finds the newest version that matches the component's `versionfilter`.

A component entry only lists values that differ from the defaults:

| Field | Default |
| --- | --- |
| `path` | `libs/<id>` |
| `upstream` | `nuc-<id>` |
| `versionfilter` | `upstream.versionfilter` |
| `exclude` | none, added to `upstream.exclude` |
| `rewrite` | none, applied after the shared rules |

The component ID is also the local chart name. An update changes only the component directory and its pin.

## Running updates and creating PRs

The **Update charts** GitHub Actions workflow runs manually (`workflow_dispatch`). The updater configuration must already be on `master`, because authenticated targets run the helper from that checkout. Leave the component input empty to run all pipelines, or enter an ID such as `common`.

The workflow needs the repository secret `UPDATECLI_GITHUB_TOKEN`: a PAT or GitHub App installation token with contents and pull-request write access. PRs created with the default Actions `GITHUB_TOKEN` do not trigger the repository's `pull_request` workflows.

The equivalent CLI invocation from the repository root:

```sh
updatecli pipeline apply --config updatecli/manifest.yaml --values updatecli/values.yaml \
  --pipeline-ids upstream-traefik --disable-udash-report --unique-tmp-dir
```

Omit `--pipeline-ids` to run all pipelines. PR merge strategy is `manual` and force pushing is disabled. Validation and publication of merged changes remain with the repository CI and publish workflows.

## How an update is prepared

The adapter builds the complete result before Updatecli can commit it or open a PR:

1. Helm pulls the pinned and the new upstream packages into separate temporary directories, and the pinned package digest is compared with the pin.
2. Both packages are copied without excluded paths and rewritten by the rules from `values.yaml`.
3. `git merge-tree` merges the full directories with the current fork, including additions, deletions and renames.
4. Git checks the patch against the checkout. Only then are the component directory and its pin written.

Rewrite rules run in this order:

1. `https://github.com/nixys/<upstream>` becomes `<home>/tree/master/<path>` for every component.
2. Shared `rewrite` rules: OCI paths, dash characters and removal of foreign `Chart.yaml` metadata (`icon`, `home`, `maintainers`, `annotations`).
3. Each upstream chart name becomes its component ID, for example `nuc-certificates` becomes `cert-manager`.
4. The component's own `rewrite` rules. For appchart, these replace the README heading and branding.

A rule replaces the literal `from`, or the Python regular expression `regex` when set. `file` limits a rule to one chart-relative path. Binary files are not rewritten.

Fork-only content is not part of the upstream packages, so the merge keeps it as local edits. This covers the fork's `home` and `annotations` in `Chart.yaml`, Renovate image pins, `docs/README.md.gotmpl`, tests and other local files. `upstream.exclude` drops upstream `.github/`, `docs/AGENTS.md`, `CHANGELOG.md`, `LICENSE`, vendored `charts/` and `Chart.lock`.

## Dependencies

Charts keep no `Chart.lock`; it is ignored by Git. Dependency versions in `Chart.yaml` must be exact, which the tests enforce. CI and publication resolve dependencies with `helm dependency update`.

## Failures and manual merge order

The pipeline stops without writing the checkout or creating a PR when:

- the pinned package digest does not match;
- the merge has a content conflict;
- the chart changed but its version did not advance (fork and upstream version collision).

Other component pipelines are not affected. A dependency that is not yet published fails the PR's CI, not the pipeline: merge the dependency's PR, wait for its artifact to be published, then rerun the CI.

## Local preview

Prerequisites: Python 3.10+, PyYAML (`updatecli/requirements.txt`), Git 2.38+ with `merge-tree --write-tree`, Helm and Updatecli. Package downloads expect an anonymously readable registry. The workflow pins Updatecli `v0.123.0` and Helm `v4.3.1`.

Preview one component without credentials or remote branch operations:

```sh
updatecli pipeline diff --config updatecli/manifest.yaml --values updatecli/values.yaml \
  --values-inline '{"github":{"enabled":false}}' --pipeline-ids upstream-traefik \
  --disable-udash-report --unique-tmp-dir
```

The preview downloads packages but does not write the checkout. The adapter writes only when Updatecli sets `DRY_RUN=false`, which happens in `pipeline apply`. It never commits or pushes in the checkout; the Updatecli SCM and actions do that in PR mode.

## Tests and registering a component

Run the adapter and Git tests. They use a test-only Helm executable and temporary forks, not real registries:

```sh
python3 -I -m unittest discover -s updatecli/tests -v
```

Set `UPDATECLI_BIN=/path/to/updatecli` to also run the tests that render the Updatecli manifests and run pipelines.

To register a component, add its chart directory, an entry in `updatecli/values.yaml` and a pin file with a verified upstream OCI version and digest.
