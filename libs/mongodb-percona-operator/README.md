# MongoDB Percona Operator

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/mongodb-percona-operator)](https://artifacthub.io/packages/search?repo=mongodb-percona-operator)

Helm chart for rendering [Percona Operator for MongoDB](https://docs.percona.com/percona-operator-for-mongodb/index.html) custom resources from declarative values.

The chart does not install the operator itself and does not install CRDs inside `templates/`.
It only renders operator-managed resources for clusters where the Percona CRDs are already present.

## Quick Start

Install the chart:

```bash
helm install mongodb-percona-operator oci://ghcr.io/riftonix/helm-shared/libs/mongodb-percona-operator \
  --namespace mongodb \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these Percona custom resources:

- `PerconaServerMongoDB`
- `PerconaServerMongoDBBackup`
- `PerconaServerMongoDBRestore`

The resource payloads are passed through mostly as-is, so support for individual fields depends on the Percona CRDs installed in the target cluster.

## Values Model

Each top-level map in [values.yaml](values.yaml) maps to one Percona resource kind:

- `perconaServerMongoDBs`
- `perconaServerMongoDBBackups`
- `perconaServerMongoDBRestores`

Per-resource controls:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | no | Resource name override. By default the map key becomes `metadata.name`. |
| `namespace` | no | Namespace override. Defaults to the Helm release namespace. |
| `labels` | no | Labels merged on top of built-in chart labels and `generic.labels`. |
| `annotations` | no | Annotations merged on top of `commonAnnotations` and `generic.annotations`. |
| `apiVersion` | no | Optional apiVersion override for a single resource. |
| `spec` | yes | Raw Percona custom resource spec rendered as-is. |
| `status` | no | Optional raw status block used for fixtures and synthetic manifests. |

Global controls:

- `enabled`
- `nameOverride`
- `commonLabels`
- `commonAnnotations`
- `generic.labels`
- `generic.annotations`
- `apiVersions.perconaServerMongoDB`
- `apiVersions.perconaServerMongoDBBackup`
- `apiVersions.perconaServerMongoDBRestore`

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` to refresh it.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions | object | `{"perconaServerMongoDB":"psmdb.percona.com/v1","perconaServerMongoDBBackup":"psmdb.percona.com/v1","perconaServerMongoDBRestore":"psmdb.percona.com/v1"}` | Override these defaults if your cluster uses different Percona CRD API versions. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` | Enable mongodb-percona-operator chart rendering. |
| generic | object | `{"annotations":{},"labels":{}}` | Shared metadata and templating values compatible with appchart. |
| global | object | `{}` | Compatibility values inherited from umbrella charts. |
| nameOverride | string | `""` | Override the default chart label name if needed. |
| perconaServerMongoDBBackups | object | `{"__helm_docs_example__":{"annotations":{"helm-docs.nuc.internal/ignore":"true"},"apiVersion":"psmdb.percona.com/v1","labels":{},"namespace":"documentation-placeholder","spec":{"clusterName":"my-cluster-name","compressionLevel":6,"compressionType":"gzip","startingDeadlineSeconds":300,"storageName":"s3-us-west","type":"physical"},"status":{}}}` | PerconaServerMongoDBBackup resources keyed by resource name. |
| perconaServerMongoDBBackups.__helm_docs_example__ | object | `{"annotations":{"helm-docs.nuc.internal/ignore":"true"},"apiVersion":"psmdb.percona.com/v1","labels":{},"namespace":"documentation-placeholder","spec":{"clusterName":"my-cluster-name","compressionLevel":6,"compressionType":"gzip","startingDeadlineSeconds":300,"storageName":"s3-us-west","type":"physical"},"status":{}}` | Documentation-only example object that exposes nested backup fields to helm-docs. |
| perconaServerMongoDBBackups.__helm_docs_example__.spec.clusterName | string | `"my-cluster-name"` | Target PerconaServerMongoDB cluster name. |
| perconaServerMongoDBBackups.__helm_docs_example__.spec.compressionLevel | int | `6` | Optional compression level. |
| perconaServerMongoDBBackups.__helm_docs_example__.spec.compressionType | string | `"gzip"` | Optional compression type such as `gzip`. |
| perconaServerMongoDBBackups.__helm_docs_example__.spec.startingDeadlineSeconds | int | `300` | Optional deadline in seconds for starting the backup. |
| perconaServerMongoDBBackups.__helm_docs_example__.spec.storageName | string | `"s3-us-west"` | Backup storage name configured in the target cluster CR. |
| perconaServerMongoDBBackups.__helm_docs_example__.spec.type | string | `"physical"` | Optional backup type such as `physical`. |
| perconaServerMongoDBRestores | object | `{"__helm_docs_example__":{"annotations":{"helm-docs.nuc.internal/ignore":"true"},"apiVersion":"psmdb.percona.com/v1","labels":{},"namespace":"documentation-placeholder","spec":{"backupName":"backup1","backupSource":{"destination":"s3://S3-BACKUP-BUCKET-NAME-HERE/BACKUP-DESTINATION","s3":{"bucket":"S3-BACKUP-BUCKET-NAME-HERE","credentialsSecret":"my-cluster-name-backup-s3","endpointUrl":"https://s3.us-west-2.amazonaws.com/","prefix":"","region":"us-west-2"},"type":"physical"},"clusterName":"my-cluster-name","pitr":{"date":"2026-01-14 10:00:00","type":"date"},"selective":{"namespaces":["db.collection"],"withUsersAndRoles":true}},"status":{}}}` | PerconaServerMongoDBRestore resources keyed by resource name. |
| perconaServerMongoDBRestores.__helm_docs_example__ | object | `{"annotations":{"helm-docs.nuc.internal/ignore":"true"},"apiVersion":"psmdb.percona.com/v1","labels":{},"namespace":"documentation-placeholder","spec":{"backupName":"backup1","backupSource":{"destination":"s3://S3-BACKUP-BUCKET-NAME-HERE/BACKUP-DESTINATION","s3":{"bucket":"S3-BACKUP-BUCKET-NAME-HERE","credentialsSecret":"my-cluster-name-backup-s3","endpointUrl":"https://s3.us-west-2.amazonaws.com/","prefix":"","region":"us-west-2"},"type":"physical"},"clusterName":"my-cluster-name","pitr":{"date":"2026-01-14 10:00:00","type":"date"},"selective":{"namespaces":["db.collection"],"withUsersAndRoles":true}},"status":{}}` | Documentation-only example object that exposes nested restore fields to helm-docs. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.backupName | string | `"backup1"` | Existing backup object name to restore from. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.backupSource.destination | string | `"s3://S3-BACKUP-BUCKET-NAME-HERE/BACKUP-DESTINATION"` | Backup destination URI. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.backupSource.s3.bucket | string | `"S3-BACKUP-BUCKET-NAME-HERE"` | Bucket name for the S3 restore source. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.backupSource.s3.credentialsSecret | string | `"my-cluster-name-backup-s3"` | Secret name with S3 credentials for external restore source. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.backupSource.s3.endpointUrl | string | `"https://s3.us-west-2.amazonaws.com/"` | Optional endpoint URL for S3-compatible storage. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.backupSource.s3.prefix | string | `""` | Optional path prefix inside the bucket. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.backupSource.s3.region | string | `"us-west-2"` | Region for the S3 restore source. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.backupSource.type | string | `"physical"` | Backup source type when restoring without an in-cluster Backup object. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.clusterName | string | `"my-cluster-name"` | Target PerconaServerMongoDB cluster name for the restore. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.pitr.date | string | `"2026-01-14 10:00:00"` | Restore target timestamp in `YYYY-MM-DD HH:MM:SS` format. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.pitr.type | string | `"date"` | Point-in-time recovery mode such as `date`. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.selective.namespaces | list | `["db.collection"]` | Namespace list for selective restore. |
| perconaServerMongoDBRestores.__helm_docs_example__.spec.selective.withUsersAndRoles | bool | `true` | Restore MongoDB users and roles together with selected namespaces. |
| perconaServerMongoDBs | object | `{"__helm_docs_example__":{"annotations":{"helm-docs.nuc.internal/ignore":"true"},"apiVersion":"psmdb.percona.com/v1","labels":{},"namespace":"documentation-placeholder","spec":{"backup":{"enabled":true,"image":"perconalab/percona-server-mongodb-operator:main-backup","pitr":{"compressionLevel":6,"compressionType":"gzip","enabled":false,"oplogOnly":false},"storages":{"s3-us-west":{"s3":{"bucket":"S3-BACKUP-BUCKET-NAME-HERE","credentialsSecret":"my-cluster-name-backup-s3","prefix":"","region":"us-west-2"},"type":"s3"}}},"crVersion":"1.23.0","image":"perconalab/percona-server-mongodb-operator:main-mongod8.0","imagePullPolicy":"Always","logcollector":{"enabled":true,"image":"perconalab/fluentbit:main-logcollector","resources":{"requests":{"cpu":"200m","memory":"100M"}}},"pmm":{"enabled":false,"image":"perconalab/pmm-client:3-dev-latest","serverHost":"monitoring-service"},"replsets":[{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"enabled":false,"type":"ClusterIP"},"name":"rs0","podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3,"volumeSpec":{"persistentVolumeClaim":{"resources":{"requests":{"storage":"3Gi"}}}}}],"secrets":{"encryptionKey":"my-cluster-name-mongodb-encryption-key","users":"my-cluster-name-secrets"},"sharding":{"configsvrReplSet":{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"enabled":false,"type":"ClusterIP"},"podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3,"volumeSpec":{"persistentVolumeClaim":{"resources":{"requests":{"storage":"3Gi"}}}}},"enabled":false,"mongos":{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"type":"ClusterIP"},"podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3}},"updateStrategy":"SmartUpdate","upgradeOptions":{"apply":"disabled","schedule":"0 2 * * *","setFCV":false,"versionServiceEndpoint":"https://check.percona.com"}},"status":{}}}` | PerconaServerMongoDB resources keyed by resource name. |
| perconaServerMongoDBs.__helm_docs_example__ | object | `{"annotations":{"helm-docs.nuc.internal/ignore":"true"},"apiVersion":"psmdb.percona.com/v1","labels":{},"namespace":"documentation-placeholder","spec":{"backup":{"enabled":true,"image":"perconalab/percona-server-mongodb-operator:main-backup","pitr":{"compressionLevel":6,"compressionType":"gzip","enabled":false,"oplogOnly":false},"storages":{"s3-us-west":{"s3":{"bucket":"S3-BACKUP-BUCKET-NAME-HERE","credentialsSecret":"my-cluster-name-backup-s3","prefix":"","region":"us-west-2"},"type":"s3"}}},"crVersion":"1.23.0","image":"perconalab/percona-server-mongodb-operator:main-mongod8.0","imagePullPolicy":"Always","logcollector":{"enabled":true,"image":"perconalab/fluentbit:main-logcollector","resources":{"requests":{"cpu":"200m","memory":"100M"}}},"pmm":{"enabled":false,"image":"perconalab/pmm-client:3-dev-latest","serverHost":"monitoring-service"},"replsets":[{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"enabled":false,"type":"ClusterIP"},"name":"rs0","podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3,"volumeSpec":{"persistentVolumeClaim":{"resources":{"requests":{"storage":"3Gi"}}}}}],"secrets":{"encryptionKey":"my-cluster-name-mongodb-encryption-key","users":"my-cluster-name-secrets"},"sharding":{"configsvrReplSet":{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"enabled":false,"type":"ClusterIP"},"podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3,"volumeSpec":{"persistentVolumeClaim":{"resources":{"requests":{"storage":"3Gi"}}}}},"enabled":false,"mongos":{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"type":"ClusterIP"},"podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3}},"updateStrategy":"SmartUpdate","upgradeOptions":{"apply":"disabled","schedule":"0 2 * * *","setFCV":false,"versionServiceEndpoint":"https://check.percona.com"}},"status":{}}` | Documentation-only example object that exposes nested fields to helm-docs. |
| perconaServerMongoDBs.__helm_docs_example__.annotations | object | `{"helm-docs.nuc.internal/ignore":"true"}` | Optional extra annotations for this PerconaServerMongoDB resource. |
| perconaServerMongoDBs.__helm_docs_example__.apiVersion | string | `"psmdb.percona.com/v1"` | Optional apiVersion override for this PerconaServerMongoDB resource. |
| perconaServerMongoDBs.__helm_docs_example__.labels | object | `{}` | Optional extra labels for this PerconaServerMongoDB resource. |
| perconaServerMongoDBs.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional namespace for the rendered PerconaServerMongoDB resource. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup | object | `{"enabled":true,"image":"perconalab/percona-server-mongodb-operator:main-backup","pitr":{"compressionLevel":6,"compressionType":"gzip","enabled":false,"oplogOnly":false},"storages":{"s3-us-west":{"s3":{"bucket":"S3-BACKUP-BUCKET-NAME-HERE","credentialsSecret":"my-cluster-name-backup-s3","prefix":"","region":"us-west-2"},"type":"s3"}}}` | Backup controller settings configured directly on the cluster CR. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.enabled | bool | `true` | Enable integrated backups in the cluster CR. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.image | string | `"perconalab/percona-server-mongodb-operator:main-backup"` | Backup image used by the operator. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.pitr.compressionLevel | int | `6` | Compression level for PITR chunks. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.pitr.compressionType | string | `"gzip"` | Compression type for PITR chunks. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.pitr.enabled | bool | `false` | Enable point-in-time recovery oplog slicing. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.pitr.oplogOnly | bool | `false` | Store only oplog chunks without full backups. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.storages.s3-us-west | object | `{"s3":{"bucket":"S3-BACKUP-BUCKET-NAME-HERE","credentialsSecret":"my-cluster-name-backup-s3","prefix":"","region":"us-west-2"},"type":"s3"}` | Example S3 backup storage entry. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.storages.s3-us-west.s3.bucket | string | `"S3-BACKUP-BUCKET-NAME-HERE"` | S3 bucket name for backups. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.storages.s3-us-west.s3.credentialsSecret | string | `"my-cluster-name-backup-s3"` | Secret name with S3 credentials. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.storages.s3-us-west.s3.prefix | string | `""` | Optional path prefix inside the bucket. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.storages.s3-us-west.s3.region | string | `"us-west-2"` | AWS region for the bucket. |
| perconaServerMongoDBs.__helm_docs_example__.spec.backup.storages.s3-us-west.type | string | `"s3"` | Storage type. Supported examples include `s3`, `azure`, `gcs`, `filesystem`, and `minio`. |
| perconaServerMongoDBs.__helm_docs_example__.spec.crVersion | string | `"1.23.0"` | Operator CR version from the official `deploy/cr.yaml`. |
| perconaServerMongoDBs.__helm_docs_example__.spec.image | string | `"perconalab/percona-server-mongodb-operator:main-mongod8.0"` | Main Percona Server for MongoDB image. |
| perconaServerMongoDBs.__helm_docs_example__.spec.imagePullPolicy | string | `"Always"` | Image pull policy for the database image. |
| perconaServerMongoDBs.__helm_docs_example__.spec.logcollector | object | `{"enabled":true,"image":"perconalab/fluentbit:main-logcollector","resources":{"requests":{"cpu":"200m","memory":"100M"}}}` | Log collector settings. |
| perconaServerMongoDBs.__helm_docs_example__.spec.logcollector.enabled | bool | `true` | Enable the log collector sidecar. |
| perconaServerMongoDBs.__helm_docs_example__.spec.logcollector.image | string | `"perconalab/fluentbit:main-logcollector"` | Fluent Bit image used for log collection. |
| perconaServerMongoDBs.__helm_docs_example__.spec.logcollector.resources.requests.cpu | string | `"200m"` | CPU request for the log collector sidecar. |
| perconaServerMongoDBs.__helm_docs_example__.spec.logcollector.resources.requests.memory | string | `"100M"` | Memory request for the log collector sidecar. |
| perconaServerMongoDBs.__helm_docs_example__.spec.pmm | object | `{"enabled":false,"image":"perconalab/pmm-client:3-dev-latest","serverHost":"monitoring-service"}` | PMM integration settings. |
| perconaServerMongoDBs.__helm_docs_example__.spec.pmm.enabled | bool | `false` | Enable PMM sidecar integration. |
| perconaServerMongoDBs.__helm_docs_example__.spec.pmm.image | string | `"perconalab/pmm-client:3-dev-latest"` | PMM client image. |
| perconaServerMongoDBs.__helm_docs_example__.spec.pmm.serverHost | string | `"monitoring-service"` | PMM server host. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets | list | `[{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"enabled":false,"type":"ClusterIP"},"name":"rs0","podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3,"volumeSpec":{"persistentVolumeClaim":{"resources":{"requests":{"storage":"3Gi"}}}}}]` | Replica set definitions for the database cluster. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].affinity.antiAffinityTopologyKey | string | `"kubernetes.io/hostname"` | Default anti-affinity topology key for replica set pods. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].expose.enabled | bool | `false` | Enable a service for the replica set. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].expose.type | string | `"ClusterIP"` | Service type for the replica set. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].name | string | `"rs0"` | Replica set name. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].podDisruptionBudget.maxUnavailable | int | `1` | Maximum unavailable pods for the replica set. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].resources.limits.cpu | string | `"600m"` | CPU limit for mongod containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].resources.limits.memory | string | `"1Gi"` | Memory limit for mongod containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].resources.requests.cpu | string | `"300m"` | CPU request for mongod containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].resources.requests.memory | string | `"1Gi"` | Memory request for mongod containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].size | int | `3` | Replica set size. |
| perconaServerMongoDBs.__helm_docs_example__.spec.replsets[0].volumeSpec.persistentVolumeClaim.resources.requests.storage | string | `"3Gi"` | Persistent volume size for the replica set. |
| perconaServerMongoDBs.__helm_docs_example__.spec.secrets | object | `{"encryptionKey":"my-cluster-name-mongodb-encryption-key","users":"my-cluster-name-secrets"}` | Secret references used by the cluster. |
| perconaServerMongoDBs.__helm_docs_example__.spec.secrets.encryptionKey | string | `"my-cluster-name-mongodb-encryption-key"` | Secret name that stores the encryption key. |
| perconaServerMongoDBs.__helm_docs_example__.spec.secrets.users | string | `"my-cluster-name-secrets"` | Secret name that stores database users. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding | object | `{"configsvrReplSet":{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"enabled":false,"type":"ClusterIP"},"podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3,"volumeSpec":{"persistentVolumeClaim":{"resources":{"requests":{"storage":"3Gi"}}}}},"enabled":false,"mongos":{"affinity":{"antiAffinityTopologyKey":"kubernetes.io/hostname"},"expose":{"type":"ClusterIP"},"podDisruptionBudget":{"maxUnavailable":1},"resources":{"limits":{"cpu":"600m","memory":"1Gi"},"requests":{"cpu":"300m","memory":"1Gi"}},"size":3}}` | Sharding-related settings. Keep `enabled: false` for replica-set-only clusters. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.affinity.antiAffinityTopologyKey | string | `"kubernetes.io/hostname"` | Anti-affinity topology key for config server pods. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.expose.enabled | bool | `false` | Enable a service for config server pods. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.expose.type | string | `"ClusterIP"` | Service type for config server pods. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.podDisruptionBudget.maxUnavailable | int | `1` | Maximum unavailable config server pods. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.resources.limits.cpu | string | `"600m"` | CPU limit for config server mongod containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.resources.limits.memory | string | `"1Gi"` | Memory limit for config server mongod containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.resources.requests.cpu | string | `"300m"` | CPU request for config server mongod containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.resources.requests.memory | string | `"1Gi"` | Memory request for config server mongod containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.size | int | `3` | Config server replica set size. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.configsvrReplSet.volumeSpec.persistentVolumeClaim.resources.requests.storage | string | `"3Gi"` | Persistent volume size for config server pods. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.enabled | bool | `false` | Enable sharded deployment mode. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.mongos.affinity.antiAffinityTopologyKey | string | `"kubernetes.io/hostname"` | Anti-affinity topology key for mongos pods. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.mongos.expose.type | string | `"ClusterIP"` | Service type for mongos. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.mongos.podDisruptionBudget.maxUnavailable | int | `1` | Maximum unavailable mongos pods. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.mongos.resources.limits.cpu | string | `"600m"` | CPU limit for mongos containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.mongos.resources.limits.memory | string | `"1Gi"` | Memory limit for mongos containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.mongos.resources.requests.cpu | string | `"300m"` | CPU request for mongos containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.mongos.resources.requests.memory | string | `"1Gi"` | Memory request for mongos containers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.sharding.mongos.size | int | `3` | Number of mongos routers. |
| perconaServerMongoDBs.__helm_docs_example__.spec.updateStrategy | string | `"SmartUpdate"` | Upgrade strategy used by the operator. |
| perconaServerMongoDBs.__helm_docs_example__.spec.upgradeOptions | object | `{"apply":"disabled","schedule":"0 2 * * *","setFCV":false,"versionServiceEndpoint":"https://check.percona.com"}` | Upgrade controller options. |
| perconaServerMongoDBs.__helm_docs_example__.spec.upgradeOptions.apply | string | `"disabled"` | Upgrade policy such as `disabled`. |
| perconaServerMongoDBs.__helm_docs_example__.spec.upgradeOptions.schedule | string | `"0 2 * * *"` | Cron schedule used by automatic upgrade checks. |
| perconaServerMongoDBs.__helm_docs_example__.spec.upgradeOptions.setFCV | bool | `false` | Whether to set FCV automatically during upgrades. |
| perconaServerMongoDBs.__helm_docs_example__.spec.upgradeOptions.versionServiceEndpoint | string | `"https://check.percona.com"` | Version service endpoint used for upgrade checks. |
| perconaServerMongoDBs.__helm_docs_example__.status | object | `{}` | Optional status stub used only for synthetic manifests and tests. |

