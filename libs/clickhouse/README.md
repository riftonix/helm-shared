# ClickHouse

Helm chart for rendering Altinity ClickHouse Operator custom resources from declarative values.

The chart does not install the Altinity operator CRDs by itself. It renders only operator-managed resources for clusters where the corresponding CRDs already exist.

## Quick Start

Install the chart:

```bash
helm install clickhouse . \
  --namespace clickhouse \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these Altinity ClickHouse Operator kinds:

- `ClickHouseInstallation`
- `ClickHouseInstallationTemplate`
- `ClickHouseOperatorConfiguration`
- `ClickHouseKeeperInstallation`

Support for individual fields still depends on the Altinity CRDs installed in the target cluster.

## Values Model

Each top-level map in [values.yaml](values.yaml) maps to one resource kind:

- `clickhouseinstallations`
- `clickhouseinstallationtemplates`
- `clickhouseoperatorconfigurations`
- `clickhousekeeperinstallations`

Per-resource controls:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | no | Resource name. Defaults to the top-level map key. |
| `namespace` | no | Resource namespace. Defaults to the Helm release namespace. |
| `labels` | no | Labels merged on top of the chart's built-in common labels. |
| `annotations` | no | Annotations merged on top of `commonAnnotations` and `generic.annotations`. |
| `apiVersion` | no | Per-resource API version override. |
| `spec` | no | Raw Altinity resource spec rendered as-is. For `ClickHouseOperatorConfiguration`, use the official operator structure, including `spec.watch.namespaces.include` / `exclude` when needed. |
| `status` | no | Optional raw status block for fixtures and synthetic manifests. |

Global controls:

- `nameOverride`
- `commonLabels`
- `commonAnnotations`
- `generic.labels`
- `generic.annotations`
- `apiVersions.clickhouseInstallation`
- `apiVersions.clickhouseInstallationTemplate`
- `apiVersions.clickhouseOperatorConfiguration`
- `apiVersions.clickhouseKeeperInstallation`

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` to refresh it.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions | object | `{"clickhouseInstallation":"clickhouse.altinity.com/v1","clickhouseInstallationTemplate":"clickhouse.altinity.com/v1","clickhouseKeeperInstallation":"clickhouse-keeper.altinity.com/v1","clickhouseOperatorConfiguration":"clickhouse.altinity.com/v1"}` | Override these defaults if your cluster uses different ClickHouse Operator API versions. |
| clickhouseinstallations | object | `{"__helm_docs_example__":{"annotations":{"docs.altinity.example/type":"chi"},"apiVersion":"clickhouse.altinity.com/v1","labels":{"app.kubernetes.io/component":"clickhouse"},"name":"documentation-clickhouse-installation","namespace":"documentation-placeholder","spec":{"configuration":{"clusters":[{"layout":{"replicasCount":1,"shardsCount":1},"name":"example"}],"users":{"example/networks/ip":["0.0.0.0/0"],"example/password_sha256_hex":""}},"defaults":{"templates":{"dataVolumeClaimTemplate":"data-volume","podTemplate":"clickhouse-v24"}},"templates":{"podTemplates":[{"name":"clickhouse-v24","spec":{"containers":[{"image":"clickhouse/clickhouse-server:24.8","name":"clickhouse"}]}}],"volumeClaimTemplates":[{"name":"data-volume","spec":{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"10Gi"}}}}]}},"status":{}}}` | ClickHouseInstallation resources keyed by resource name. |
| clickhouseinstallationtemplates | object | `{"__helm_docs_example__":{"annotations":{"docs.altinity.example/type":"chit"},"apiVersion":"clickhouse.altinity.com/v1","labels":{"app.kubernetes.io/component":"template"},"name":"documentation-clickhouse-template","namespace":"documentation-placeholder","spec":{"templates":{"podTemplates":[{"name":"shared-clickhouse-pod","spec":{"containers":[{"image":"clickhouse/clickhouse-server:24.8","name":"clickhouse"}]}}],"volumeClaimTemplates":[{"name":"shared-data-volume","spec":{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"20Gi"}}}}]}},"status":{}}}` | ClickHouseInstallationTemplate resources keyed by resource name. |
| clickhousekeeperinstallations | object | `{"__helm_docs_example__":{"annotations":{"docs.altinity.example/type":"chk"},"apiVersion":"clickhouse-keeper.altinity.com/v1","labels":{"app.kubernetes.io/component":"keeper"},"name":"documentation-clickhouse-keeper","namespace":"documentation-placeholder","spec":{"configuration":{"clusters":[{"layout":{"replicasCount":3},"name":"keeper","templates":{"podTemplate":"keeper-default","volumeClaimTemplate":"keeper-data"}}]},"templates":{"podTemplates":[{"name":"keeper-default","spec":{"containers":[{"image":"clickhouse/clickhouse-keeper:24.8","name":"clickhouse-keeper"}]}}],"volumeClaimTemplates":[{"name":"keeper-data","spec":{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"5Gi"}}}}]}},"status":{}}}` | ClickHouseKeeperInstallation resources keyed by resource name. |
| clickhouseoperatorconfigurations | object | `{"__helm_docs_example__":{"annotations":{"docs.altinity.example/type":"chopconf"},"apiVersion":"clickhouse.altinity.com/v1","labels":{"app.kubernetes.io/component":"operator-config"},"name":"documentation-clickhouse-operator","namespace":"documentation-placeholder","spec":{"clickhouse":{"access":{"password":"clickhouse_operator_password","port":8123,"username":"clickhouse_operator"}},"reconcile":{"runtime":{"reconcileCHIsThreadsNumber":5}},"watch":{"namespaces":{"include":["documentation-placeholder"]}}},"status":{}}}` | ClickHouseOperatorConfiguration resources keyed by resource name. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` | Enable clickhouse chart rendering. |
| generic | object | `{"annotations":{},"labels":{}}` | Shared metadata and templating values compatible with appchart. |
| global | object | `{"apiVersions":{}}` | Compatibility values inherited from umbrella charts. |
| nameOverride | string | `""` | Override the default chart label name if needed. |

## Representative Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources
- [values.yaml.example](values.yaml.example): representative example covering all supported resource types
- [tests/smokes/fixtures/example.values.yaml](tests/smokes/fixtures/example.values.yaml): smoke-test fixture for render and kubeconform checks
- [tests/units/values/example.values.yaml](tests/units/values/example.values.yaml): unit-test fixture for representative resource checks

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward-compatibility checks
- `tests/smokes/` for render-path smoke scenarios
- `tests/e2e/` for local kind-based Helm install checks against real Altinity ClickHouse Operator CRDs

Representative local commands:

```bash
helm lint . -f tests/smokes/fixtures/example.values.yaml
helm unittest -f 'tests/units/*_test.yaml' .
sh tests/units/backward_compatibility_test.sh
python3 tests/smokes/run/smoke.py
make test-e2e
```

Detailed test documentation is available in [docs/TESTS.MD](docs/TESTS.MD).

Local setup instructions for the development and test toolchain are available in [docs/DEPENDENCY.md](docs/DEPENDENCY.md).

The `e2e` layer is intentionally kept out of GitLab CI and is expected to be run locally through [Makefile](Makefile) or directly via [tests/e2e/test-e2e.sh](tests/e2e/test-e2e.sh).

## Notes

- Keep the chart API versions aligned with the Altinity CRDs installed in the cluster.
- The chart renders only CR instances and does not manage the Altinity operator release lifecycle.

## Repository Layout

| Path | Purpose |
|------|---------|
| [Chart.yaml](Chart.yaml) | Chart metadata. |
| [values.yaml](values.yaml) | Minimal default values and `helm-docs` source comments. |
| [docs/README.md.gotmpl](docs/README.md.gotmpl) | Template used by `helm-docs` to build `README.md`. |
| [.pre-commit-config.yaml](.pre-commit-config.yaml) | Local hooks, including automatic `helm-docs` generation on commit. |
| [templates/](templates) | Altinity ClickHouse Operator resource templates. |
| [tests/units/](tests/units) | Compact Helm unit suites and backward compatibility checks. |
| [tests/e2e/](tests/e2e) | Local kind-based end-to-end installation checks. |
| [tests/smokes/](tests/smokes) | Smoke scenarios for render validation and schema checks. |
| [docs/DEPENDENCY.md](docs/DEPENDENCY.md) | Local dependency installation guide for development and tests. |
| [docs/TESTS.MD](docs/TESTS.MD) | Detailed testing documentation. |
