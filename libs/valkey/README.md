# Valkey

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/valkey)](https://artifacthub.io/packages/search?repo=valkey)

Helm chart for rendering Valkey Operator custom resources from declarative values.

The chart does not install the Valkey Operator or its CRDs. It renders `ValkeyCluster` and `ValkeyNode` objects for clusters where the corresponding `valkey.io/v1alpha1` CRDs are already present.

## Quick Start

Install the chart:

```bash
helm install valkey oci://ghcr.io/riftonix/helm-shared/libs/valkey \
  --namespace valkey \
  --create-namespace \
  -f values.yaml.example
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these Valkey Operator kinds:

- `ValkeyCluster`
- `ValkeyNode`

`ValkeyCluster` is the normal user-facing resource. `ValkeyNode` is included because it is present in the upstream CRD set, but the operator describes it as an internal kind.

Support for individual fields still depends on the Valkey Operator CRDs installed in the target cluster.

## Values Model

Each top-level map in [values.yaml](values.yaml) maps to one resource kind:

- `valkeyclusters`
- `valkeynodes`

Per-resource controls:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | no | Resource name override. Defaults to the top-level map key. |
| `namespace` | no | Resource namespace. Defaults to the Helm release namespace. |
| `labels` | no | Labels merged on top of chart, common, and generic labels. |
| `annotations` | no | Annotations merged on top of common and generic annotations. |
| `apiVersion` | no | Per-resource API version override. |
| `spec` | yes for useful resources | Raw Valkey Operator spec rendered as-is, with tpl support. |
| `status` | no | Optional synthetic status block for fixtures and tests. |

Global controls:

- `enabled`
- `nameOverride`
- `commonLabels`
- `commonAnnotations`
- `generic.labels`
- `generic.annotations`
- `apiVersions.valkeyCluster`
- `apiVersions.valkeyNode`
- `global.apiVersions.valkeyCluster`
- `global.apiVersions.valkeyNode`

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` to refresh it.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions | object | `{"valkeyCluster":"valkey.io/v1alpha1","valkeyNode":"valkey.io/v1alpha1"}` | Override these defaults if your cluster uses different Valkey Operator API versions. |
| apiVersions.valkeyCluster | string | `"valkey.io/v1alpha1"` | Default API version for `ValkeyCluster` resources. |
| apiVersions.valkeyNode | string | `"valkey.io/v1alpha1"` | Default API version for `ValkeyNode` resources. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` | Enable valkey chart rendering. |
| generic | object | `{"annotations":{},"labels":{}}` | Shared metadata and templating values compatible with appchart. |
| generic.annotations | object | `{}` | Annotations merged into every rendered resource after `commonAnnotations`. |
| generic.labels | object | `{}` | Labels merged into every rendered resource after `commonLabels`. |
| global | object | `{}` | Compatibility values inherited from umbrella charts. |
| nameOverride | string | `""` | Override the default chart label name if needed. |
| valkeyclusters | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"valkey.io/v1alpha1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{"affinity":{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchLabels":{"app.kubernetes.io/name":"valkey"}},"topologyKey":"kubernetes.io/hostname"},"weight":100}]}},"config":{"maxmemory-policy":"allkeys-lru"},"containers":[{"env":[{"name":"VALKEY_EXTRA_FLAGS","value":"--loglevel notice"}],"image":"valkey/valkey:8.1","name":"server","resources":{"requests":{"cpu":"100m","memory":"256Mi"}}}],"exporter":{"enabled":true,"image":"oliver006/redis_exporter:v1.67.0","resources":{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"25m","memory":"64Mi"}}},"image":"valkey/valkey:8.1","nodeSelector":{"kubernetes.io/os":"linux"},"replicas":1,"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}},"shards":3,"tls":{"certificate":{"secretName":"valkey-tls"}},"tolerations":[{"effect":"NoSchedule","key":"dedicated","operator":"Equal","value":"valkey"}],"users":[{"channels":{"patterns":["app:*"]},"commands":{"allow":["@read","get"],"deny":["flushall"]},"enabled":true,"keys":{"readOnly":["shared:*"],"readWrite":["app:*"],"writeOnly":["ingest:*"]},"name":"app","nopass":false,"passwordSecret":{"keys":["password"],"name":"app-valkey-users"},"permissions":"+@connection"}],"workloadType":"StatefulSet"},"status":{"conditions":[{"lastTransitionTime":"2026-01-01T00:00:00Z","message":"Documentation placeholder","reason":"Initializing","status":"False","type":"Ready"}],"message":"Documentation placeholder","readyShards":0,"reason":"DocumentationOnly","shards":0,"state":"Initializing"}}}` | ValkeyCluster resources keyed by resource name. |
| valkeyclusters.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"valkey.io/v1alpha1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{"affinity":{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchLabels":{"app.kubernetes.io/name":"valkey"}},"topologyKey":"kubernetes.io/hostname"},"weight":100}]}},"config":{"maxmemory-policy":"allkeys-lru"},"containers":[{"env":[{"name":"VALKEY_EXTRA_FLAGS","value":"--loglevel notice"}],"image":"valkey/valkey:8.1","name":"server","resources":{"requests":{"cpu":"100m","memory":"256Mi"}}}],"exporter":{"enabled":true,"image":"oliver006/redis_exporter:v1.67.0","resources":{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"25m","memory":"64Mi"}}},"image":"valkey/valkey:8.1","nodeSelector":{"kubernetes.io/os":"linux"},"replicas":1,"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}},"shards":3,"tls":{"certificate":{"secretName":"valkey-tls"}},"tolerations":[{"effect":"NoSchedule","key":"dedicated","operator":"Equal","value":"valkey"}],"users":[{"channels":{"patterns":["app:*"]},"commands":{"allow":["@read","get"],"deny":["flushall"]},"enabled":true,"keys":{"readOnly":["shared:*"],"readWrite":["app:*"],"writeOnly":["ingest:*"]},"name":"app","nopass":false,"passwordSecret":{"keys":["password"],"name":"app-valkey-users"},"permissions":"+@connection"}],"workloadType":"StatefulSet"},"status":{"conditions":[{"lastTransitionTime":"2026-01-01T00:00:00Z","message":"Documentation placeholder","reason":"Initializing","status":"False","type":"Ready"}],"message":"Documentation placeholder","readyShards":0,"reason":"DocumentationOnly","shards":0,"state":"Initializing"}}` | Documentation-only placeholder ignored by templates. |
| valkeyclusters.__helm_docs_example__.annotations | object | `{}` | Additional annotations for this resource. |
| valkeyclusters.__helm_docs_example__.apiVersion | string | `"valkey.io/v1alpha1"` | API version override for this resource. |
| valkeyclusters.__helm_docs_example__.labels | object | `{}` | Additional labels for this resource. |
| valkeyclusters.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| valkeyclusters.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the release namespace. |
| valkeyclusters.__helm_docs_example__.spec | object | `{"affinity":{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchLabels":{"app.kubernetes.io/name":"valkey"}},"topologyKey":"kubernetes.io/hostname"},"weight":100}]}},"config":{"maxmemory-policy":"allkeys-lru"},"containers":[{"env":[{"name":"VALKEY_EXTRA_FLAGS","value":"--loglevel notice"}],"image":"valkey/valkey:8.1","name":"server","resources":{"requests":{"cpu":"100m","memory":"256Mi"}}}],"exporter":{"enabled":true,"image":"oliver006/redis_exporter:v1.67.0","resources":{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"25m","memory":"64Mi"}}},"image":"valkey/valkey:8.1","nodeSelector":{"kubernetes.io/os":"linux"},"replicas":1,"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}},"shards":3,"tls":{"certificate":{"secretName":"valkey-tls"}},"tolerations":[{"effect":"NoSchedule","key":"dedicated","operator":"Equal","value":"valkey"}],"users":[{"channels":{"patterns":["app:*"]},"commands":{"allow":["@read","get"],"deny":["flushall"]},"enabled":true,"keys":{"readOnly":["shared:*"],"readWrite":["app:*"],"writeOnly":["ingest:*"]},"name":"app","nopass":false,"passwordSecret":{"keys":["password"],"name":"app-valkey-users"},"permissions":"+@connection"}],"workloadType":"StatefulSet"}` | Desired state for a ValkeyCluster custom resource. |
| valkeyclusters.__helm_docs_example__.spec.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchLabels":{"app.kubernetes.io/name":"valkey"}},"topologyKey":"kubernetes.io/hostname"},"weight":100}]}}` | Pod affinity or anti-affinity rules. Overrides `nodeSelector` where Kubernetes scheduling rules conflict. |
| valkeyclusters.__helm_docs_example__.spec.affinity.podAntiAffinity | object | `{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchLabels":{"app.kubernetes.io/name":"valkey"}},"topologyKey":"kubernetes.io/hostname"},"weight":100}]}` | Pod anti-affinity rules. |
| valkeyclusters.__helm_docs_example__.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution | list | `[{"podAffinityTerm":{"labelSelector":{"matchLabels":{"app.kubernetes.io/name":"valkey"}},"topologyKey":"kubernetes.io/hostname"},"weight":100}]` | Preferred anti-affinity scheduling terms. |
| valkeyclusters.__helm_docs_example__.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm | object | `{"labelSelector":{"matchLabels":{"app.kubernetes.io/name":"valkey"}},"topologyKey":"kubernetes.io/hostname"}` | Pod affinity term to prefer during scheduling. |
| valkeyclusters.__helm_docs_example__.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector | object | `{"matchLabels":{"app.kubernetes.io/name":"valkey"}}` | Label selector for matching pods. |
| valkeyclusters.__helm_docs_example__.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchLabels | object | `{"app.kubernetes.io/name":"valkey"}` | Match labels used by the affinity selector. |
| valkeyclusters.__helm_docs_example__.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` | Topology key used to spread matching pods. |
| valkeyclusters.__helm_docs_example__.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` | Weight for the preferred scheduling term. |
| valkeyclusters.__helm_docs_example__.spec.config | object | `{"maxmemory-policy":"allkeys-lru"}` | Additional Valkey configuration parameters rendered into the resource spec. |
| valkeyclusters.__helm_docs_example__.spec.containers | list | `[{"env":[{"name":"VALKEY_EXTRA_FLAGS","value":"--loglevel notice"}],"image":"valkey/valkey:8.1","name":"server","resources":{"requests":{"cpu":"100m","memory":"256Mi"}}}]` | Additional containers or strategic-merge overrides for default containers. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].env | list | `[{"name":"VALKEY_EXTRA_FLAGS","value":"--loglevel notice"}]` | Additional container environment variables. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].env[0].name | string | `"VALKEY_EXTRA_FLAGS"` | Environment variable name. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].env[0].value | string | `"--loglevel notice"` | Environment variable value. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].image | string | `"valkey/valkey:8.1"` | Container image override for the named container. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].name | string | `"server"` | Container name to add or patch. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].resources | object | `{"requests":{"cpu":"100m","memory":"256Mi"}}` | Additional container resource overrides. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].resources.requests | object | `{"cpu":"100m","memory":"256Mi"}` | Container resource requests. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].resources.requests.cpu | string | `"100m"` | Requested CPU for the patched container. |
| valkeyclusters.__helm_docs_example__.spec.containers[0].resources.requests.memory | string | `"256Mi"` | Requested memory for the patched container. |
| valkeyclusters.__helm_docs_example__.spec.exporter | object | `{"enabled":true,"image":"oliver006/redis_exporter:v1.67.0","resources":{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"25m","memory":"64Mi"}}}` | Metrics exporter sidecar options. |
| valkeyclusters.__helm_docs_example__.spec.exporter.enabled | bool | `true` | Enable the metrics exporter sidecar. |
| valkeyclusters.__helm_docs_example__.spec.exporter.image | string | `"oliver006/redis_exporter:v1.67.0"` | Metrics exporter image override. |
| valkeyclusters.__helm_docs_example__.spec.exporter.resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"25m","memory":"64Mi"}}` | Resource requirements for the metrics exporter sidecar. |
| valkeyclusters.__helm_docs_example__.spec.exporter.resources.limits | object | `{"cpu":"100m","memory":"128Mi"}` | Metrics exporter resource limits. |
| valkeyclusters.__helm_docs_example__.spec.exporter.resources.limits.cpu | string | `"100m"` | CPU limit for the metrics exporter. |
| valkeyclusters.__helm_docs_example__.spec.exporter.resources.limits.memory | string | `"128Mi"` | Memory limit for the metrics exporter. |
| valkeyclusters.__helm_docs_example__.spec.exporter.resources.requests | object | `{"cpu":"25m","memory":"64Mi"}` | Metrics exporter resource requests. |
| valkeyclusters.__helm_docs_example__.spec.exporter.resources.requests.cpu | string | `"25m"` | Requested CPU for the metrics exporter. |
| valkeyclusters.__helm_docs_example__.spec.exporter.resources.requests.memory | string | `"64Mi"` | Requested memory for the metrics exporter. |
| valkeyclusters.__helm_docs_example__.spec.image | string | `"valkey/valkey:8.1"` | Valkey container image override. |
| valkeyclusters.__helm_docs_example__.spec.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | Node selector applied to operator-created pods. |
| valkeyclusters.__helm_docs_example__.spec.replicas | int | `1` | Number of replicas for each shard group. |
| valkeyclusters.__helm_docs_example__.spec.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resource requirements for the Valkey container. |
| valkeyclusters.__helm_docs_example__.spec.resources.limits | object | `{"cpu":"500m","memory":"512Mi"}` | Container resource limits. |
| valkeyclusters.__helm_docs_example__.spec.resources.limits.cpu | string | `"500m"` | CPU limit for the Valkey container. |
| valkeyclusters.__helm_docs_example__.spec.resources.limits.memory | string | `"512Mi"` | Memory limit for the Valkey container. |
| valkeyclusters.__helm_docs_example__.spec.resources.requests | object | `{"cpu":"100m","memory":"256Mi"}` | Container resource requests. |
| valkeyclusters.__helm_docs_example__.spec.resources.requests.cpu | string | `"100m"` | Requested CPU for the Valkey container. |
| valkeyclusters.__helm_docs_example__.spec.resources.requests.memory | string | `"256Mi"` | Requested memory for the Valkey container. |
| valkeyclusters.__helm_docs_example__.spec.shards | int | `3` | Number of shard groups. Each shard contains one primary and the configured replicas. |
| valkeyclusters.__helm_docs_example__.spec.tls | object | `{"certificate":{"secretName":"valkey-tls"}}` | TLS configuration for the cluster. |
| valkeyclusters.__helm_docs_example__.spec.tls.certificate | object | `{"secretName":"valkey-tls"}` | Certificate Secret reference. |
| valkeyclusters.__helm_docs_example__.spec.tls.certificate.secretName | string | `"valkey-tls"` | Secret containing `ca.crt`, `tls.crt`, and `tls.key`. |
| valkeyclusters.__helm_docs_example__.spec.tolerations | list | `[{"effect":"NoSchedule","key":"dedicated","operator":"Equal","value":"valkey"}]` | Tolerations applied to operator-created pods. |
| valkeyclusters.__helm_docs_example__.spec.tolerations[0].effect | string | `"NoSchedule"` | Taint effect tolerated by the pod. |
| valkeyclusters.__helm_docs_example__.spec.tolerations[0].key | string | `"dedicated"` | Taint key tolerated by the pod. |
| valkeyclusters.__helm_docs_example__.spec.tolerations[0].operator | string | `"Equal"` | Taint operator. |
| valkeyclusters.__helm_docs_example__.spec.tolerations[0].value | string | `"valkey"` | Taint value tolerated by the pod. |
| valkeyclusters.__helm_docs_example__.spec.users | list | `[{"channels":{"patterns":["app:*"]},"commands":{"allow":["@read","get"],"deny":["flushall"]},"enabled":true,"keys":{"readOnly":["shared:*"],"readWrite":["app:*"],"writeOnly":["ingest:*"]},"name":"app","nopass":false,"passwordSecret":{"keys":["password"],"name":"app-valkey-users"},"permissions":"+@connection"}]` | Valkey ACL user definitions. |
| valkeyclusters.__helm_docs_example__.spec.users[0].channels | object | `{"patterns":["app:*"]}` | Pub/Sub channel ACL restrictions. |
| valkeyclusters.__helm_docs_example__.spec.users[0].channels.patterns | list | `["app:*"]` | Allowed Pub/Sub channel patterns. |
| valkeyclusters.__helm_docs_example__.spec.users[0].commands | object | `{"allow":["@read","get"],"deny":["flushall"]}` | Command ACL restrictions. |
| valkeyclusters.__helm_docs_example__.spec.users[0].commands.allow | list | `["@read","get"]` | Allowed command categories, commands, or subcommands. |
| valkeyclusters.__helm_docs_example__.spec.users[0].commands.deny | list | `["flushall"]` | Denied command categories, commands, or subcommands. |
| valkeyclusters.__helm_docs_example__.spec.users[0].enabled | bool | `true` | Enable this ACL user. |
| valkeyclusters.__helm_docs_example__.spec.users[0].keys | object | `{"readOnly":["shared:*"],"readWrite":["app:*"],"writeOnly":["ingest:*"]}` | Key ACL restrictions. |
| valkeyclusters.__helm_docs_example__.spec.users[0].keys.readOnly | list | `["shared:*"]` | Read-only key patterns. |
| valkeyclusters.__helm_docs_example__.spec.users[0].keys.readWrite | list | `["app:*"]` | Read-write key patterns. |
| valkeyclusters.__helm_docs_example__.spec.users[0].keys.writeOnly | list | `["ingest:*"]` | Write-only key patterns. |
| valkeyclusters.__helm_docs_example__.spec.users[0].name | string | `"app"` | Valkey ACL username. Usernames cannot start with `_`. |
| valkeyclusters.__helm_docs_example__.spec.users[0].nopass | bool | `false` | Do not assign a password to this user. |
| valkeyclusters.__helm_docs_example__.spec.users[0].passwordSecret | object | `{"keys":["password"],"name":"app-valkey-users"}` | Reference to a Secret containing one or more passwords. |
| valkeyclusters.__helm_docs_example__.spec.users[0].passwordSecret.keys | list | `["password"]` | Secret keys containing passwords for this user. |
| valkeyclusters.__helm_docs_example__.spec.users[0].passwordSecret.name | string | `"app-valkey-users"` | Secret name containing password keys. Defaults to the cluster users Secret when omitted. |
| valkeyclusters.__helm_docs_example__.spec.users[0].permissions | string | `"+@connection"` | Raw ACL permissions appended to generated ACL rules. |
| valkeyclusters.__helm_docs_example__.spec.workloadType | string | `"StatefulSet"` | Pod workload type created by the operator. Supported values are `StatefulSet` and `Deployment`. |
| valkeyclusters.__helm_docs_example__.status | object | `{"conditions":[{"lastTransitionTime":"2026-01-01T00:00:00Z","message":"Documentation placeholder","reason":"Initializing","status":"False","type":"Ready"}],"message":"Documentation placeholder","readyShards":0,"reason":"DocumentationOnly","shards":0,"state":"Initializing"}` | Optional status block for tests or synthetic manifests. |
| valkeyclusters.__helm_docs_example__.status.conditions | list | `[{"lastTransitionTime":"2026-01-01T00:00:00Z","message":"Documentation placeholder","reason":"Initializing","status":"False","type":"Ready"}]` | Kubernetes-style status conditions. |
| valkeyclusters.__helm_docs_example__.status.conditions[0].lastTransitionTime | string | `"2026-01-01T00:00:00Z"` | Last transition timestamp. |
| valkeyclusters.__helm_docs_example__.status.conditions[0].message | string | `"Documentation placeholder"` | Condition message. |
| valkeyclusters.__helm_docs_example__.status.conditions[0].reason | string | `"Initializing"` | Condition reason. |
| valkeyclusters.__helm_docs_example__.status.conditions[0].status | string | `"False"` | Condition status. |
| valkeyclusters.__helm_docs_example__.status.conditions[0].type | string | `"Ready"` | Condition type. |
| valkeyclusters.__helm_docs_example__.status.message | string | `"Documentation placeholder"` | Human-readable status message. |
| valkeyclusters.__helm_docs_example__.status.readyShards | int | `0` | Ready shard count. |
| valkeyclusters.__helm_docs_example__.status.reason | string | `"DocumentationOnly"` | Machine-readable reason for the current state. |
| valkeyclusters.__helm_docs_example__.status.shards | int | `0` | Observed shard count. |
| valkeyclusters.__helm_docs_example__.status.state | string | `"Initializing"` | High-level cluster state. |
| valkeynodes | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"valkey.io/v1alpha1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}},"containers":[{"image":"oliver006/redis_exporter:v1.67.0","name":"metrics-exporter"}],"exporter":{"enabled":true,"image":"oliver006/redis_exporter:v1.67.0","resources":{"requests":{"cpu":"25m","memory":"64Mi"}}},"image":"valkey/valkey:8.1","nodeSelector":{"kubernetes.io/os":"linux"},"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}},"serverConfigMapName":"valkey-node-config","tls":{"certificate":{"secretName":"valkey-tls"}},"tolerations":[{"effect":"NoSchedule","key":"dedicated","operator":"Equal","value":"valkey"}],"usersACLSecretName":"valkey-users-acl","workloadType":"StatefulSet"},"status":{"conditions":[{"lastTransitionTime":"2026-01-01T00:00:00Z","message":"Documentation placeholder","reason":"PodNotReady","status":"False","type":"Ready"}],"observedGeneration":1,"podIP":"10.0.0.10","podName":"documentation-placeholder-0","ready":false,"role":"primary"}}}` | ValkeyNode resources keyed by resource name. ValkeyNode is an operator-internal kind; prefer ValkeyCluster for normal workloads. |
| valkeynodes.__helm_docs_example__ | object | `{"annotations":{},"apiVersion":"valkey.io/v1alpha1","labels":{},"name":"documentation-placeholder","namespace":"documentation-placeholder","spec":{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}},"containers":[{"image":"oliver006/redis_exporter:v1.67.0","name":"metrics-exporter"}],"exporter":{"enabled":true,"image":"oliver006/redis_exporter:v1.67.0","resources":{"requests":{"cpu":"25m","memory":"64Mi"}}},"image":"valkey/valkey:8.1","nodeSelector":{"kubernetes.io/os":"linux"},"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}},"serverConfigMapName":"valkey-node-config","tls":{"certificate":{"secretName":"valkey-tls"}},"tolerations":[{"effect":"NoSchedule","key":"dedicated","operator":"Equal","value":"valkey"}],"usersACLSecretName":"valkey-users-acl","workloadType":"StatefulSet"},"status":{"conditions":[{"lastTransitionTime":"2026-01-01T00:00:00Z","message":"Documentation placeholder","reason":"PodNotReady","status":"False","type":"Ready"}],"observedGeneration":1,"podIP":"10.0.0.10","podName":"documentation-placeholder-0","ready":false,"role":"primary"}}` | Documentation-only placeholder ignored by templates. |
| valkeynodes.__helm_docs_example__.annotations | object | `{}` | Additional annotations for this resource. |
| valkeynodes.__helm_docs_example__.apiVersion | string | `"valkey.io/v1alpha1"` | API version override for this resource. |
| valkeynodes.__helm_docs_example__.labels | object | `{}` | Additional labels for this resource. |
| valkeynodes.__helm_docs_example__.name | string | `"documentation-placeholder"` | Optional explicit metadata.name override. |
| valkeynodes.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Optional resource namespace. Defaults to the release namespace. |
| valkeynodes.__helm_docs_example__.spec | object | `{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}},"containers":[{"image":"oliver006/redis_exporter:v1.67.0","name":"metrics-exporter"}],"exporter":{"enabled":true,"image":"oliver006/redis_exporter:v1.67.0","resources":{"requests":{"cpu":"25m","memory":"64Mi"}}},"image":"valkey/valkey:8.1","nodeSelector":{"kubernetes.io/os":"linux"},"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}},"serverConfigMapName":"valkey-node-config","tls":{"certificate":{"secretName":"valkey-tls"}},"tolerations":[{"effect":"NoSchedule","key":"dedicated","operator":"Equal","value":"valkey"}],"usersACLSecretName":"valkey-users-acl","workloadType":"StatefulSet"}` | Desired state for a ValkeyNode custom resource. |
| valkeynodes.__helm_docs_example__.spec.affinity | object | `{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}}` | Pod affinity or anti-affinity rules for this node. |
| valkeynodes.__helm_docs_example__.spec.affinity.nodeAffinity | object | `{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}` | Node affinity rules. |
| valkeynodes.__helm_docs_example__.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution | object | `{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}` | Required node affinity rules. |
| valkeynodes.__helm_docs_example__.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms | list | `[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]` | Node selector terms. |
| valkeynodes.__helm_docs_example__.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions | list | `[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]` | Match expressions for the node selector term. |
| valkeynodes.__helm_docs_example__.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key | string | `"kubernetes.io/os"` | Node label key. |
| valkeynodes.__helm_docs_example__.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator | string | `"In"` | Node selector operator. |
| valkeynodes.__helm_docs_example__.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values | list | `["linux"]` | Node selector values. |
| valkeynodes.__helm_docs_example__.spec.containers | list | `[{"image":"oliver006/redis_exporter:v1.67.0","name":"metrics-exporter"}]` | Additional containers or strategic-merge overrides for default containers. |
| valkeynodes.__helm_docs_example__.spec.containers[0].image | string | `"oliver006/redis_exporter:v1.67.0"` | Container image override for the named container. |
| valkeynodes.__helm_docs_example__.spec.containers[0].name | string | `"metrics-exporter"` | Container name to add or patch. |
| valkeynodes.__helm_docs_example__.spec.exporter | object | `{"enabled":true,"image":"oliver006/redis_exporter:v1.67.0","resources":{"requests":{"cpu":"25m","memory":"64Mi"}}}` | Metrics exporter sidecar options. |
| valkeynodes.__helm_docs_example__.spec.exporter.enabled | bool | `true` | Enable the metrics exporter sidecar. |
| valkeynodes.__helm_docs_example__.spec.exporter.image | string | `"oliver006/redis_exporter:v1.67.0"` | Metrics exporter image override. |
| valkeynodes.__helm_docs_example__.spec.exporter.resources | object | `{"requests":{"cpu":"25m","memory":"64Mi"}}` | Resource requirements for the metrics exporter sidecar. |
| valkeynodes.__helm_docs_example__.spec.exporter.resources.requests | object | `{"cpu":"25m","memory":"64Mi"}` | Metrics exporter resource requests. |
| valkeynodes.__helm_docs_example__.spec.exporter.resources.requests.cpu | string | `"25m"` | Requested CPU for the metrics exporter. |
| valkeynodes.__helm_docs_example__.spec.exporter.resources.requests.memory | string | `"64Mi"` | Requested memory for the metrics exporter. |
| valkeynodes.__helm_docs_example__.spec.image | string | `"valkey/valkey:8.1"` | Valkey container image override. |
| valkeynodes.__helm_docs_example__.spec.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | Node selector applied to this node's pod. |
| valkeynodes.__helm_docs_example__.spec.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resource requirements for the Valkey container. |
| valkeynodes.__helm_docs_example__.spec.resources.limits | object | `{"cpu":"500m","memory":"512Mi"}` | Container resource limits. |
| valkeynodes.__helm_docs_example__.spec.resources.limits.cpu | string | `"500m"` | CPU limit for the Valkey container. |
| valkeynodes.__helm_docs_example__.spec.resources.limits.memory | string | `"512Mi"` | Memory limit for the Valkey container. |
| valkeynodes.__helm_docs_example__.spec.resources.requests | object | `{"cpu":"100m","memory":"256Mi"}` | Container resource requests. |
| valkeynodes.__helm_docs_example__.spec.resources.requests.cpu | string | `"100m"` | Requested CPU for the Valkey container. |
| valkeynodes.__helm_docs_example__.spec.resources.requests.memory | string | `"256Mi"` | Requested memory for the Valkey container. |
| valkeynodes.__helm_docs_example__.spec.serverConfigMapName | string | `"valkey-node-config"` | ConfigMap name containing Valkey server scripts and configuration. |
| valkeynodes.__helm_docs_example__.spec.tls | object | `{"certificate":{"secretName":"valkey-tls"}}` | TLS configuration for the node. |
| valkeynodes.__helm_docs_example__.spec.tls.certificate | object | `{"secretName":"valkey-tls"}` | Certificate Secret reference. |
| valkeynodes.__helm_docs_example__.spec.tls.certificate.secretName | string | `"valkey-tls"` | Secret containing `ca.crt`, `tls.crt`, and `tls.key`. |
| valkeynodes.__helm_docs_example__.spec.tolerations | list | `[{"effect":"NoSchedule","key":"dedicated","operator":"Equal","value":"valkey"}]` | Tolerations applied to this node's pod. |
| valkeynodes.__helm_docs_example__.spec.tolerations[0].effect | string | `"NoSchedule"` | Taint effect tolerated by the pod. |
| valkeynodes.__helm_docs_example__.spec.tolerations[0].key | string | `"dedicated"` | Taint key tolerated by the pod. |
| valkeynodes.__helm_docs_example__.spec.tolerations[0].operator | string | `"Equal"` | Taint operator. |
| valkeynodes.__helm_docs_example__.spec.tolerations[0].value | string | `"valkey"` | Taint value tolerated by the pod. |
| valkeynodes.__helm_docs_example__.spec.usersACLSecretName | string | `"valkey-users-acl"` | Secret name containing the ACL user file. |
| valkeynodes.__helm_docs_example__.spec.workloadType | string | `"StatefulSet"` | Pod workload type created by the operator. Supported values are `StatefulSet` and `Deployment`. |
| valkeynodes.__helm_docs_example__.status | object | `{"conditions":[{"lastTransitionTime":"2026-01-01T00:00:00Z","message":"Documentation placeholder","reason":"PodNotReady","status":"False","type":"Ready"}],"observedGeneration":1,"podIP":"10.0.0.10","podName":"documentation-placeholder-0","ready":false,"role":"primary"}` | Optional status block for tests or synthetic manifests. |
| valkeynodes.__helm_docs_example__.status.conditions | list | `[{"lastTransitionTime":"2026-01-01T00:00:00Z","message":"Documentation placeholder","reason":"PodNotReady","status":"False","type":"Ready"}]` | Kubernetes-style status conditions. |
| valkeynodes.__helm_docs_example__.status.conditions[0].lastTransitionTime | string | `"2026-01-01T00:00:00Z"` | Last transition timestamp. |
| valkeynodes.__helm_docs_example__.status.conditions[0].message | string | `"Documentation placeholder"` | Condition message. |
| valkeynodes.__helm_docs_example__.status.conditions[0].reason | string | `"PodNotReady"` | Condition reason. |
| valkeynodes.__helm_docs_example__.status.conditions[0].status | string | `"False"` | Condition status. |
| valkeynodes.__helm_docs_example__.status.conditions[0].type | string | `"Ready"` | Condition type. |
| valkeynodes.__helm_docs_example__.status.observedGeneration | int | `1` | Most recent generation observed by the controller. |
| valkeynodes.__helm_docs_example__.status.podIP | string | `"10.0.0.10"` | Pod IP address. |
| valkeynodes.__helm_docs_example__.status.podName | string | `"documentation-placeholder-0"` | Pod name created by the operator workload. |
| valkeynodes.__helm_docs_example__.status.ready | bool | `false` | Whether the ValkeyNode is ready to serve traffic. |
| valkeynodes.__helm_docs_example__.status.role | string | `"primary"` | Valkey replication role such as `primary` or `replica`. |