## Representative Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources
- [values.yaml.example](values.yaml.example): representative example covering the supported Percona resources
- [tests/smokes/fixtures/example.values.yaml](tests/smokes/fixtures/example.values.yaml): smoke-test fixture

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward-compatibility checks
- `tests/smokes/` for render-path smoke scenarios
- `tests/e2e/` for local kind-based Helm install checks against real Percona CRDs

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

- Keep the chart API versions aligned with the Percona CRDs installed in the cluster.
- The chart does not install the Percona operator deployment or CRDs.
- The bundled smoke `kubeconform` step ignores missing CRD schemas, because the default schema catalogs do not ship Percona Operator schemas.

## Repository Layout

| Path | Purpose |
|------|---------|
| [Chart.yaml](Chart.yaml) | Chart metadata. |
| [values.yaml](values.yaml) | Minimal default values and `helm-docs` source comments. |
| [values.yaml.example](values.yaml.example) | Representative chart example values. |
| [docs/README.md.gotmpl](docs/README.md.gotmpl) | Template used by `helm-docs` to build `README.md`. |
| [.pre-commit-config.yaml](.pre-commit-config.yaml) | Local hooks, including automatic `helm-docs` generation on commit. |
| [templates/](templates) | Percona custom resource templates. |
| [tests/units/](tests/units) | Compact Helm unit suites and backward compatibility checks. |
| [tests/e2e/](tests/e2e) | Local kind-based end-to-end installation checks. |
| [tests/smokes/](tests/smokes) | Smoke scenarios for render validation. |
| [docs/DEPENDENCY.md](docs/DEPENDENCY.md) | Local dependency installation guide for development and tests. |
| [docs/TESTS.MD](docs/TESTS.MD) | Detailed testing documentation. |
