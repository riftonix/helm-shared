# RabbitMQ

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/rabbitmq)](https://artifacthub.io/packages/search?repo=rabbitmq)

Helm chart for rendering RabbitMQ operator custom resources from declarative values.

The chart does not install the RabbitMQ operators themselves and does not ship CRDs. It only renders `RabbitmqCluster` and Messaging Topology Operator resources for clusters where the corresponding CRDs are already present.

## Quick Start

Install the chart:

```bash
helm install rabbitmq oci://ghcr.io/riftonix/helm-shared/libs/rabbitmq \
  --namespace rabbitmq \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these RabbitMQ kinds:

- `RabbitmqCluster`
- `Queue`
- `Policy`
- `Exchange`
- `Binding`
- `User`
- `Permission`
- `Vhost`
- `Federation`
- `Shovel`

Support for individual fields still depends on the CRDs and operator versions installed in the target cluster.

## Values Model

Each top-level map in [values.yaml](values.yaml) maps to one resource kind:

- `rabbitmqclusters`
- `queues`
- `policies`
- `exchanges`
- `bindings`
- `users`
- `permissions`
- `vhosts`
- `federations`
- `shovels`

Per-resource controls shared by all collections:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | no | Explicit `metadata.name` override. Defaults to the resource map key. |
| `namespace` | no | Namespace override. Defaults to the release namespace. |
| `labels` | no | Labels merged on top of the chart's built-in common labels. |
| `annotations` | no | Annotations merged on top of `generic.annotations`. |
| `apiVersion` | no | Per-resource API version override. |
| `spec` | yes | Arbitrary CR spec rendered as-is. |
| `status` | no | Optional raw status block for fixtures and synthetic manifests. |

Global controls:

- `nameOverride`
- `commonLabels`
- `commonAnnotations`
- `generic.labels`
- `generic.annotations`
- `apiVersions.rabbitmqCluster`
- `apiVersions.queue`
- `apiVersions.policy`
- `apiVersions.exchange`
- `apiVersions.binding`
- `apiVersions.user`
- `apiVersions.permission`
- `apiVersions.vhost`
- `apiVersions.federation`
- `apiVersions.shovel`

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` to refresh it.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions | object | `{"binding":"rabbitmq.com/v1beta1","exchange":"rabbitmq.com/v1beta1","federation":"rabbitmq.com/v1beta1","permission":"rabbitmq.com/v1beta1","policy":"rabbitmq.com/v1beta1","queue":"rabbitmq.com/v1beta1","rabbitmqCluster":"rabbitmq.com/v1beta1","shovel":"rabbitmq.com/v1beta1","user":"rabbitmq.com/v1beta1","vhost":"rabbitmq.com/v1beta1"}` | Override these defaults if your cluster uses different RabbitMQ operator API versions. |
| apiVersions.binding | string | `"rabbitmq.com/v1beta1"` | API version used for Binding manifests. |
| apiVersions.exchange | string | `"rabbitmq.com/v1beta1"` | API version used for Exchange manifests. |
| apiVersions.federation | string | `"rabbitmq.com/v1beta1"` | API version used for Federation manifests. |
| apiVersions.permission | string | `"rabbitmq.com/v1beta1"` | API version used for Permission manifests. |
| apiVersions.policy | string | `"rabbitmq.com/v1beta1"` | API version used for Policy manifests. |
| apiVersions.queue | string | `"rabbitmq.com/v1beta1"` | API version used for Queue manifests. |
| apiVersions.rabbitmqCluster | string | `"rabbitmq.com/v1beta1"` | API version used for RabbitmqCluster manifests. |
| apiVersions.shovel | string | `"rabbitmq.com/v1beta1"` | API version used for Shovel manifests. |
| apiVersions.user | string | `"rabbitmq.com/v1beta1"` | API version used for User manifests. |
| apiVersions.vhost | string | `"rabbitmq.com/v1beta1"` | API version used for Vhost manifests. |
| bindings | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"destination":"orders","destinationType":"queue","rabbitmqClusterReference":{"name":"example-rabbit"},"routingKey":"orders.created","source":"orders","vhost":"app"},"status":{}}}` | Binding resources keyed by resource name. |
| bindings.__helm_docs_example__.spec.destination | string | `"orders"` | Destination queue or exchange name. |
| bindings.__helm_docs_example__.spec.destinationType | string | `"queue"` | Destination object type. |
| bindings.__helm_docs_example__.spec.routingKey | string | `"orders.created"` | Optional routing key for the binding. |
| bindings.__helm_docs_example__.spec.source | string | `"orders"` | Source exchange name. |
| bindings.__helm_docs_example__.spec.vhost | string | `"app"` | Target virtual host. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` | Enable rabbitmq chart rendering. |
| exchanges | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"autoDelete":false,"durable":true,"name":"orders","rabbitmqClusterReference":{"name":"example-rabbit"},"type":"direct","vhost":"app"},"status":{}}}` | Exchange resources keyed by resource name. |
| exchanges.__helm_docs_example__.spec.autoDelete | bool | `false` | Whether the exchange is deleted automatically. |
| exchanges.__helm_docs_example__.spec.durable | bool | `true` | Whether the exchange survives broker restarts. |
| exchanges.__helm_docs_example__.spec.name | string | `"orders"` | RabbitMQ exchange name. |
| exchanges.__helm_docs_example__.spec.type | string | `"direct"` | Exchange type supported by RabbitMQ. |
| exchanges.__helm_docs_example__.spec.vhost | string | `"app"` | Target virtual host. |
| federations | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"ackMode":"on-confirm","name":"upstream-a","rabbitmqClusterReference":{"name":"example-rabbit"},"uriSecret":{"name":"rabbitmq-federation-uri"},"vhost":"app"},"status":{}}}` | Federation resources keyed by resource name. |
| federations.__helm_docs_example__.spec.ackMode | string | `"on-confirm"` | Upstream acknowledgement mode. |
| federations.__helm_docs_example__.spec.name | string | `"upstream-a"` | RabbitMQ federation upstream name. |
| federations.__helm_docs_example__.spec.uriSecret | object | `{"name":"rabbitmq-federation-uri"}` | Secret with the `uri` field used for the upstream. |
| federations.__helm_docs_example__.spec.uriSecret.name | string | `"rabbitmq-federation-uri"` | Secret name in the same namespace as the Federation resource. |
| federations.__helm_docs_example__.spec.vhost | string | `"app"` | Target virtual host. |
| generic | object | `{"annotations":{},"labels":{}}` | Shared metadata and templating values compatible with umbrella charts. |
| generic.annotations | object | `{}` | Annotations merged into every rendered resource after common annotations. |
| generic.labels | object | `{}` | Labels merged into every rendered resource after chart labels. |
| global | object | `{}` | Compatibility values inherited from umbrella charts. |
| nameOverride | string | `""` | Override the default chart label name if needed. |
| permissions | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"permissions":{"configure":".*","read":".*","write":".*"},"rabbitmqClusterReference":{"name":"example-rabbit"},"user":"app-user","vhost":"app"},"status":{}}}` | Permission resources keyed by resource name. |
| permissions.__helm_docs_example__.spec.permissions | object | `{"configure":".*","read":".*","write":".*"}` | Regex-based RabbitMQ permissions. |
| permissions.__helm_docs_example__.spec.user | string | `"app-user"` | Target RabbitMQ user name. |
| permissions.__helm_docs_example__.spec.vhost | string | `"app"` | Target virtual host. |
| policies | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"applyTo":"queues","definition":{"message-ttl":60000},"name":"queue-ttl","pattern":"^orders$","rabbitmqClusterReference":{"name":"example-rabbit"},"vhost":"app"},"status":{}}}` | Policy resources keyed by resource name. |
| policies.__helm_docs_example__.spec.applyTo | string | `"queues"` | RabbitMQ object type the policy applies to. |
| policies.__helm_docs_example__.spec.definition | object | `{"message-ttl":60000}` | Policy definition payload sent to RabbitMQ. |
| policies.__helm_docs_example__.spec.name | string | `"queue-ttl"` | RabbitMQ policy name. |
| policies.__helm_docs_example__.spec.pattern | string | `"^orders$"` | Regex pattern used to select matching queues or exchanges. |
| policies.__helm_docs_example__.spec.vhost | string | `"app"` | Target virtual host. |
| queues | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"arguments":{"x-queue-type":"quorum"},"autoDelete":false,"deletionPolicy":"delete","durable":true,"name":"orders","rabbitmqClusterReference":{"name":"example-rabbit"},"vhost":"app"},"status":{}}}` | Queue resources keyed by resource name. |
| queues.__helm_docs_example__.spec.arguments | object | `{"x-queue-type":"quorum"}` | Optional queue arguments accepted by RabbitMQ. |
| queues.__helm_docs_example__.spec.autoDelete | bool | `false` | Whether the queue is deleted automatically when no consumers remain. |
| queues.__helm_docs_example__.spec.deletionPolicy | string | `"delete"` | Deletion behavior when the Kubernetes resource is removed. |
| queues.__helm_docs_example__.spec.durable | bool | `true` | Whether the queue survives broker restarts. |
| queues.__helm_docs_example__.spec.name | string | `"orders"` | RabbitMQ queue name. |
| queues.__helm_docs_example__.spec.rabbitmqClusterReference | object | `{"name":"example-rabbit"}` | Reference to the target RabbitmqCluster. |
| queues.__helm_docs_example__.spec.rabbitmqClusterReference.name | string | `"example-rabbit"` | Name of the RabbitmqCluster or connection secret owner. |
| queues.__helm_docs_example__.spec.vhost | string | `"app"` | RabbitMQ virtual host. Defaults to `/` when omitted by the operator. |
| rabbitmqclusters | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"image":"rabbitmq:4.1.3-management","persistence":{"storage":"10Gi"},"rabbitmq":{"additionalConfig":"cluster_partition_handling = autoheal\n","additionalPlugins":["rabbitmq_shovel","rabbitmq_federation"]},"replicas":1,"resources":{"limits":{"cpu":"500m","memory":"1Gi"},"requests":{"cpu":"250m","memory":"512Mi"}},"service":{"type":"ClusterIP"},"tls":{"secretName":"rabbitmq-server-tls"}},"status":{}}}` | RabbitmqCluster resources keyed by resource name. |
| rabbitmqclusters.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"image":"rabbitmq:4.1.3-management","persistence":{"storage":"10Gi"},"rabbitmq":{"additionalConfig":"cluster_partition_handling = autoheal\n","additionalPlugins":["rabbitmq_shovel","rabbitmq_federation"]},"replicas":1,"resources":{"limits":{"cpu":"500m","memory":"1Gi"},"requests":{"cpu":"250m","memory":"512Mi"}},"service":{"type":"ClusterIP"},"tls":{"secretName":"rabbitmq-server-tls"}},"status":{}}` | Example key ignored by templates and used only for helm-docs output. |
| rabbitmqclusters.__helm_docs_example__.annotations | object | `{}` | Optional annotations merged on top of common chart annotations. |
| rabbitmqclusters.__helm_docs_example__.apiVersion | string | `"rabbitmq.com/v1beta1"` | Optional per-resource apiVersion override. |
| rabbitmqclusters.__helm_docs_example__.labels | object | `{}` | Optional labels merged on top of common chart labels. |
| rabbitmqclusters.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace. Defaults to the Helm release namespace. |
| rabbitmqclusters.__helm_docs_example__.spec | object | `{"image":"rabbitmq:4.1.3-management","persistence":{"storage":"10Gi"},"rabbitmq":{"additionalConfig":"cluster_partition_handling = autoheal\n","additionalPlugins":["rabbitmq_shovel","rabbitmq_federation"]},"replicas":1,"resources":{"limits":{"cpu":"500m","memory":"1Gi"},"requests":{"cpu":"250m","memory":"512Mi"}},"service":{"type":"ClusterIP"},"tls":{"secretName":"rabbitmq-server-tls"}}` | Arbitrary RabbitmqCluster spec rendered as-is. |
| rabbitmqclusters.__helm_docs_example__.spec.image | string | `"rabbitmq:4.1.3-management"` | Container image used for the managed RabbitMQ server Pods. |
| rabbitmqclusters.__helm_docs_example__.spec.persistence | object | `{"storage":"10Gi"}` | Persistence settings for RabbitMQ data volumes. |
| rabbitmqclusters.__helm_docs_example__.spec.persistence.storage | string | `"10Gi"` | Requested persistent volume size. Use `0` to disable persistence in ephemeral environments. |
| rabbitmqclusters.__helm_docs_example__.spec.rabbitmq | object | `{"additionalConfig":"cluster_partition_handling = autoheal\n","additionalPlugins":["rabbitmq_shovel","rabbitmq_federation"]}` | RabbitMQ-specific configuration managed by the operator. |
| rabbitmqclusters.__helm_docs_example__.spec.rabbitmq.additionalConfig | string | `"cluster_partition_handling = autoheal\n"` | Additional lines appended to `rabbitmq.conf`. |
| rabbitmqclusters.__helm_docs_example__.spec.rabbitmq.additionalPlugins | list | `["rabbitmq_shovel","rabbitmq_federation"]` | Additional RabbitMQ plugins to enable on top of operator defaults. |
| rabbitmqclusters.__helm_docs_example__.spec.replicas | int | `1` | Number of RabbitMQ replicas. Odd numbers are recommended. |
| rabbitmqclusters.__helm_docs_example__.spec.resources | object | `{"limits":{"cpu":"500m","memory":"1Gi"},"requests":{"cpu":"250m","memory":"512Mi"}}` | Pod resource requests and limits. |
| rabbitmqclusters.__helm_docs_example__.spec.resources.limits.cpu | string | `"500m"` | CPU limit for RabbitMQ Pods. |
| rabbitmqclusters.__helm_docs_example__.spec.resources.limits.memory | string | `"1Gi"` | Memory limit for RabbitMQ Pods. |
| rabbitmqclusters.__helm_docs_example__.spec.resources.requests.cpu | string | `"250m"` | Requested CPU for RabbitMQ Pods. |
| rabbitmqclusters.__helm_docs_example__.spec.resources.requests.memory | string | `"512Mi"` | Requested memory for RabbitMQ Pods. |
| rabbitmqclusters.__helm_docs_example__.spec.service | object | `{"type":"ClusterIP"}` | Service configuration exposed by the Cluster Operator. |
| rabbitmqclusters.__helm_docs_example__.spec.service.type | string | `"ClusterIP"` | Kubernetes Service type for the generated RabbitMQ service. |
| rabbitmqclusters.__helm_docs_example__.spec.tls | object | `{"secretName":"rabbitmq-server-tls"}` | Optional TLS configuration for client-facing listeners. |
| rabbitmqclusters.__helm_docs_example__.spec.tls.secretName | string | `"rabbitmq-server-tls"` | Secret containing `tls.crt` and `tls.key`. |
| rabbitmqclusters.__helm_docs_example__.status | object | `{}` | Optional raw status block, mostly useful for fixtures. |
| shovels | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"destQueue":"orders-copy","name":"shovel-orders","rabbitmqClusterReference":{"name":"example-rabbit"},"srcQueue":"orders","uriSecret":{"name":"rabbitmq-shovel-uri"},"vhost":"app"},"status":{}}}` | Shovel resources keyed by resource name. |
| shovels.__helm_docs_example__.spec.destQueue | string | `"orders-copy"` | Destination queue published by the shovel. |
| shovels.__helm_docs_example__.spec.name | string | `"shovel-orders"` | RabbitMQ shovel name. |
| shovels.__helm_docs_example__.spec.srcQueue | string | `"orders"` | Source queue consumed by the shovel. |
| shovels.__helm_docs_example__.spec.uriSecret | object | `{"name":"rabbitmq-shovel-uri"}` | Secret with `srcUri` and `destUri`. |
| shovels.__helm_docs_example__.spec.uriSecret.name | string | `"rabbitmq-shovel-uri"` | Secret name in the same namespace as the Shovel resource. |
| shovels.__helm_docs_example__.spec.vhost | string | `"app"` | Target virtual host. |
| users | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"importCredentialsSecret":{"name":"rabbitmq-app-user"},"rabbitmqClusterReference":{"name":"example-rabbit"},"tags":["management"]},"status":{}}}` | User resources keyed by resource name. |
| users.__helm_docs_example__.spec.importCredentialsSecret | object | `{"name":"rabbitmq-app-user"}` | Optional secret with `username` and `password` or `passwordHash`. |
| users.__helm_docs_example__.spec.importCredentialsSecret.name | string | `"rabbitmq-app-user"` | Secret name in the same namespace as the User resource. |
| users.__helm_docs_example__.spec.tags | list | `["management"]` | RabbitMQ user tags such as `management`, `policymaker`, or `administrator`. |
| vhosts | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"rabbitmq.com/v1beta1","labels":{},"namespace":"documentation-placeholder","spec":{"deletionPolicy":"delete","name":"app","rabbitmqClusterReference":{"name":"example-rabbit"}},"status":{}}}` | Vhost resources keyed by resource name. |
| vhosts.__helm_docs_example__.spec.deletionPolicy | string | `"delete"` | Deletion behavior when the Kubernetes resource is removed. |
| vhosts.__helm_docs_example__.spec.name | string | `"app"` | RabbitMQ virtual host name. |