## Representative Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources
- [values.yaml.example](values.yaml.example): representative example covering every supported resource type
- [tests/smokes/fixtures/example.values.yaml](tests/smokes/fixtures/example.values.yaml): smoke-test fixture
- [tests/units/values/example.values.yaml](tests/units/values/example.values.yaml): unit-test fixture for representative resource checks

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward-compatibility checks
- `tests/smokes/` for render-path smoke scenarios
- `tests/e2e/` for local kind-based Helm install checks against real Valkey Operator CRDs

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

- Keep the chart API versions aligned with the Valkey Operator CRDs installed in the cluster.
- The chart does not install the Valkey Operator controller or the CRDs.
- The e2e test installs upstream CRDs only as test setup; those CRDs are not chart templates.

## Repository Layout

| Path | Purpose |
|------|---------|
| [Chart.yaml](Chart.yaml) | Chart metadata. |
| [values.yaml](values.yaml) | Minimal default values and `helm-docs` source comments. |
| [values.yaml.example](values.yaml.example) | Representative values covering supported resources. |
| [docs/README.md.gotmpl](docs/README.md.gotmpl) | Template used by `helm-docs` to build `README.md`. |
| [.pre-commit-config.yaml](.pre-commit-config.yaml) | Local hooks, including automatic `helm-docs` generation on commit. |
| [templates/](templates) | Valkey Operator resource templates for `ValkeyCluster` and `ValkeyNode`. |
| [tests/units/](tests/units) | Compact Helm unit suites and backward compatibility checks. |
| [tests/e2e/](tests/e2e) | Local kind-based end-to-end installation checks. |
| [tests/e2e/crds/](tests/e2e/crds) | Test-only copies of upstream Valkey Operator CRDs. |
| [tests/smokes/](tests/smokes) | Smoke scenarios for render validation. |
| [docs/DEPENDENCY.md](docs/DEPENDENCY.md) | Local dependency installation guide for development and tests. |
| [docs/TESTS.MD](docs/TESTS.MD) | Detailed testing documentation. |
