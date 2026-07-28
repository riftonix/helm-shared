# Strimzi Kafka Operator

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/strimzi-kafka-operator)](https://artifacthub.io/packages/search?repo=strimzi-kafka-operator)

Helm chart for rendering Strimzi Kafka Operator custom resources from declarative values.

The chart does not install Strimzi or its CRDs. It only renders custom resources for clusters where the corresponding Strimzi CRDs are already present.

## Quick Start

Install the chart:

```bash
helm install strimzi-kafka-operator oci://ghcr.io/riftonix/helm-shared/libs/strimzi-kafka-operator \
  --namespace kafka \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these Strimzi kinds:

- `Kafka`
- `KafkaNodePool`
- `KafkaConnect`
- `KafkaConnector`
- `KafkaMirrorMaker2`
- `KafkaTopic`
- `KafkaUser`
- `KafkaBridge`
- `KafkaRebalance`

Support for individual fields still depends on the Strimzi CRDs installed in the target cluster.

## Values Model

Each top-level map in [values.yaml](values.yaml) maps to one resource kind:

- `kafkas`
- `kafkanodepools`
- `kafkaconnects`
- `kafkaconnectors`
- `kafkamirrormaker2s`
- `kafkatopics`
- `kafkausers`
- `kafkabridges`
- `kafkarebalances`

Per-resource controls:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | no | Resource name. Defaults to the top-level map key and is rendered through Helm `tpl`. |
| `namespace` | no | Resource namespace. Defaults to the Helm release namespace. |
| `labels` | no | Labels merged on top of chart labels, `commonLabels`, and `generic.labels`. |
| `annotations` | no | Annotations merged on top of `commonAnnotations` and `generic.annotations`. |
| `apiVersion` | no | Per-resource API version override. |
| `spec` | yes | Raw Strimzi resource spec rendered as-is. |
| `status` | no | Optional raw status block for fixtures and synthetic manifests. |

Global controls:

- `nameOverride`
- `commonLabels`
- `commonAnnotations`
- `generic.labels`
- `generic.annotations`
- `apiVersions.kafka`
- `apiVersions.kafkaNodePool`
- `apiVersions.kafkaConnect`
- `apiVersions.kafkaConnector`
- `apiVersions.kafkaMirrorMaker2`
- `apiVersions.kafkaTopic`
- `apiVersions.kafkaUser`
- `apiVersions.kafkaBridge`
- `apiVersions.kafkaRebalance`

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` to refresh it.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions | object | `{"kafka":"kafka.strimzi.io/v1","kafkaBridge":"kafka.strimzi.io/v1","kafkaConnect":"kafka.strimzi.io/v1","kafkaConnector":"kafka.strimzi.io/v1","kafkaMirrorMaker2":"kafka.strimzi.io/v1","kafkaNodePool":"kafka.strimzi.io/v1","kafkaRebalance":"kafka.strimzi.io/v1","kafkaTopic":"kafka.strimzi.io/v1","kafkaUser":"kafka.strimzi.io/v1"}` | Override these defaults if your cluster uses different Strimzi API versions. |
| apiVersions.kafka | string | `"kafka.strimzi.io/v1"` | Default apiVersion for Kafka resources. |
| apiVersions.kafkaBridge | string | `"kafka.strimzi.io/v1"` | Default apiVersion for KafkaBridge resources. |
| apiVersions.kafkaConnect | string | `"kafka.strimzi.io/v1"` | Default apiVersion for KafkaConnect resources. |
| apiVersions.kafkaConnector | string | `"kafka.strimzi.io/v1"` | Default apiVersion for KafkaConnector resources. |
| apiVersions.kafkaMirrorMaker2 | string | `"kafka.strimzi.io/v1"` | Default apiVersion for KafkaMirrorMaker2 resources. |
| apiVersions.kafkaNodePool | string | `"kafka.strimzi.io/v1"` | Default apiVersion for KafkaNodePool resources. |
| apiVersions.kafkaRebalance | string | `"kafka.strimzi.io/v1"` | Default apiVersion for KafkaRebalance resources. |
| apiVersions.kafkaTopic | string | `"kafka.strimzi.io/v1"` | Default apiVersion for KafkaTopic resources. |
| apiVersions.kafkaUser | string | `"kafka.strimzi.io/v1"` | Default apiVersion for KafkaUser resources. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` | Enable strimzi-kafka-operator chart rendering. |
| generic | object | `{"annotations":{},"labels":{}}` | Shared metadata and templating values compatible with appchart. |
| generic.annotations | object | `{}` | Generic annotations merged into every rendered resource. |
| generic.labels | object | `{}` | Generic labels merged into every rendered resource. |
| global | object | `{}` | Compatibility values inherited from umbrella charts. |
| kafkabridges | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{},"namespace":"documentation-placeholder","spec":{"bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","http":{"port":8080},"replicas":1},"status":{}}}` | KafkaBridge resources keyed by resource name. |
| kafkabridges.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{},"namespace":"documentation-placeholder","spec":{"bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","http":{"port":8080},"replicas":1},"status":{}}` | Example KafkaBridge resource entry used only for generated documentation. |
| kafkabridges.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkabridges.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkabridges.__helm_docs_example__.labels | object | `{}` | Labels merged into this resource. |
| kafkabridges.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkabridges.__helm_docs_example__.spec | object | `{"bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","http":{"port":8080},"replicas":1}` | Raw KafkaBridge spec rendered as-is. |
| kafkabridges.__helm_docs_example__.spec.bootstrapServers | string | `"documentation-placeholder-kafka-bootstrap:9092"` | Kafka bootstrap servers used by Kafka Bridge. |
| kafkabridges.__helm_docs_example__.spec.http | object | `{"port":8080}` | HTTP listener configuration. |
| kafkabridges.__helm_docs_example__.spec.http.port | int | `8080` | HTTP listener port. |
| kafkabridges.__helm_docs_example__.spec.replicas | int | `1` | Number of Kafka Bridge replicas. |
| kafkabridges.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| kafkaconnectors | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder-connect"},"namespace":"documentation-placeholder","spec":{"class":"org.apache.kafka.connect.file.FileStreamSourceConnector","config":{},"tasksMax":1},"status":{}}}` | KafkaConnector resources keyed by resource name. |
| kafkaconnectors.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder-connect"},"namespace":"documentation-placeholder","spec":{"class":"org.apache.kafka.connect.file.FileStreamSourceConnector","config":{},"tasksMax":1},"status":{}}` | Example KafkaConnector resource entry used only for generated documentation. |
| kafkaconnectors.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkaconnectors.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkaconnectors.__helm_docs_example__.labels | object | `{"strimzi.io/cluster":"documentation-placeholder-connect"}` | Labels merged into this resource. |
| kafkaconnectors.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkaconnectors.__helm_docs_example__.spec | object | `{"class":"org.apache.kafka.connect.file.FileStreamSourceConnector","config":{},"tasksMax":1}` | Raw KafkaConnector spec rendered as-is. |
| kafkaconnectors.__helm_docs_example__.spec.class | string | `"org.apache.kafka.connect.file.FileStreamSourceConnector"` | Fully qualified Kafka Connect connector class. |
| kafkaconnectors.__helm_docs_example__.spec.config | object | `{}` | Connector-specific configuration. |
| kafkaconnectors.__helm_docs_example__.spec.tasksMax | int | `1` | Maximum number of connector tasks. |
| kafkaconnectors.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| kafkaconnects | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{},"namespace":"documentation-placeholder","spec":{"bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","config":{},"configStorageTopic":"documentation-placeholder-connect-configs","groupId":"documentation-placeholder-connect","offsetStorageTopic":"documentation-placeholder-connect-offsets","replicas":1,"statusStorageTopic":"documentation-placeholder-connect-status","version":"4.2.0"},"status":{}}}` | KafkaConnect resources keyed by resource name. |
| kafkaconnects.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{},"namespace":"documentation-placeholder","spec":{"bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","config":{},"configStorageTopic":"documentation-placeholder-connect-configs","groupId":"documentation-placeholder-connect","offsetStorageTopic":"documentation-placeholder-connect-offsets","replicas":1,"statusStorageTopic":"documentation-placeholder-connect-status","version":"4.2.0"},"status":{}}` | Example KafkaConnect resource entry used only for generated documentation. |
| kafkaconnects.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkaconnects.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkaconnects.__helm_docs_example__.labels | object | `{}` | Labels merged into this resource. |
| kafkaconnects.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkaconnects.__helm_docs_example__.spec | object | `{"bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","config":{},"configStorageTopic":"documentation-placeholder-connect-configs","groupId":"documentation-placeholder-connect","offsetStorageTopic":"documentation-placeholder-connect-offsets","replicas":1,"statusStorageTopic":"documentation-placeholder-connect-status","version":"4.2.0"}` | Raw KafkaConnect spec rendered as-is. |
| kafkaconnects.__helm_docs_example__.spec.bootstrapServers | string | `"documentation-placeholder-kafka-bootstrap:9092"` | Kafka bootstrap servers used by Kafka Connect. |
| kafkaconnects.__helm_docs_example__.spec.config | object | `{}` | Kafka Connect worker config. |
| kafkaconnects.__helm_docs_example__.spec.configStorageTopic | string | `"documentation-placeholder-connect-configs"` | Kafka topic storing connector configs. |
| kafkaconnects.__helm_docs_example__.spec.groupId | string | `"documentation-placeholder-connect"` | Kafka Connect worker group id. |
| kafkaconnects.__helm_docs_example__.spec.offsetStorageTopic | string | `"documentation-placeholder-connect-offsets"` | Kafka topic storing connector offsets. |
| kafkaconnects.__helm_docs_example__.spec.replicas | int | `1` | Number of Kafka Connect replicas. |
| kafkaconnects.__helm_docs_example__.spec.statusStorageTopic | string | `"documentation-placeholder-connect-status"` | Kafka topic storing connector statuses. |
| kafkaconnects.__helm_docs_example__.spec.version | string | `"4.2.0"` | Kafka Connect version. |
| kafkaconnects.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| kafkamirrormaker2s | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{},"namespace":"documentation-placeholder","spec":{"mirrors":[],"replicas":1,"target":{"alias":"target","bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","configStorageTopic":"documentation-placeholder-mirror-configs","groupId":"documentation-placeholder-mirror","offsetStorageTopic":"documentation-placeholder-mirror-offsets","statusStorageTopic":"documentation-placeholder-mirror-status"},"version":"4.2.0"},"status":{}}}` | KafkaMirrorMaker2 resources keyed by resource name. |
| kafkamirrormaker2s.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{},"namespace":"documentation-placeholder","spec":{"mirrors":[],"replicas":1,"target":{"alias":"target","bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","configStorageTopic":"documentation-placeholder-mirror-configs","groupId":"documentation-placeholder-mirror","offsetStorageTopic":"documentation-placeholder-mirror-offsets","statusStorageTopic":"documentation-placeholder-mirror-status"},"version":"4.2.0"},"status":{}}` | Example KafkaMirrorMaker2 resource entry used only for generated documentation. |
| kafkamirrormaker2s.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkamirrormaker2s.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkamirrormaker2s.__helm_docs_example__.labels | object | `{}` | Labels merged into this resource. |
| kafkamirrormaker2s.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkamirrormaker2s.__helm_docs_example__.spec | object | `{"mirrors":[],"replicas":1,"target":{"alias":"target","bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","configStorageTopic":"documentation-placeholder-mirror-configs","groupId":"documentation-placeholder-mirror","offsetStorageTopic":"documentation-placeholder-mirror-offsets","statusStorageTopic":"documentation-placeholder-mirror-status"},"version":"4.2.0"}` | Raw KafkaMirrorMaker2 spec rendered as-is. |
| kafkamirrormaker2s.__helm_docs_example__.spec.mirrors | list | `[]` | Mirror definitions rendered as-is. |
| kafkamirrormaker2s.__helm_docs_example__.spec.replicas | int | `1` | Number of Kafka MirrorMaker 2 replicas. |
| kafkamirrormaker2s.__helm_docs_example__.spec.target | object | `{"alias":"target","bootstrapServers":"documentation-placeholder-kafka-bootstrap:9092","configStorageTopic":"documentation-placeholder-mirror-configs","groupId":"documentation-placeholder-mirror","offsetStorageTopic":"documentation-placeholder-mirror-offsets","statusStorageTopic":"documentation-placeholder-mirror-status"}` | Target cluster and internal Kafka Connect storage configuration. |
| kafkamirrormaker2s.__helm_docs_example__.spec.target.alias | string | `"target"` | Alias of the target Kafka cluster. |
| kafkamirrormaker2s.__helm_docs_example__.spec.target.bootstrapServers | string | `"documentation-placeholder-kafka-bootstrap:9092"` | Bootstrap servers of the target Kafka cluster. |
| kafkamirrormaker2s.__helm_docs_example__.spec.target.configStorageTopic | string | `"documentation-placeholder-mirror-configs"` | Kafka topic storing MirrorMaker 2 configs. |
| kafkamirrormaker2s.__helm_docs_example__.spec.target.groupId | string | `"documentation-placeholder-mirror"` | Kafka Connect group id used by MirrorMaker 2. |
| kafkamirrormaker2s.__helm_docs_example__.spec.target.offsetStorageTopic | string | `"documentation-placeholder-mirror-offsets"` | Kafka topic storing MirrorMaker 2 offsets. |
| kafkamirrormaker2s.__helm_docs_example__.spec.target.statusStorageTopic | string | `"documentation-placeholder-mirror-status"` | Kafka topic storing MirrorMaker 2 statuses. |
| kafkamirrormaker2s.__helm_docs_example__.spec.version | string | `"4.2.0"` | Kafka MirrorMaker 2 version. |
| kafkamirrormaker2s.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| kafkanodepools | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder"},"namespace":"documentation-placeholder","spec":{"replicas":3,"roles":[],"storage":{"type":"jbod","volumes":[]}},"status":{}}}` | KafkaNodePool resources keyed by resource name. |
| kafkanodepools.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder"},"namespace":"documentation-placeholder","spec":{"replicas":3,"roles":[],"storage":{"type":"jbod","volumes":[]}},"status":{}}` | Example KafkaNodePool resource entry used only for generated documentation. |
| kafkanodepools.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkanodepools.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkanodepools.__helm_docs_example__.labels | object | `{"strimzi.io/cluster":"documentation-placeholder"}` | Labels merged into this resource. |
| kafkanodepools.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkanodepools.__helm_docs_example__.spec | object | `{"replicas":3,"roles":[],"storage":{"type":"jbod","volumes":[]}}` | Raw KafkaNodePool spec rendered as-is. |
| kafkanodepools.__helm_docs_example__.spec.replicas | int | `3` | Number of Strimzi nodes in this pool. |
| kafkanodepools.__helm_docs_example__.spec.roles | list | `[]` | Kafka process roles assigned to nodes in this pool. |
| kafkanodepools.__helm_docs_example__.spec.storage | object | `{"type":"jbod","volumes":[]}` | Storage configuration for nodes in this pool. |
| kafkanodepools.__helm_docs_example__.spec.storage.type | string | `"jbod"` | Node pool storage type. |
| kafkanodepools.__helm_docs_example__.spec.storage.volumes | list | `[]` | JBOD volume definitions. |
| kafkanodepools.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| kafkarebalances | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder"},"namespace":"documentation-placeholder","spec":{"goals":[],"mode":"full"},"status":{}}}` | KafkaRebalance resources keyed by resource name. |
| kafkarebalances.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder"},"namespace":"documentation-placeholder","spec":{"goals":[],"mode":"full"},"status":{}}` | Example KafkaRebalance resource entry used only for generated documentation. |
| kafkarebalances.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkarebalances.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkarebalances.__helm_docs_example__.labels | object | `{"strimzi.io/cluster":"documentation-placeholder"}` | Labels merged into this resource. |
| kafkarebalances.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkarebalances.__helm_docs_example__.spec | object | `{"goals":[],"mode":"full"}` | Raw KafkaRebalance spec rendered as-is. |
| kafkarebalances.__helm_docs_example__.spec.goals | list | `[]` | Cruise Control goals requested for the rebalance. |
| kafkarebalances.__helm_docs_example__.spec.mode | string | `"full"` | Rebalance mode. |
| kafkarebalances.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| kafkas | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{},"namespace":"documentation-placeholder","spec":{"entityOperator":{},"kafka":{"listeners":[],"metadataVersion":"4.2-IV1","version":"4.2.0"}},"status":{}}}` | Kafka resources keyed by resource name. |
| kafkas.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{},"namespace":"documentation-placeholder","spec":{"entityOperator":{},"kafka":{"listeners":[],"metadataVersion":"4.2-IV1","version":"4.2.0"}},"status":{}}` | Example Kafka resource entry used only for generated documentation. |
| kafkas.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkas.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkas.__helm_docs_example__.labels | object | `{}` | Labels merged into this resource. |
| kafkas.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkas.__helm_docs_example__.spec | object | `{"entityOperator":{},"kafka":{"listeners":[],"metadataVersion":"4.2-IV1","version":"4.2.0"}}` | Raw Kafka spec rendered as-is. |
| kafkas.__helm_docs_example__.spec.entityOperator | object | `{}` | Strimzi entity operator configuration. |
| kafkas.__helm_docs_example__.spec.kafka | object | `{"listeners":[],"metadataVersion":"4.2-IV1","version":"4.2.0"}` | Kafka cluster configuration. |
| kafkas.__helm_docs_example__.spec.kafka.listeners | list | `[]` | Kafka listeners exposed by the cluster. |
| kafkas.__helm_docs_example__.spec.kafka.metadataVersion | string | `"4.2-IV1"` | Kafka metadata version. |
| kafkas.__helm_docs_example__.spec.kafka.version | string | `"4.2.0"` | Kafka broker version. |
| kafkas.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| kafkatopics | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder"},"namespace":"documentation-placeholder","spec":{"config":{},"partitions":3,"replicas":3},"status":{}}}` | KafkaTopic resources keyed by resource name. |
| kafkatopics.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder"},"namespace":"documentation-placeholder","spec":{"config":{},"partitions":3,"replicas":3},"status":{}}` | Example KafkaTopic resource entry used only for generated documentation. |
| kafkatopics.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkatopics.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkatopics.__helm_docs_example__.labels | object | `{"strimzi.io/cluster":"documentation-placeholder"}` | Labels merged into this resource. |
| kafkatopics.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkatopics.__helm_docs_example__.spec | object | `{"config":{},"partitions":3,"replicas":3}` | Raw KafkaTopic spec rendered as-is. |
| kafkatopics.__helm_docs_example__.spec.config | object | `{}` | Topic configuration. |
| kafkatopics.__helm_docs_example__.spec.partitions | int | `3` | Number of topic partitions. |
| kafkatopics.__helm_docs_example__.spec.replicas | int | `3` | Topic replication factor. |
| kafkatopics.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| kafkausers | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder"},"namespace":"documentation-placeholder","spec":{"authentication":{"type":"scram-sha-512"},"authorization":{"acls":[],"type":"simple"}},"status":{}}}` | KafkaUser resources keyed by resource name. |
| kafkausers.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"kafka.strimzi.io/v1","labels":{"strimzi.io/cluster":"documentation-placeholder"},"namespace":"documentation-placeholder","spec":{"authentication":{"type":"scram-sha-512"},"authorization":{"acls":[],"type":"simple"}},"status":{}}` | Example KafkaUser resource entry used only for generated documentation. |
| kafkausers.__helm_docs_example__.annotations | object | `{}` | Annotations merged into this resource. |
| kafkausers.__helm_docs_example__.apiVersion | string | `"kafka.strimzi.io/v1"` | Optional apiVersion override for this resource. |
| kafkausers.__helm_docs_example__.labels | object | `{"strimzi.io/cluster":"documentation-placeholder"}` | Labels merged into this resource. |
| kafkausers.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the Helm release namespace. |
| kafkausers.__helm_docs_example__.spec | object | `{"authentication":{"type":"scram-sha-512"},"authorization":{"acls":[],"type":"simple"}}` | Raw KafkaUser spec rendered as-is. |
| kafkausers.__helm_docs_example__.spec.authentication | object | `{"type":"scram-sha-512"}` | User authentication configuration. |
| kafkausers.__helm_docs_example__.spec.authentication.type | string | `"scram-sha-512"` | Authentication mechanism type. |
| kafkausers.__helm_docs_example__.spec.authorization | object | `{"acls":[],"type":"simple"}` | User authorization configuration. |
| kafkausers.__helm_docs_example__.spec.authorization.acls | list | `[]` | ACL rules assigned to the user. |
| kafkausers.__helm_docs_example__.spec.authorization.type | string | `"simple"` | Authorization type. |
| kafkausers.__helm_docs_example__.status | object | `{}` | Optional raw status block for fixtures and synthetic manifests. |
| nameOverride | string | `""` | Override the default chart label name if needed. |

## Representative Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources
- [tests/smokes/fixtures/example.values.yaml](tests/smokes/fixtures/example.values.yaml): representative fixture covering all supported resource types
- [tests/units/values/example.values.yaml](tests/units/values/example.values.yaml): unit-test fixture for representative resource checks

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward-compatibility checks
- `tests/smokes/` for render-path smoke scenarios
- `tests/e2e/` for local kind-based Helm install checks against real Strimzi CRDs

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

- Keep the chart API versions aligned with the Strimzi CRDs installed in the cluster.
- The chart does not install the Strimzi operator, Kafka workloads, or CRDs.

## Repository Layout

| Path | Purpose |
|------|---------|
| [Chart.yaml](Chart.yaml) | Chart metadata. |
| [values.yaml](values.yaml) | Minimal default values and `helm-docs` source comments. |
| [docs/README.md.gotmpl](docs/README.md.gotmpl) | Template used by `helm-docs` to build `README.md`. |
| [.pre-commit-config.yaml](.pre-commit-config.yaml) | Local hooks, including automatic `helm-docs` generation on commit. |
| [templates/](templates) | Strimzi resource templates for supported custom resources. |
| [tests/units/](tests/units) | Compact Helm unit suites and backward compatibility checks. |
| [tests/e2e/](tests/e2e) | Local kind-based end-to-end installation checks. |
| [tests/smokes/](tests/smokes) | Smoke scenarios for render validation. |
| [docs/DEPENDENCY.md](docs/DEPENDENCY.md) | Local dependency installation guide for development and tests. |
| [docs/TESTS.MD](docs/TESTS.MD) | Detailed testing documentation. |
