# KServe

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kserve)](https://artifacthub.io/packages/search?repo=kserve)

Helm chart for rendering KServe custom resources from declarative values.

The chart does not install KServe CRDs or controllers. It only renders KServe objects that are already supported by the target cluster.

## Quick Start

Install the chart:

```bash
helm install kserve oci://ghcr.io/riftonix/helm-shared/libs/kserve \
  --namespace kserve \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

The chart can render these KServe kinds:

- `ClusterServingRuntime`
- `ClusterStorageContainer`
- `InferenceGraph`
- `InferenceService`
- `LocalModelCache`
- `LocalModelNodeGroup`
- `LocalModelNode`
- `ServingRuntime`
- `TrainedModel`

## Values Model

Each top-level map in [values.yaml](values.yaml) maps to one resource kind:

- `clusterServingRuntimes`
- `clusterStorageContainers`
- `inferenceGraphs`
- `inferenceServices`
- `localModelCaches`
- `localModelNodeGroups`
- `localModelNodes`
- `servingRuntimes`
- `trainedModels`

Every map value uses the same generic contract, and the resource name comes from the map key:

| Field | Required | Description |
|-------|----------|-------------|
| `enabled` | no | Set to `false` to keep a documented stub entry from rendering. |
| `namespace` | no | Namespace for namespaced resources. Defaults to the Helm release namespace. Ignored for cluster-scoped kinds. |
| `labels` | no | Labels merged on top of built-in chart labels and `commonLabels`. |
| `annotations` | no | Annotations merged on top of `commonAnnotations`. |
| `apiVersion` | no | Per-resource API version override. |
| `spec` | no | Raw resource spec rendered as-is. |
| `status` | no | Optional raw status block. Usually useful only for fixtures. |

In a higher-precedence values file, set a map entry to `null` to suppress a default resource from a lower-precedence values file.

Global controls:

- `enabled`
- `nameOverride`
- `commonLabels`
- `commonAnnotations`
- `apiVersions.*`
- `global` (accepted for umbrella-chart compatibility and ignored by templates)

The value contract is validated by [values.schema.json](values.schema.json).

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` or `make docs` if you need to refresh it outside a commit.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions.clusterServingRuntime | string | `"serving.kserve.io/v1alpha1"` | Default apiVersion for ClusterServingRuntime resources. |
| apiVersions.clusterStorageContainer | string | `"serving.kserve.io/v1alpha1"` | Default apiVersion for ClusterStorageContainer resources. |
| apiVersions.inferenceGraph | string | `"serving.kserve.io/v1alpha1"` | Default apiVersion for InferenceGraph resources. |
| apiVersions.inferenceService | string | `"serving.kserve.io/v1beta1"` | Default apiVersion for InferenceService resources. |
| apiVersions.localModelCache | string | `"serving.kserve.io/v1alpha1"` | Default apiVersion for LocalModelCache resources. |
| apiVersions.localModelNode | string | `"serving.kserve.io/v1alpha1"` | Default apiVersion for LocalModelNode resources. |
| apiVersions.localModelNodeGroup | string | `"serving.kserve.io/v1alpha1"` | Default apiVersion for LocalModelNodeGroup resources. |
| apiVersions.servingRuntime | string | `"serving.kserve.io/v1alpha1"` | Default apiVersion for ServingRuntime resources. |
| apiVersions.trainedModel | string | `"serving.kserve.io/v1alpha1"` | Default apiVersion for TrainedModel resources. |
| clusterServingRuntimes | object | `{"example-clusterservingruntime":{"annotations":{},"apiVersion":"serving.kserve.io/v1alpha1","enabled":false,"labels":{},"spec":{"containers":[{"args":["--model_name={{.Name}}","--model_dir=/mnt/models"],"image":"example/runtime:latest","name":"kserve-container"}],"protocolVersions":["v1","v2"],"supportedModelFormats":[{"autoSelect":true,"name":"sklearn","priority":1,"version":"1"}]},"status":{}}}` | ClusterServingRuntime resources to render, keyed by resource name. |
| clusterServingRuntimes.example-clusterservingruntime.annotations | object | `{}` | Additional resource annotations. |
| clusterServingRuntimes.example-clusterservingruntime.apiVersion | string | `"serving.kserve.io/v1alpha1"` | Per-resource apiVersion override. |
| clusterServingRuntimes.example-clusterservingruntime.enabled | bool | `false` | Set to `true` to render this resource. |
| clusterServingRuntimes.example-clusterservingruntime.labels | object | `{}` | Additional resource labels. |
| clusterServingRuntimes.example-clusterservingruntime.spec.containers[0].args | list | `["--model_name={{.Name}}","--model_dir=/mnt/models"]` | Runtime container arguments. |
| clusterServingRuntimes.example-clusterservingruntime.spec.containers[0].image | string | `"example/runtime:latest"` | Runtime container image. |
| clusterServingRuntimes.example-clusterservingruntime.spec.containers[0].name | string | `"kserve-container"` | Runtime container name. |
| clusterServingRuntimes.example-clusterservingruntime.spec.protocolVersions | list | `["v1","v2"]` | Supported inference protocol versions. |
| clusterServingRuntimes.example-clusterservingruntime.spec.supportedModelFormats[0].autoSelect | bool | `true` | Mark this format for autoselection. |
| clusterServingRuntimes.example-clusterservingruntime.spec.supportedModelFormats[0].name | string | `"sklearn"` | Supported model format name. |
| clusterServingRuntimes.example-clusterservingruntime.spec.supportedModelFormats[0].priority | int | `1` | Priority used when multiple runtimes support the same format. |
| clusterServingRuntimes.example-clusterservingruntime.spec.supportedModelFormats[0].version | string | `"1"` | Supported model format version. |
| clusterServingRuntimes.example-clusterservingruntime.status | object | `{}` | Optional synthetic status payload. |
| clusterStorageContainers | object | `{"example-clusterstoragecontainer":{"annotations":{},"apiVersion":"serving.kserve.io/v1alpha1","enabled":false,"labels":{},"spec":{"container":{"image":"example/storage-initializer:latest","imagePullPolicy":"IfNotPresent","name":"storage-initializer"},"supportedUriFormats":[{"prefix":"s3://"},{"regex":"https?://(.+)/(.+)"}],"workloadType":"initContainer"},"status":{}}}` | ClusterStorageContainer resources to render, keyed by resource name. |
| clusterStorageContainers.example-clusterstoragecontainer.enabled | bool | `false` | Set to `true` to render this resource. |
| clusterStorageContainers.example-clusterstoragecontainer.spec.container.image | string | `"example/storage-initializer:latest"` | Storage initializer image. |
| clusterStorageContainers.example-clusterstoragecontainer.spec.container.imagePullPolicy | string | `"IfNotPresent"` | Image pull policy for the storage initializer. |
| clusterStorageContainers.example-clusterstoragecontainer.spec.container.name | string | `"storage-initializer"` | Storage initializer container name. |
| clusterStorageContainers.example-clusterstoragecontainer.spec.supportedUriFormats[0].prefix | string | `"s3://"` | URI prefix handled by this storage container. |
| clusterStorageContainers.example-clusterstoragecontainer.spec.supportedUriFormats[1].regex | string | `"https?://(.+)/(.+)"` | URI regex handled by this storage container. |
| clusterStorageContainers.example-clusterstoragecontainer.spec.workloadType | string | `"initContainer"` | Workload type used by the storage container. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` | Enable kserve chart rendering. |
| global | object | `{}` | Compatibility values inherited from umbrella charts. Accepted but ignored by this chart. |
| inferenceGraphs | object | `{"example-inferencegraph":{"annotations":{},"apiVersion":"serving.kserve.io/v1alpha1","enabled":false,"labels":{},"namespace":"default","spec":{"nodes":{"root":{"routerType":"Sequence","steps":[{"serviceName":"predictor-a"},{"data":"$request","serviceName":"predictor-b"}]}}},"status":{}}}` | InferenceGraph resources to render, keyed by resource name. |
| inferenceGraphs.example-inferencegraph.enabled | bool | `false` | Set to `true` to render this resource. |
| inferenceGraphs.example-inferencegraph.namespace | string | `"default"` | Resource namespace. Defaults to the Helm release namespace. |
| inferenceGraphs.example-inferencegraph.spec.nodes.root.routerType | string | `"Sequence"` | Router strategy used by the root node. |
| inferenceGraphs.example-inferencegraph.spec.nodes.root.steps[0].serviceName | string | `"predictor-a"` | Downstream service name for a graph step. |
| inferenceGraphs.example-inferencegraph.spec.nodes.root.steps[1].data | string | `"$request"` | Optional payload source for the next step. |
| inferenceServices | object | `{"example-inferenceservice":{"annotations":{},"apiVersion":"serving.kserve.io/v1beta1","enabled":false,"labels":{},"namespace":"default","spec":{"predictor":{"sklearn":{"storageUri":"s3://models/sklearn"}}},"status":{}}}` | InferenceService resources to render, keyed by resource name. |
| inferenceServices.example-inferenceservice.enabled | bool | `false` | Set to `true` to render this resource. |
| inferenceServices.example-inferenceservice.namespace | string | `"default"` | Resource namespace. Defaults to the Helm release namespace. |
| inferenceServices.example-inferenceservice.spec.predictor.sklearn.storageUri | string | `"s3://models/sklearn"` | Model storage URI for the built-in sklearn predictor. |
| localModelCaches | object | `{"example-localmodelcache":{"annotations":{},"apiVersion":"serving.kserve.io/v1alpha1","enabled":false,"labels":{},"spec":{"modelSize":"10Gi","nodeGroups":["example-node-group"],"sourceModelUri":"s3://models/example"},"status":{}}}` | LocalModelCache resources to render, keyed by resource name. |
| localModelCaches.example-localmodelcache.enabled | bool | `false` | Set to `true` to render this resource. |
| localModelCaches.example-localmodelcache.spec.modelSize | string | `"10Gi"` | Estimated cached model size. |
| localModelCaches.example-localmodelcache.spec.nodeGroups | list | `["example-node-group"]` | Target LocalModelNodeGroup names. |
| localModelCaches.example-localmodelcache.spec.sourceModelUri | string | `"s3://models/example"` | Source model URI. |
| localModelNodeGroups | object | `{"example-localmodelnodegroup":{"annotations":{},"apiVersion":"serving.kserve.io/v1alpha1","enabled":false,"labels":{},"spec":{"persistentVolumeClaimSpec":{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"20Gi"}},"storageClassName":"standard"},"persistentVolumeSpec":{"accessModes":["ReadWriteOnce"],"capacity":{"storage":"20Gi"},"hostPath":{"path":"/var/lib/kserve/localmodel"},"persistentVolumeReclaimPolicy":"Delete"},"storageLimit":"100Gi"},"status":{}}}` | LocalModelNodeGroup resources to render, keyed by resource name. |
| localModelNodeGroups.example-localmodelnodegroup.enabled | bool | `false` | Set to `true` to render this resource. |
| localModelNodeGroups.example-localmodelnodegroup.spec.persistentVolumeClaimSpec.accessModes | list | `["ReadWriteOnce"]` | PersistentVolumeClaim access modes. |
| localModelNodeGroups.example-localmodelnodegroup.spec.persistentVolumeClaimSpec.resources.requests.storage | string | `"20Gi"` | Requested PVC storage size. |
| localModelNodeGroups.example-localmodelnodegroup.spec.persistentVolumeClaimSpec.storageClassName | string | `"standard"` | PVC storage class name. |
| localModelNodeGroups.example-localmodelnodegroup.spec.persistentVolumeSpec.accessModes | list | `["ReadWriteOnce"]` | Backing PersistentVolume access modes. |
| localModelNodeGroups.example-localmodelnodegroup.spec.persistentVolumeSpec.capacity.storage | string | `"20Gi"` | Backing PersistentVolume storage size. |
| localModelNodeGroups.example-localmodelnodegroup.spec.persistentVolumeSpec.hostPath.path | string | `"/var/lib/kserve/localmodel"` | Host path used by the backing PersistentVolume. |
| localModelNodeGroups.example-localmodelnodegroup.spec.persistentVolumeSpec.persistentVolumeReclaimPolicy | string | `"Delete"` | Reclaim policy for the backing PersistentVolume. |
| localModelNodeGroups.example-localmodelnodegroup.spec.storageLimit | string | `"100Gi"` | Maximum aggregate storage allowed for the node group. |
| localModelNodes | object | `{"example-localmodelnode":{"annotations":{},"apiVersion":"serving.kserve.io/v1alpha1","enabled":false,"labels":{},"spec":{"localModels":[{"modelName":"example-model","nodeGroup":"example-node-group","sourceModelUri":"s3://models/example"}]},"status":{}}}` | LocalModelNode resources to render, keyed by resource name. |
| localModelNodes.example-localmodelnode.enabled | bool | `false` | Set to `true` to render this resource. |
| localModelNodes.example-localmodelnode.spec.localModels[0].modelName | string | `"example-model"` | Logical model name stored on the node. |
| localModelNodes.example-localmodelnode.spec.localModels[0].nodeGroup | string | `"example-node-group"` | Target node group for this local model. |
| localModelNodes.example-localmodelnode.spec.localModels[0].sourceModelUri | string | `"s3://models/example"` | Source model URI for this local model. |
| nameOverride | string | `""` | Override the default chart label name if needed. |
| servingRuntimes | object | `{"example-servingruntime":{"annotations":{},"apiVersion":"serving.kserve.io/v1alpha1","enabled":false,"labels":{},"namespace":"default","spec":{"containers":[{"args":["--model_name={{.Name}}","--model_dir=/mnt/models"],"image":"example/runtime:latest","name":"kserve-container"}],"supportedModelFormats":[{"autoSelect":true,"name":"sklearn","priority":1,"version":"1"}]},"status":{}}}` | ServingRuntime resources to render, keyed by resource name. |
| servingRuntimes.example-servingruntime.enabled | bool | `false` | Set to `true` to render this resource. |
| servingRuntimes.example-servingruntime.namespace | string | `"default"` | Resource namespace. Defaults to the Helm release namespace. |
| servingRuntimes.example-servingruntime.spec.containers[0].args | list | `["--model_name={{.Name}}","--model_dir=/mnt/models"]` | Runtime container arguments. |
| servingRuntimes.example-servingruntime.spec.containers[0].image | string | `"example/runtime:latest"` | Runtime container image. |
| servingRuntimes.example-servingruntime.spec.containers[0].name | string | `"kserve-container"` | Runtime container name. |
| servingRuntimes.example-servingruntime.spec.supportedModelFormats[0].autoSelect | bool | `true` | Mark this format for autoselection. |
| servingRuntimes.example-servingruntime.spec.supportedModelFormats[0].name | string | `"sklearn"` | Supported model format name. |
| servingRuntimes.example-servingruntime.spec.supportedModelFormats[0].priority | int | `1` | Priority used when multiple runtimes support the same format. |
| servingRuntimes.example-servingruntime.spec.supportedModelFormats[0].version | string | `"1"` | Supported model format version. |
| trainedModels | object | `{"example-trainedmodel":{"annotations":{},"apiVersion":"serving.kserve.io/v1alpha1","enabled":false,"labels":{},"namespace":"default","spec":{"inferenceService":"example-inferenceservice","model":{"framework":"sklearn","memory":"2Gi","storageUri":"s3://models/sklearn"}},"status":{}}}` | TrainedModel resources to render, keyed by resource name. |
| trainedModels.example-trainedmodel.enabled | bool | `false` | Set to `true` to render this resource. |
| trainedModels.example-trainedmodel.namespace | string | `"default"` | Resource namespace. Defaults to the Helm release namespace. |
| trainedModels.example-trainedmodel.spec.inferenceService | string | `"example-inferenceservice"` | Target InferenceService name. |
| trainedModels.example-trainedmodel.spec.model.framework | string | `"sklearn"` | Model framework identifier. |
| trainedModels.example-trainedmodel.spec.model.memory | string | `"2Gi"` | Memory request associated with the trained model. |
| trainedModels.example-trainedmodel.spec.model.storageUri | string | `"s3://models/sklearn"` | Model storage URI. |

## Included Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources.
- [values.yaml.example](values.yaml.example): example configuration covering every supported resource type.

## Testing

The repository uses three test layers:

- `tests/units/` for `helm-unittest` suites and backward compatibility checks
- `tests/e2e/` for local kind-based Helm install checks after bootstrapping KServe CRDs from vendored upstream manifests
- `tests/smokes/` for render and schema smoke scenarios

Representative local commands:

```bash
helm lint . -f values.yaml.example
helm template kserve . -f values.yaml.example
helm unittest -f 'tests/units/*_test.yaml' .
sh tests/units/backward_compatibility_test.sh
python3 tests/smokes/run/smoke.py --scenario example-render
make test-e2e
```