## Representative Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources
- [values.yaml.example](values.yaml.example): representative fixture covering all supported resource types
- [tests/smokes/fixtures/example.values.yaml](tests/smokes/fixtures/example.values.yaml): smoke-test fixture
- [tests/units/values/example.values.yaml](tests/units/values/example.values.yaml): unit-test fixture

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward-compatibility checks
- `tests/smokes/` for render-path smoke scenarios
- `tests/e2e/` for local kind-based Helm install checks against real RabbitMQ operator CRDs

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

- Keep the chart API versions aligned with the RabbitMQ operators installed in the cluster.
- The chart does not install operator Deployments, CRDs, or supporting Secrets referenced by user/federation/shovel resources.

## Repository Layout

| Path | Purpose |
|------|---------|
| [Chart.yaml](Chart.yaml) | Chart metadata. |
| [values.yaml](values.yaml) | Minimal default values and `helm-docs` source comments. |
| [docs/README.md.gotmpl](docs/README.md.gotmpl) | Template used by `helm-docs` to build `README.md`. |
| [.pre-commit-config.yaml](.pre-commit-config.yaml) | Local hooks, including automatic `helm-docs` generation on commit. |
| [templates/](templates) | RabbitMQ operator resource templates for `RabbitmqCluster` and topology CRs. |
| [tests/units/](tests/units) | Compact Helm unit suites and backward compatibility checks. |
| [tests/e2e/](tests/e2e) | Local kind-based end-to-end installation checks. |
| [tests/smokes/](tests/smokes) | Smoke scenarios for render validation. |
| [docs/DEPENDENCY.md](docs/DEPENDENCY.md) | Local dependency installation guide for development and tests. |
| [docs/TESTS.MD](docs/TESTS.MD) | Detailed testing documentation. |
