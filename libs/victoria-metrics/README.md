# Victoria Metrics

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/victoria-metrics)](https://artifacthub.io/packages/search?repo=victoria-metrics)

Helm chart for rendering VictoriaMetrics Operator custom resources from declarative values.

The chart does not install the VictoriaMetrics Operator or its CRDs. It only renders custom resources that the target cluster already serves.

## Quick Start

Install the chart:

```bash
helm install victoria-metrics oci://ghcr.io/riftonix/helm-shared/libs/victoria-metrics \
  --namespace victoria-metrics \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these VictoriaMetrics Operator kinds:

- `VMAlert`
- `VMProbe`
- `VMRule`
- `VMScrapeConfig`
- `VMServiceScrape`
- `VMStaticScrape`

All currently supported kinds are namespaced.

## Values Model

Each top-level map in [values.yaml](values.yaml) maps to one resource kind:

- `vmAlerts`
- `vmProbes`
- `vmRules`
- `vmScrapeConfigs`
- `vmServiceScrapes`
- `vmStaticScrapes`

Every map value uses the same generic contract:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | yes | Resource name. |
| `namespace` | no | Namespace for the resource. Defaults to the Helm release namespace. |
| `labels` | no | Labels merged on top of built-in chart labels and `commonLabels`. |
| `annotations` | no | Annotations merged on top of `commonAnnotations`. |
| `apiVersion` | no | Per-resource API version override. |
| `spec` | no | Raw resource spec rendered as-is. |
| `status` | no | Optional raw status block. Usually not managed through Helm in production. |

The top-level map key is a stable entry identifier. `metadata.name` still comes from the `name` field inside each value object.

In a higher-precedence values file, set a map entry to `null` to suppress a default resource from a lower-precedence values file.

Global controls:

- `enabled`
- `global` (accepted for umbrella-chart compatibility and ignored by this chart)
- `nameOverride`
- `commonLabels`
- `commonAnnotations`
- `apiVersions.*`

The value contract is validated by [values.schema.json](values.schema.json).

## Helm Values

This section is generated from [values.docs.yaml](values.docs.yaml) by `helm-docs`. Edit [values.docs.yaml](values.docs.yaml) comments when the public values contract changes, keep [values.yaml](values.yaml) runtime defaults minimal, and run `pre-commit run helm-docs --all-files` or `make docs` to refresh the README.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions | object | `{"vmAlert":"operator.victoriametrics.com/v1beta1","vmProbe":"operator.victoriametrics.com/v1beta1","vmRule":"operator.victoriametrics.com/v1beta1","vmScrapeConfig":"operator.victoriametrics.com/v1beta1","vmServiceScrape":"operator.victoriametrics.com/v1beta1","vmStaticScrape":"operator.victoriametrics.com/v1beta1"}` | Default apiVersion overrides per supported VictoriaMetrics Operator kind. |
| apiVersions.vmAlert | string | `"operator.victoriametrics.com/v1beta1"` | Default apiVersion for VMAlert resources. |
| apiVersions.vmProbe | string | `"operator.victoriametrics.com/v1beta1"` | Default apiVersion for VMProbe resources. |
| apiVersions.vmRule | string | `"operator.victoriametrics.com/v1beta1"` | Default apiVersion for VMRule resources. |
| apiVersions.vmScrapeConfig | string | `"operator.victoriametrics.com/v1beta1"` | Default apiVersion for VMScrapeConfig resources. |
| apiVersions.vmServiceScrape | string | `"operator.victoriametrics.com/v1beta1"` | Default apiVersion for VMServiceScrape resources. |
| apiVersions.vmStaticScrape | string | `"operator.victoriametrics.com/v1beta1"` | Default apiVersion for VMStaticScrape resources. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` | Enable victoria-metrics chart rendering. |
| global | object | `{}` | Compatibility values inherited from umbrella charts. Accepted but ignored by this chart. |
| nameOverride | string | `""` | Override the default chart label name if needed. |
| vmAlerts | object | {} | VMAlert resources to render. |
| vmAlerts.example.annotations | object | {} | Resource-specific annotations merged with chart annotations. |
| vmAlerts.example.apiVersion | string | .Values.apiVersions.vmAlert | Optional apiVersion override for this resource. |
| vmAlerts.example.labels | object | {} | Resource-specific labels merged with chart labels. |
| vmAlerts.example.name | string | required | Resource name. |
| vmAlerts.example.namespace | string | .Release.Namespace | Namespace for the resource. Defaults to the release namespace. |
| vmAlerts.example.spec | object | {} | Raw VMAlert spec rendered as-is. |
| vmAlerts.example.status | object | not set | Optional raw resource status rendered as-is. |
| vmProbes | object | {} | VMProbe resources to render. |
| vmProbes.example.annotations | object | {} | Resource-specific annotations merged with chart annotations. |
| vmProbes.example.apiVersion | string | .Values.apiVersions.vmProbe | Optional apiVersion override for this resource. |
| vmProbes.example.labels | object | {} | Resource-specific labels merged with chart labels. |
| vmProbes.example.name | string | required | Resource name. |
| vmProbes.example.namespace | string | .Release.Namespace | Namespace for the resource. Defaults to the release namespace. |
| vmProbes.example.spec | object | {} | Raw VMProbe spec rendered as-is. |
| vmProbes.example.status | object | not set | Optional raw resource status rendered as-is. |
| vmRules | object | {} | VMRule resources to render. |
| vmRules.example.annotations | object | {} | Resource-specific annotations merged with chart annotations. |
| vmRules.example.apiVersion | string | .Values.apiVersions.vmRule | Optional apiVersion override for this resource. |
| vmRules.example.labels | object | {} | Resource-specific labels merged with chart labels. |
| vmRules.example.name | string | required | Resource name. |
| vmRules.example.namespace | string | .Release.Namespace | Namespace for the resource. Defaults to the release namespace. |
| vmRules.example.spec | object | {} | Raw VMRule spec rendered as-is. |
| vmRules.example.status | object | not set | Optional raw resource status rendered as-is. |
| vmScrapeConfigs | object | {} | VMScrapeConfig resources to render. |
| vmScrapeConfigs.example.annotations | object | {} | Resource-specific annotations merged with chart annotations. |
| vmScrapeConfigs.example.apiVersion | string | .Values.apiVersions.vmScrapeConfig | Optional apiVersion override for this resource. |
| vmScrapeConfigs.example.labels | object | {} | Resource-specific labels merged with chart labels. |
| vmScrapeConfigs.example.name | string | required | Resource name. |
| vmScrapeConfigs.example.namespace | string | .Release.Namespace | Namespace for the resource. Defaults to the release namespace. |
| vmScrapeConfigs.example.spec | object | {} | Raw VMScrapeConfig spec rendered as-is. |
| vmScrapeConfigs.example.status | object | not set | Optional raw resource status rendered as-is. |
| vmServiceScrapes | object | {} | VMServiceScrape resources to render. |
| vmServiceScrapes.example.annotations | object | {} | Resource-specific annotations merged with chart annotations. |
| vmServiceScrapes.example.apiVersion | string | .Values.apiVersions.vmServiceScrape | Optional apiVersion override for this resource. |
| vmServiceScrapes.example.labels | object | {} | Resource-specific labels merged with chart labels. |
| vmServiceScrapes.example.name | string | required | Resource name. |
| vmServiceScrapes.example.namespace | string | .Release.Namespace | Namespace for the resource. Defaults to the release namespace. |
| vmServiceScrapes.example.spec | object | {} | Raw VMServiceScrape spec rendered as-is. |
| vmServiceScrapes.example.status | object | not set | Optional raw resource status rendered as-is. |
| vmStaticScrapes | object | {} | VMStaticScrape resources to render. |
| vmStaticScrapes.example.annotations | object | {} | Resource-specific annotations merged with chart annotations. |
| vmStaticScrapes.example.apiVersion | string | .Values.apiVersions.vmStaticScrape | Optional apiVersion override for this resource. |
| vmStaticScrapes.example.labels | object | {} | Resource-specific labels merged with chart labels. |
| vmStaticScrapes.example.name | string | required | Resource name. |
| vmStaticScrapes.example.namespace | string | .Release.Namespace | Namespace for the resource. Defaults to the release namespace. |
| vmStaticScrapes.example.spec | object | {} | Raw VMStaticScrape spec rendered as-is. |
| vmStaticScrapes.example.status | object | not set | Optional raw resource status rendered as-is. |

## Included Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources.
- [values.docs.yaml](values.docs.yaml): expanded `helm-docs` source that exposes nested value fields in the generated README.
- [values.yaml.example](values.yaml.example): complete example covering every supported resource type.

Use [values.yaml.example](values.yaml.example) as a starting point and remove the sections you do not need.

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward compatibility checks
- `tests/e2e/` for local kind-based Helm install checks against vendored VictoriaMetrics Operator CRDs
- `tests/smokes/` for render and schema smoke scenarios

Representative local commands:

```bash
helm lint . -f values.yaml.example
helm template victoria-metrics . -f values.yaml.example
helm unittest -f 'tests/units/*_test.yaml' .
sh tests/units/backward_compatibility_test.sh
python3 tests/smokes/run/smoke.py --scenario example-render
make test-e2e
```

Detailed test documentation is available in [docs/TESTS.MD](docs/TESTS.MD).

Local setup instructions for the development and test toolchain are available in [docs/DEPENDENCY.md](docs/DEPENDENCY.md).

The `e2e` layer is intentionally kept out of GitLab CI and is expected to be run locally through [Makefile](Makefile) or directly via `tests/e2e/test-e2e.sh`.

## Notes

- Keep the chart API versions aligned with the VictoriaMetrics CRD versions served by your cluster.
- `tests/e2e/crds/victoriametrics-operator-crds.yaml` vendors the six CRDs exercised by this chart from the upstream operator bundle.
- `tests/schemas/` contains vendored JSON schemas derived from the same CRD source for deterministic `kubeconform` validation.
- Prefer managing `spec` through Helm and let the operator own `status`.

## Repository Layout

| Path | Purpose |
|------|---------|
| [Chart.yaml](Chart.yaml) | Chart metadata. |
| [values.yaml](values.yaml) | Minimal runtime defaults that render no resources. |
| [values.docs.yaml](values.docs.yaml) | Expanded `helm-docs` source for the generated values table. |
| [docs/README.md.gotmpl](docs/README.md.gotmpl) | Template used by `helm-docs` to build `README.md`. |
| [.pre-commit-config.yaml](.pre-commit-config.yaml) | Local hooks, including automatic `helm-docs` generation on commit. |
| [values.yaml.example](values.yaml.example) | Full example configuration. |
| [values.schema.json](values.schema.json) | JSON schema for chart values. |
| [templates/](templates) | One template per supported VictoriaMetrics Operator kind plus shared helpers. |
| [tests/units/](tests/units) | Compact Helm unit suites and backward compatibility checks. |
| [tests/e2e/](tests/e2e) | kind-based end-to-end installation checks. |
| [tests/schemas/](tests/schemas) | Vendored CRD JSON schemas used by `kubeconform`. |
| [tests/smokes/](tests/smokes) | Smoke scenarios for render and schema validation. |
| [docs/DEPENDENCY.md](docs/DEPENDENCY.md) | Local dependency installation guide for development and tests. |
| [docs/TESTS.MD](docs/TESTS.MD) | Detailed testing documentation. |
