# ELK

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/elk)](https://artifacthub.io/packages/search?repo=elk)

Helm chart for rendering Elastic Cloud on Kubernetes (ECK) custom resources from declarative values.

The chart does not install ECK CRDs. It only renders custom resources for clusters where the corresponding ECK CRDs are already present.

## Quick Start

Install the chart:

```bash
helm install elk oci://ghcr.io/riftonix/helm-shared/libs/elk \
  --namespace observability \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these ECK kinds:

- `Elasticsearch`
- `Kibana`
- `ApmServer`
- `Beat`
- `Agent`
- `EnterpriseSearch`
- `ElasticMapsServer`
- `Logstash`

Support for individual fields still depends on the ECK CRDs installed in the target cluster.

## Values Model

Each top-level map in [values.yaml](values.yaml) maps to one resource kind:

- `elasticsearches`
- `kibanas`
- `apmservers`
- `beats`
- `agents`
- `enterprisesearches`
- `elasticmapsservers`
- `logstashes`

Per-resource controls:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | no | Explicit resource name override. By default the top-level key is used as `metadata.name`. |
| `namespace` | no | Namespace override; defaults to release namespace. |
| `labels` | no | Labels merged on top of chart labels and common labels. |
| `annotations` | no | Annotations merged on top of common annotations. |
| `apiVersion` | no | API version override for a single resource. |
| `spec` | no | Raw resource `spec` rendered as-is. |
| `status` | no | Optional raw `status` block for fixtures/synthetic manifests. |

Global controls:

- `nameOverride`
- `generic.labels`
- `generic.annotations`
- `apiVersions.*`
- `global.apiVersions.eck*` legacy overrides

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` to refresh it.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| agents | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"agent.k8s.elastic.co/v1alpha1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{},"status":{}}}` | Agent resources keyed by resource name. |
| agents.__helm_docs_example__.annotations | object | `{}` | Additional annotations merged with common annotations. |
| agents.__helm_docs_example__.apiVersion | string | `"agent.k8s.elastic.co/v1alpha1"` | Optional apiVersion override for this single resource. |
| agents.__helm_docs_example__.labels | object | `{}` | Additional labels merged with chart and common labels. |
| agents.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| agents.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace override. Defaults to `.Release.Namespace`. |
| agents.__helm_docs_example__.spec | object | `{}` | Raw ECK `spec` block rendered as-is. |
| agents.__helm_docs_example__.status | object | `{}` | Optional raw `status` block for fixtures/tests. |
| apiVersions.agent | string | `"agent.k8s.elastic.co/v1alpha1"` |  |
| apiVersions.apmServer | string | `"apm.k8s.elastic.co/v1"` |  |
| apiVersions.beat | string | `"beat.k8s.elastic.co/v1beta1"` |  |
| apiVersions.elasticMapsServer | string | `"maps.k8s.elastic.co/v1alpha1"` |  |
| apiVersions.elasticsearch | string | `"elasticsearch.k8s.elastic.co/v1"` |  |
| apiVersions.enterpriseSearch | string | `"enterprisesearch.k8s.elastic.co/v1"` |  |
| apiVersions.kibana | string | `"kibana.k8s.elastic.co/v1"` |  |
| apiVersions.logstash | string | `"logstash.k8s.elastic.co/v1alpha1"` |  |
| apmservers | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"apm.k8s.elastic.co/v1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{},"status":{}}}` | ApmServer resources keyed by resource name. |
| apmservers.__helm_docs_example__.annotations | object | `{}` | Additional annotations merged with common annotations. |
| apmservers.__helm_docs_example__.apiVersion | string | `"apm.k8s.elastic.co/v1"` | Optional apiVersion override for this single resource. |
| apmservers.__helm_docs_example__.labels | object | `{}` | Additional labels merged with chart and common labels. |
| apmservers.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| apmservers.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace override. Defaults to `.Release.Namespace`. |
| apmservers.__helm_docs_example__.spec | object | `{}` | Raw ECK `spec` block rendered as-is. |
| apmservers.__helm_docs_example__.status | object | `{}` | Optional raw `status` block for fixtures/tests. |
| beats | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"beat.k8s.elastic.co/v1beta1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{},"status":{}}}` | Beat resources keyed by resource name. |
| beats.__helm_docs_example__.annotations | object | `{}` | Additional annotations merged with common annotations. |
| beats.__helm_docs_example__.apiVersion | string | `"beat.k8s.elastic.co/v1beta1"` | Optional apiVersion override for this single resource. |
| beats.__helm_docs_example__.labels | object | `{}` | Additional labels merged with chart and common labels. |
| beats.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| beats.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace override. Defaults to `.Release.Namespace`. |
| beats.__helm_docs_example__.spec | object | `{}` | Raw ECK `spec` block rendered as-is. |
| beats.__helm_docs_example__.status | object | `{}` | Optional raw `status` block for fixtures/tests. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| elasticmapsservers | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"maps.k8s.elastic.co/v1alpha1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{},"status":{}}}` | ElasticMapsServer resources keyed by resource name. |
| elasticmapsservers.__helm_docs_example__.annotations | object | `{}` | Additional annotations merged with common annotations. |
| elasticmapsservers.__helm_docs_example__.apiVersion | string | `"maps.k8s.elastic.co/v1alpha1"` | Optional apiVersion override for this single resource. |
| elasticmapsservers.__helm_docs_example__.labels | object | `{}` | Additional labels merged with chart and common labels. |
| elasticmapsservers.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| elasticmapsservers.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace override. Defaults to `.Release.Namespace`. |
| elasticmapsservers.__helm_docs_example__.spec | object | `{}` | Raw ECK `spec` block rendered as-is. |
| elasticmapsservers.__helm_docs_example__.status | object | `{}` | Optional raw `status` block for fixtures/tests. |
| elasticsearches | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"elasticsearch.k8s.elastic.co/v1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{},"status":{}}}` | Elasticsearch resources keyed by resource name. |
| elasticsearches.__helm_docs_example__.annotations | object | `{}` | Additional annotations merged with common annotations. |
| elasticsearches.__helm_docs_example__.apiVersion | string | `"elasticsearch.k8s.elastic.co/v1"` | Optional apiVersion override for this single resource. |
| elasticsearches.__helm_docs_example__.labels | object | `{}` | Additional labels merged with chart and common labels. |
| elasticsearches.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| elasticsearches.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace override. Defaults to `.Release.Namespace`. |
| elasticsearches.__helm_docs_example__.spec | object | `{}` | Raw ECK `spec` block rendered as-is. |
| elasticsearches.__helm_docs_example__.status | object | `{}` | Optional raw `status` block for fixtures/tests. |
| enabled | bool | `true` | Enable elk chart rendering. |
| enterprisesearches | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"enterprisesearch.k8s.elastic.co/v1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{},"status":{}}}` | EnterpriseSearch resources keyed by resource name. |
| enterprisesearches.__helm_docs_example__.annotations | object | `{}` | Additional annotations merged with common annotations. |
| enterprisesearches.__helm_docs_example__.apiVersion | string | `"enterprisesearch.k8s.elastic.co/v1"` | Optional apiVersion override for this single resource. |
| enterprisesearches.__helm_docs_example__.labels | object | `{}` | Additional labels merged with chart and common labels. |
| enterprisesearches.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| enterprisesearches.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace override. Defaults to `.Release.Namespace`. |
| enterprisesearches.__helm_docs_example__.spec | object | `{}` | Raw ECK `spec` block rendered as-is. |
| enterprisesearches.__helm_docs_example__.status | object | `{}` | Optional raw `status` block for fixtures/tests. |
| generic | object | `{"annotations":{},"labels":{}}` | Shared metadata and templating values compatible with appchart. |
| generic.annotations | object | `{}` | Annotations merged into every rendered resource. |
| generic.labels | object | `{}` | Labels merged into every rendered resource. |
| global | object | `{}` | Compatibility values inherited from umbrella charts. |
| kibanas | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kibana.k8s.elastic.co/v1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{},"status":{}}}` | Kibana resources keyed by resource name. |
| kibanas.__helm_docs_example__.annotations | object | `{}` | Additional annotations merged with common annotations. |
| kibanas.__helm_docs_example__.apiVersion | string | `"kibana.k8s.elastic.co/v1"` | Optional apiVersion override for this single resource. |
| kibanas.__helm_docs_example__.labels | object | `{}` | Additional labels merged with chart and common labels. |
| kibanas.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| kibanas.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace override. Defaults to `.Release.Namespace`. |
| kibanas.__helm_docs_example__.spec | object | `{}` | Raw ECK `spec` block rendered as-is. |
| kibanas.__helm_docs_example__.status | object | `{}` | Optional raw `status` block for fixtures/tests. |
| logstashes | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"logstash.k8s.elastic.co/v1alpha1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{},"status":{}}}` | Logstash resources keyed by resource name. |
| logstashes.__helm_docs_example__.annotations | object | `{}` | Additional annotations merged with common annotations. |
| logstashes.__helm_docs_example__.apiVersion | string | `"logstash.k8s.elastic.co/v1alpha1"` | Optional apiVersion override for this single resource. |
| logstashes.__helm_docs_example__.labels | object | `{}` | Additional labels merged with chart and common labels. |
| logstashes.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| logstashes.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace override. Defaults to `.Release.Namespace`. |
| logstashes.__helm_docs_example__.spec | object | `{}` | Raw ECK `spec` block rendered as-is. |
| logstashes.__helm_docs_example__.status | object | `{}` | Optional raw `status` block for fixtures/tests. |
| nameOverride | string | `""` | Override the default chart label name if needed. |

