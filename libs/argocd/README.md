# Argo CD

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/argocd)](https://artifacthub.io/packages/search?repo=argocd)

Helm chart for rendering Argo CD custom resources from declarative values.

The chart does not install Argo CD itself and does not manage Argo CD CRDs as chart templates. It only renders `Application`, `ApplicationSet`, and `AppProject` objects that are already supported by the target cluster.

## Quick Start

Install the chart:

```bash
helm install argocd oci://ghcr.io/riftonix/helm-shared/libs/argocd \
  --namespace argocd \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

- `Application`
- `ApplicationSet`
- `AppProject`

## Values Model

Each top-level map in [values.yaml](values.yaml) maps resource names to one Argo CD kind:

- `applications`
- `applicationSets`
- `appProjects`

Every map entry uses the same generic contract:

| Field | Required | Description |
|-------|----------|-------------|
| map key | yes | Resource name used for `metadata.name`. |
| `namespace` | no | Namespace for the rendered resource. Defaults to the Helm release namespace. |
| `labels` | no | Labels merged on top of built-in chart labels and `commonLabels`. |
| `annotations` | no | Annotations merged on top of `commonAnnotations`. |
| `apiVersion` | no | Per-resource API version override. |
| `spec` | no | Raw resource spec rendered as-is. |
| `status` | no | Optional raw status block. Usually not managed through Helm in production. |

Setting a map entry to `null` in a higher-precedence values file suppresses the default resource from a lower-precedence values file.

Global controls:

- `enabled`
- `global`
- `nameOverride`
- `commonLabels`
- `commonAnnotations`
- `apiVersions.*`

The value contract is validated by [values.schema.json](values.schema.json).

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` or `make docs`.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions.appProject | string | `"argoproj.io/v1alpha1"` | Default apiVersion for AppProject resources. |
| apiVersions.application | string | `"argoproj.io/v1alpha1"` | Default apiVersion for Application resources. |
| apiVersions.applicationSet | string | `"argoproj.io/v1alpha1"` | Default apiVersion for ApplicationSet resources. |
| appProjects | object | {} | AppProject resources keyed by resource name. |
| appProjects.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| appProjects.__helm_docs_example__.apiVersion | string | chart default for this kind | Per-resource apiVersion override. |
| appProjects.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| appProjects.__helm_docs_example__.namespace | string | release namespace | Namespace for namespaced resources. Defaults to the Helm release namespace. |
| appProjects.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| appProjects.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| applicationSets | object | {} | ApplicationSet resources keyed by resource name. |
| applicationSets.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| applicationSets.__helm_docs_example__.apiVersion | string | chart default for this kind | Per-resource apiVersion override. |
| applicationSets.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| applicationSets.__helm_docs_example__.namespace | string | release namespace | Namespace for namespaced resources. Defaults to the Helm release namespace. |
| applicationSets.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| applicationSets.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| applications | object | {} | Application resources keyed by resource name. |
| applications.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| applications.__helm_docs_example__.apiVersion | string | chart default for this kind | Per-resource apiVersion override. |
| applications.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| applications.__helm_docs_example__.namespace | string | release namespace | Namespace for namespaced resources. Defaults to the Helm release namespace. |
| applications.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| applications.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` | Enable argocd chart rendering. |
| global | object | `{}` | Compatibility values inherited from umbrella charts. Accepted but ignored by this chart. |
| nameOverride | string | `""` | Override the default chart label name if needed. |

## Included Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources.
- [values.yaml.example](values.yaml.example): complete example covering every supported resource type.

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward compatibility checks
- `tests/e2e/` for local kind-based Helm install checks against real Argo CD CRDs
- `tests/smokes/` for render, schema, and example scenarios

Representative local commands:

```bash
helm lint . -f values.yaml.example
helm template argocd . -f values.yaml.example
helm unittest -f 'tests/units/*_test.yaml' .
sh tests/units/backward_compatibility_test.sh
python3 tests/smokes/run/smoke.py --scenario example-render
make test-e2e
```

Detailed test documentation is available in [docs/TESTS.MD](docs/TESTS.MD).

## Notes

- Keep the chart API versions aligned with the Argo CD CRDs installed in the cluster.
- The chart is intentionally generic: resource `spec` blocks are passed through as-is.
- Prefer managing `spec` through Helm and let Argo CD own `status`.
