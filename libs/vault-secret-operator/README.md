# Vault Secret Operator

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/vault-secret-operator)](https://artifacthub.io/packages/search?repo=vault-secret-operator)

Helm chart for rendering HashiCorp Vault Secret Operator resources from declarative values.

The chart does not install Vault Secret Operator CRDs or the operator itself. It renders the supported Vault Secrets Operator resources expected to be available in the target cluster.

## Quick Start

Install the chart:

```bash
helm install vault-secret-operator oci://ghcr.io/riftonix/helm-shared/libs/vault-secret-operator \
  --namespace vault-secret-operator \
  --create-namespace
```

Install the local README generator hook:

```bash
pre-commit install
pre-commit install-hooks
```

## Supported Resources

- `HCPAuth`
- `HCPVaultSecretsApp`
- `SecretTransformation`
- `VaultAuth`
- `VaultAuthGlobal`
- `VaultConnection`
- `VaultDynamicSecret`
- `VaultPKISecret`
- `VaultStaticSecret`

## Values Model

The chart exposes one keyed map per supported resource kind:

- `hcpAuths`
- `hcpVaultSecretsApps`
- `secretTransformations`
- `vaultAuths`
- `vaultAuthGlobals`
- `vaultConnections`
- `vaultDynamicSecrets`
- `vaultPKISecrets`
- `vaultStaticSecrets`

Each map follows the same generic contract used by dependency charts for `appchart`: the key becomes `metadata.name`, while `namespace`, `labels`, `annotations`, `apiVersion`, `spec`, and `status` remain configurable per resource. `VaultAuth` and `VaultStaticSecret` additionally preserve the legacy shorthand fields and the deprecated singleton `vaultAuth` block for backward compatibility.

For shorthand values, `vaultNamespace` maps to the upstream `spec.namespace` field because the top-level `namespace` key is reserved for `metadata.namespace`.

Global controls:

- `nameOverride`
- `releasePrefix`
- `commonLabels`
- `commonAnnotations`
- `global`
- `apiVersions.*`

The values contract is validated by [values.schema.json](values.schema.json).

## Helm Values

This section is generated from [values.yaml](values.yaml) by `helm-docs`. Edit [values.yaml](values.yaml) comments or [docs/README.md.gotmpl](docs/README.md.gotmpl), then run `pre-commit run helm-docs --all-files` or `make docs`.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersions.hcpAuth | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for HCPAuth resources. |
| apiVersions.hcpVaultSecretsApp | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for HCPVaultSecretsApp resources. |
| apiVersions.secretTransformation | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for SecretTransformation resources. |
| apiVersions.vaultAuth | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for VaultAuth resources. |
| apiVersions.vaultAuthGlobal | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for VaultAuthGlobal resources. |
| apiVersions.vaultConnection | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for VaultConnection resources. |
| apiVersions.vaultDynamicSecret | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for VaultDynamicSecret resources. |
| apiVersions.vaultPKISecret | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for VaultPKISecret resources. |
| apiVersions.vaultStaticSecret | string | `"secrets.hashicorp.com/v1beta1"` | Default apiVersion for VaultStaticSecret resources. |
| commonAnnotations | object | `{}` | Extra annotations applied to every rendered resource in addition to Helm hook annotations. |
| commonLabels | object | `{}` | Extra labels applied to every rendered resource. |
| enabled | bool | `true` |  |
| global | object | `{}` | Arbitrary global values available to tpl-rendered strings. |
| hcpAuths | object | {} | Generic HCPAuth resources keyed by resource name. |
| hcpAuths.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| hcpAuths.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| hcpAuths.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| hcpAuths.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the HCPAuth resource. Defaults to the Helm release namespace. |
| hcpAuths.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| hcpAuths.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| hcpVaultSecretsApps | object | {} | Generic HCPVaultSecretsApp resources keyed by resource name. |
| hcpVaultSecretsApps.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| hcpVaultSecretsApps.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| hcpVaultSecretsApps.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| hcpVaultSecretsApps.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the HCPVaultSecretsApp resource. Defaults to the Helm release namespace. |
| hcpVaultSecretsApps.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| hcpVaultSecretsApps.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| nameOverride | string | `""` | Override the generated base name if needed. |
| releasePrefix | string | `""` | Optional release prefix used for generated names. |
| secretTransformations | object | {} | Generic SecretTransformation resources keyed by resource name. |
| secretTransformations.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| secretTransformations.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| secretTransformations.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| secretTransformations.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the SecretTransformation resource. Defaults to the Helm release namespace. |
| secretTransformations.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| secretTransformations.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| vaultAuth | object | {} | Deprecated single VaultAuth resource configuration kept for backward compatibility. |
| vaultAuthGlobals | object | {} | Generic VaultAuthGlobal resources keyed by resource name. |
| vaultAuthGlobals.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| vaultAuthGlobals.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| vaultAuthGlobals.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| vaultAuthGlobals.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the VaultAuthGlobal resource. Defaults to the Helm release namespace. |
| vaultAuthGlobals.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| vaultAuthGlobals.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| vaultAuths | object | `{"__helm_docs_example__":{"allowedNamespaces":[],"annotations":{},"apiVersion":"secrets.hashicorp.com/v1beta1","appRole":{},"aws":{},"gcp":{},"headers":{},"jwt":{},"kubernetes":{},"labels":{},"method":"kubernetes","mount":"kubernetes","namespace":"documentation-placeholder","params":{},"role":"app-role","serviceAccount":"default","spec":{},"storageEncryption":{},"vaultAuthGlobalRef":{},"vaultConnectionRef":"default","vaultNamespace":""}}` | VaultAuth resources keyed by resource name. |
| vaultAuths.__helm_docs_example__.allowedNamespaces | list | `[]` | Namespaces allowed to reference this VaultAuth. |
| vaultAuths.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| vaultAuths.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| vaultAuths.__helm_docs_example__.appRole | object | `{}` | Optional AppRole auth config rendered as `spec.appRole`. |
| vaultAuths.__helm_docs_example__.aws | object | `{}` | Optional AWS auth config rendered as `spec.aws`. |
| vaultAuths.__helm_docs_example__.gcp | object | `{}` | Optional GCP auth config rendered as `spec.gcp`. |
| vaultAuths.__helm_docs_example__.headers | object | `{}` | Optional auth request headers rendered as `spec.headers`. |
| vaultAuths.__helm_docs_example__.jwt | object | `{}` | Optional JWT auth config rendered as `spec.jwt`. |
| vaultAuths.__helm_docs_example__.kubernetes | object | `{}` | Optional Kubernetes auth config rendered as `spec.kubernetes`. |
| vaultAuths.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| vaultAuths.__helm_docs_example__.method | string | `"kubernetes"` | Vault auth method. |
| vaultAuths.__helm_docs_example__.mount | string | `"kubernetes"` | Vault auth mount. |
| vaultAuths.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the VaultAuth resource. Defaults to the Helm release namespace. |
| vaultAuths.__helm_docs_example__.params | object | `{}` | Optional auth request params rendered as `spec.params`. |
| vaultAuths.__helm_docs_example__.role | string | `"app-role"` | Vault role. |
| vaultAuths.__helm_docs_example__.serviceAccount | string | `"default"` | Kubernetes ServiceAccount used by VSO. |
| vaultAuths.__helm_docs_example__.spec | object | `{}` | Optional raw spec rendered as-is. When set, shorthand fields above are ignored. |
| vaultAuths.__helm_docs_example__.storageEncryption | object | `{}` | Optional storage encryption config rendered as `spec.storageEncryption`. |
| vaultAuths.__helm_docs_example__.vaultAuthGlobalRef | object | `{}` | Optional VaultAuthGlobal reference block rendered as `spec.vaultAuthGlobalRef`. |
| vaultAuths.__helm_docs_example__.vaultConnectionRef | string | `"default"` | VaultConnection reference. |
| vaultAuths.__helm_docs_example__.vaultNamespace | string | `""` | Vault Enterprise namespace used for authentication. Rendered as `spec.namespace`. |
| vaultConnections | object | {} | Generic VaultConnection resources keyed by resource name. |
| vaultConnections.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| vaultConnections.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| vaultConnections.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| vaultConnections.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the VaultConnection resource. Defaults to the Helm release namespace. |
| vaultConnections.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| vaultConnections.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| vaultDynamicSecrets | object | {} | Generic VaultDynamicSecret resources keyed by resource name. |
| vaultDynamicSecrets.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| vaultDynamicSecrets.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| vaultDynamicSecrets.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| vaultDynamicSecrets.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the VaultDynamicSecret resource. Defaults to the Helm release namespace. |
| vaultDynamicSecrets.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| vaultDynamicSecrets.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| vaultPKISecrets | object | {} | Generic VaultPKISecret resources keyed by resource name. |
| vaultPKISecrets.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| vaultPKISecrets.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| vaultPKISecrets.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| vaultPKISecrets.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the VaultPKISecret resource. Defaults to the Helm release namespace. |
| vaultPKISecrets.__helm_docs_example__.spec | object | `{}` | Resource spec rendered as-is. |
| vaultPKISecrets.__helm_docs_example__.status | object | `{}` | Optional resource status rendered as-is. |
| vaultStaticSecrets | object | `{"__helm_docs_example__":{"annotations":{},"apiVersion":"secrets.hashicorp.com/v1beta1","create":true,"destSec":"app-secret","destination":{},"destinationAnnotations":{},"destinationLabels":{},"destinationType":"","hmacSecretData":true,"labels":{},"mount":"develop","namespace":"documentation-placeholder","overwrite":false,"path":"application/dev/envs","refreshAfter":"1m","restartTargets":[],"spec":{},"syncConfig":{},"transformation":{},"type":"Opaque","vaultAuthRef":"documentation-placeholder","vaultNamespace":"","vaultType":"kv-v2","version":1}}` | VaultStaticSecret resources keyed by resource name. |
| vaultStaticSecrets.__helm_docs_example__.annotations | object | `{}` | Resource-specific annotations. |
| vaultStaticSecrets.__helm_docs_example__.apiVersion | string | `"secrets.hashicorp.com/v1beta1"` | Per-resource apiVersion override. |
| vaultStaticSecrets.__helm_docs_example__.create | bool | `true` | Whether VSO should create the destination Secret. |
| vaultStaticSecrets.__helm_docs_example__.destSec | string | `"app-secret"` | Destination Kubernetes Secret name. Defaults to the map key. |
| vaultStaticSecrets.__helm_docs_example__.destination | object | `{}` | Optional full destination block rendered as `spec.destination`. |
| vaultStaticSecrets.__helm_docs_example__.destinationAnnotations | object | `{}` | Optional annotations merged into `spec.destination.annotations`. |
| vaultStaticSecrets.__helm_docs_example__.destinationLabels | object | `{}` | Optional labels merged into `spec.destination.labels`. |
| vaultStaticSecrets.__helm_docs_example__.destinationType | string | `""` | Optional explicit destination Secret type. |
| vaultStaticSecrets.__helm_docs_example__.hmacSecretData | bool | `true` | Whether VSO should compute HMAC for drift detection. Rendered as `spec.hmacSecretData`. |
| vaultStaticSecrets.__helm_docs_example__.labels | object | `{}` | Resource-specific labels. |
| vaultStaticSecrets.__helm_docs_example__.mount | string | `"develop"` | Vault mount. |
| vaultStaticSecrets.__helm_docs_example__.namespace | string | `"documentation-placeholder"` | Namespace for the VaultStaticSecret resource. Defaults to the Helm release namespace. |
| vaultStaticSecrets.__helm_docs_example__.overwrite | bool | `false` | Whether VSO should overwrite the destination Secret when it already exists. |
| vaultStaticSecrets.__helm_docs_example__.path | string | `"application/dev/envs"` | Vault path. |
| vaultStaticSecrets.__helm_docs_example__.refreshAfter | string | `"1m"` | Secret refresh interval. |
| vaultStaticSecrets.__helm_docs_example__.restartTargets | list | `[]` | Optional rollout restart targets. |
| vaultStaticSecrets.__helm_docs_example__.spec | object | `{}` | Optional raw spec rendered as-is. When set, shorthand fields above are ignored. |
| vaultStaticSecrets.__helm_docs_example__.syncConfig | object | `{}` | Optional sync configuration rendered as `spec.syncConfig`. |
| vaultStaticSecrets.__helm_docs_example__.transformation | object | `{}` | Optional transformation rendered as `spec.destination.transformation`. |
| vaultStaticSecrets.__helm_docs_example__.type | string | `"Opaque"` | Destination Kubernetes Secret type. Kept compatible with the previous chart format. |
| vaultStaticSecrets.__helm_docs_example__.vaultAuthRef | string | `"documentation-placeholder"` | VaultAuth reference. Defaults to `global.project`, the sole `vaultAuths` key, legacy `vaultAuth.name`, or the generated chart fullname for legacy `vaultAuth`. |
| vaultStaticSecrets.__helm_docs_example__.vaultNamespace | string | `""` | Vault Enterprise namespace used for the secret engine mount. Rendered as `spec.namespace`. |
| vaultStaticSecrets.__helm_docs_example__.vaultType | string | `"kv-v2"` | Secret engine type for VSO. |
| vaultStaticSecrets.__helm_docs_example__.version | int | `1` | Optional secret version. Rendered as `spec.version`. |

## Included Values Files

- [values.yaml](values.yaml): minimal defaults that render no resources.
- [values.yaml.example](values.yaml.example): complete example covering every supported resource type, including multiple resources per map.

## Testing

Representative local commands:

```bash
helm lint . -f values.yaml.example
helm template vault-secret-operator . -f values.yaml.example
helm unittest -f 'tests/units/*_test.yaml' .
sh tests/units/backward_compatibility_test.sh
python3 tests/smokes/run/smoke.py
make test-smoke-fast
```