## Representative Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources
- [values.yaml.example](values.yaml.example): representative fixture covering all supported resource types
- [tests/smokes/fixtures/example.values.yaml](tests/smokes/fixtures/example.values.yaml): smoke-test fixture

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward-compatibility checks
- `tests/smokes/` for render-path smoke scenarios
- `tests/e2e/` for local kind-based Helm install checks against real ECK CRDs

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

- Keep the chart API versions aligned with the ECK CRDs installed in the cluster.
- This chart renders custom resources only and does not install CRDs.

## Repository Layout

| Path | Purpose |
|------|---------|
| [Chart.yaml](Chart.yaml) | Chart metadata. |
| [values.yaml](values.yaml) | Minimal default values and `helm-docs` source comments. |
| [values.schema.json](values.schema.json) | JSON schema for values validation. |
| [docs/README.md.gotmpl](docs/README.md.gotmpl) | Template used by `helm-docs` to build `README.md`. |
| [.pre-commit-config.yaml](.pre-commit-config.yaml) | Local hooks, including automatic `helm-docs` generation on commit. |
| [templates/](templates) | ECK custom resource templates. |
| [tests/units/](tests/units) | Compact Helm unit suites and backward compatibility checks. |
| [tests/e2e/](tests/e2e) | Local kind-based end-to-end installation checks. |
| [tests/smokes/](tests/smokes) | Smoke scenarios for render validation. |
| [docs/DEPENDENCY.md](docs/DEPENDENCY.md) | Local dependency installation guide for development and tests. |
| [docs/TESTS.MD](docs/TESTS.MD) | Detailed testing documentation. |
