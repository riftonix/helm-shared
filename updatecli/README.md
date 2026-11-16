# Independent upstream chart updates

Every chart under `charts/` and `libs/` is an independently updated component. Each component has its own Updatecli pipeline, working branch and PR. Merge order between components is decided manually.

The updater is the chart sync of the Daggerverse [`scenarios/helm-ci`](https://github.com/riftonix/daggerverse/tree/master/scenarios/helm-ci) scenario. It renders one Updatecli pipeline per component and runs its chart sync helper in the scenario runtime image. This repository keeps only the configuration and the pins.

## Configuration

| File | Purpose |
| --- | --- |
| `updatecli/values.yaml` | Component registry, upstream registry, version filters, exclusions and rewrite rules. |
| `updatecli/pins/<component>.json` | The component's synchronized upstream version and OCI manifest digest. |

Upstream packages come from `oci://registry.nixys.ru/nuc`. For each component, chart sync lists the upstream OCI tags and selects the highest stable `X.Y.Z` tag that matches the component's `versionfilter`. Prerelease and signature tags are ignored. An update is proposed only when the selected version is greater than the pinned version.

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

The **Update charts** GitHub Actions workflow runs every Monday at 06:00 UTC and on manual dispatch (`workflow_dispatch`). Leave the component input empty to run all components, or enter an ID such as `common`.

The workflow uses the built-in Actions `GITHUB_TOKEN` with contents, pull-request and actions write permissions; no repository secret is needed. Updatecli commits through the GitHub API to the working branch `updatecli_master_upstream-<id>` and creates or updates one PR per component. PRs created with the built-in token do not trigger `pull_request` workflows, so the workflow then dispatches `ci.yaml` on every open `updatecli_master_upstream-*` branch. That run reports `CI Passed` on the branch head.

PR merge strategy is `manual`. Update branches are force-pushed: an outdated PR is recreated from `master` by the next run, and manual commits on an update branch are discarded by the next run that changes the component. Resolve components manually in a separate PR. Validation and publication of merged changes remain with the repository CI and publish workflows.

The equivalent invocation from the repository root opens real PRs:

```sh
dagger -m github.com/riftonix/daggerverse/scenarios/helm-ci@scenarios/helm-ci/v1.4.0 call --source=. \
  sync-charts-update --github-token=env:GITHUB_TOKEN --repository=riftonix/helm-shared --branch=master \
  --components=traefik
```

Omit `--components` to run all components.

## How an update is prepared

Chart sync builds the complete result before Updatecli can commit it or open a PR:

1. Helm pulls the pinned and the selected upstream packages into separate temporary directories, and the pinned package digest is compared with the pin.
2. Both packages are copied without excluded paths and rewritten by the rules from `values.yaml`.
3. `git merge-tree` merges the full directories with the current fork, including additions, deletions and renames.
4. Git checks the patch against the checkout. Only then are the component directory and its pin written.

Rewrite rules run in this order:

1. `https://github.com/nixys/<upstream>` becomes `<home>/tree/master/<path>` for every component.
2. Shared `rewrite` rules: OCI paths, dash characters and removal of foreign `Chart.yaml` metadata (`icon`, `home`, `maintainers`, `annotations`).
3. Each upstream chart name becomes its component ID, for example `nuc-certificates` becomes `cert-manager`.
4. The component's own `rewrite` rules. For appchart, these replace the README heading and branding.

A rule replaces the literal `from`, or the Python regular expression `regex` when set. `file` limits a rule to one chart-relative path. Binary files are not rewritten.

Fork-only content is not part of the upstream packages, so the merge keeps it as local edits. This covers the fork's `home` and `annotations` in `Chart.yaml`, Renovate image pins, `docs/README.md.gotmpl`, tests and other local files. `upstream.exclude` drops upstream `.github/`, `docs/AGENTS.md`, `CHANGELOG.md` and `LICENSE`. Vendored `charts/` and `Chart.lock` are never merged.

## Dependencies

Charts keep no `Chart.lock`; it is ignored by Git. Dependency versions in `Chart.yaml` must be exact. CI and publication resolve dependencies with `helm dependency update`.

## Failures and manual merge order

A component fails without writing the checkout or creating a PR when:

- the upstream registry cannot be reached, or no tag matches the version filter;
- the pinned package digest does not match;
- the merge has a content conflict;
- the chart changed but its version did not advance (fork and upstream version collision).

Other components are still updated, and the workflow run fails and names the failed component. A dependency that is not yet published fails the PR's CI, not the update: merge the dependency's PR, wait for its artifact to be published, then rerun the CI.

## Local preview

Prerequisites: Dagger `0.21.10` or later. Package downloads expect an anonymously readable registry; no credentials are needed.

Preview one component without writing the checkout:

```sh
dagger -m github.com/riftonix/daggerverse/scenarios/helm-ci@scenarios/helm-ci/v1.4.0 call --source=. \
  sync-charts-diff --components=traefik
```

Write the synchronized component and pin into the checkout:

```sh
dagger -m github.com/riftonix/daggerverse/scenarios/helm-ci@scenarios/helm-ci/v1.4.0 call --source=. \
  sync-charts --components=traefik export --path=.
```

## Registering a component

Add its chart directory, an entry in `updatecli/values.yaml` and a pin file with a verified upstream OCI version and digest.
