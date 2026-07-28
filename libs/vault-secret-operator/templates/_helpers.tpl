{{- define "vault-secret-operator.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "vault-secret-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "vault-secret-operator.fullname" -}}
{{- if .name -}}
{{- if .context.Values.releasePrefix -}}
{{- printf "%s-%s" .context.Values.releasePrefix .name | trunc 63 | trimAll "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "vault-secret-operator.name" .context) .name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- include "vault-secret-operator.name" .context -}}
{{- end -}}
{{- end -}}

{{- define "vault-secret-operator.labels" -}}
app.kubernetes.io/name: {{ include "vault-secret-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "vault-secret-operator.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{- define "vault-secret-operator.hookAnnotations" -}}
helm.sh/hook: pre-install,pre-upgrade
helm.sh/hook-weight: "1"
helm.sh/hook-delete-policy: before-hook-creation
{{- end -}}

{{- define "vault-secret-operator.tplvalues.render" -}}
{{- if typeIs "string" .value -}}
{{- tpl .value .context -}}
{{- else -}}
{{- tpl (.value | toYaml) .context -}}
{{- end -}}
{{- end -}}

{{- define "vault-secret-operator.defaultVaultAuthName" -}}
{{- $vaultAuths := omit (.Values.vaultAuths | default dict) "__helm_docs_example__" -}}
{{- if and .Values.vaultAuth .Values.vaultAuth.name -}}
{{- .Values.vaultAuth.name -}}
{{- else -}}
{{- $globalProject := "" -}}
{{- if and .Values.global (hasKey .Values.global "project") -}}
{{- $globalProject = .Values.global.project -}}
{{- end -}}
{{- if $globalProject -}}
{{- $globalProject -}}
{{- else if .Values.vaultAuth -}}
{{- include "vault-secret-operator.fullname" (dict "context" .) -}}
{{- else if eq (len $vaultAuths) 1 -}}
{{- first (keys $vaultAuths) -}}
{{- else -}}
{{- include "vault-secret-operator.fullname" (dict "context" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "vault-secret-operator.defaultVaultAuthRef" -}}
{{- $vaultAuths := omit (.Values.vaultAuths | default dict) "__helm_docs_example__" -}}
{{- $globalProject := "" -}}
{{- if and .Values.global (hasKey .Values.global "project") -}}
{{- $globalProject = .Values.global.project -}}
{{- end -}}
{{- if $globalProject -}}
{{- $globalProject -}}
{{- else if and .Values.vaultAuth .Values.vaultAuth.name -}}
{{- .Values.vaultAuth.name -}}
{{- else if .Values.vaultAuth -}}
{{- include "vault-secret-operator.fullname" (dict "context" .) -}}
{{- else if eq (len $vaultAuths) 1 -}}
{{- first (keys $vaultAuths) -}}
{{- end -}}
{{- end -}}

{{- define "vault-secret-operator.tplContext" -}}
{{- $tplContext := deepCopy . -}}
{{- if .Values.global -}}
{{- $_ := set $tplContext "Values" (mergeOverwrite (deepCopy .Values.global) .Values) -}}
{{- end -}}
{{- $tplContext | toYaml -}}
{{- end -}}

{{- define "vault-secret-operator.resourceLabels" -}}
{{- $root := .root -}}
{{- $item := .item | default dict -}}
{{- $labels := mustMergeOverwrite (dict) (include "vault-secret-operator.labels" $root | fromYaml) ($root.Values.commonLabels | default dict) ($item.labels | default dict) -}}
{{- toYaml $labels -}}
{{- end -}}

{{- define "vault-secret-operator.resourceAnnotations" -}}
{{- $root := .root -}}
{{- $item := .item | default dict -}}
{{- $annotations := mustMergeOverwrite (dict) (include "vault-secret-operator.hookAnnotations" $root | fromYaml) ($root.Values.commonAnnotations | default dict) ($item.annotations | default dict) -}}
{{- toYaml $annotations -}}
{{- end -}}

{{- define "vault-secret-operator.renderMetadata" -}}
{{- $root := .root -}}
{{- $item := .item | default dict -}}
metadata:
  name: {{ .name }}
  namespace: {{ default $root.Release.Namespace $item.namespace }}
  labels:
{{ include "vault-secret-operator.resourceLabels" (dict "root" $root "item" $item) | nindent 4 }}
  annotations:
{{ include "vault-secret-operator.resourceAnnotations" (dict "root" $root "item" $item) | nindent 4 }}
{{- end -}}

{{- define "vault-secret-operator.renderGenericResource" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- $item := .item | default dict -}}
{{- $tplContext := include "vault-secret-operator.tplContext" $root | fromYaml -}}
---
apiVersion: {{ default .defaultApiVersion $item.apiVersion }}
kind: {{ .kind }}
{{ include "vault-secret-operator.renderMetadata" (dict "root" $root "item" $item "name" $name) }}
{{- with $item.spec }}
spec:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- with $item.status }}
status:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- end -}}

{{- define "vault-secret-operator.renderGenericResources" -}}
{{- $collection := .collection | default dict -}}
{{- range $name := keys $collection | sortAlpha }}
{{- $item := get $collection $name -}}
{{- if and (ne $name "__helm_docs_example__") $item }}
{{ include "vault-secret-operator.renderGenericResource" (dict
  "root" $.root
  "name" $name
  "item" $item
  "kind" $.kind
  "defaultApiVersion" $.defaultApiVersion
) }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "vault-secret-operator.renderVaultAuthSpec" -}}
{{- $root := .root -}}
{{- $item := .item | default dict -}}
{{- $tplContext := .tplContext -}}
{{- if $item.spec -}}
{{ include "vault-secret-operator.tplvalues.render" (dict "value" $item.spec "context" $tplContext) }}
{{- else -}}
{{- $method := $item.method | default "kubernetes" -}}
{{- $kubernetes := mustMergeOverwrite (dict) ($item.kubernetes | default dict) -}}
{{- if and $item.role (not (hasKey $kubernetes "role")) -}}
{{- $_ := set $kubernetes "role" $item.role -}}
{{- end -}}
{{- if and $item.serviceAccount (not (hasKey $kubernetes "serviceAccount")) -}}
{{- $_ := set $kubernetes "serviceAccount" $item.serviceAccount -}}
{{- end -}}
{{- if eq $method "kubernetes" -}}
{{- if not (hasKey $kubernetes "role") -}}
{{- $_ := set $kubernetes "role" (required "values.vaultAuth.role or values.vaultAuth.kubernetes.role is required when vaultAuth is configured" $item.role) -}}
{{- end -}}
{{- if not (hasKey $kubernetes "serviceAccount") -}}
{{- $_ := set $kubernetes "serviceAccount" ($item.serviceAccount | default "default") -}}
{{- end -}}
{{- end -}}
{{- with $item.vaultConnectionRef }}
vaultConnectionRef: {{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) }}
{{- end }}
{{- with $item.vaultAuthGlobalRef }}
vaultAuthGlobalRef:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- with $item.vaultNamespace }}
namespace: {{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) }}
{{- end }}
{{- with $item.allowedNamespaces }}
allowedNamespaces:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
method: {{ include "vault-secret-operator.tplvalues.render" (dict "value" $method "context" $tplContext) }}
{{- if or $item.mount (eq $method "kubernetes") }}
mount: {{ include "vault-secret-operator.tplvalues.render" (dict "value" ($item.mount | default "kubernetes") "context" $tplContext) }}
{{- end }}
{{- with $item.params }}
params:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- with $item.headers }}
headers:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- if eq $method "kubernetes" }}
kubernetes:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" $kubernetes "context" $tplContext) | nindent 2 }}
{{- else if $item.appRole }}
appRole:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" $item.appRole "context" $tplContext) | nindent 2 }}
{{- else if $item.jwt }}
jwt:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" $item.jwt "context" $tplContext) | nindent 2 }}
{{- else if $item.aws }}
aws:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" $item.aws "context" $tplContext) | nindent 2 }}
{{- else if $item.gcp }}
gcp:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" $item.gcp "context" $tplContext) | nindent 2 }}
{{- end }}
{{- with $item.storageEncryption }}
storageEncryption:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- end -}}
{{- end -}}

{{- define "vault-secret-operator.renderVaultStaticSecretSpec" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- $item := .item | default dict -}}
{{- $tplContext := .tplContext -}}
{{- $defaultVaultAuthName := .defaultVaultAuthName -}}
{{- if $item.spec -}}
{{ include "vault-secret-operator.tplvalues.render" (dict "value" $item.spec "context" $tplContext) }}
{{- else -}}
{{- $destinationType := $item.destinationType | default $item.type -}}
{{- $destination := mustMergeOverwrite (dict) ($item.destination | default dict) -}}
{{- if not (hasKey $destination "name") -}}
{{- $_ := set $destination "name" ($item.destSec | default $name) -}}
{{- end -}}
{{- if and (not (hasKey $destination "create")) (not (eq $item.create false)) -}}
{{- $_ := set $destination "create" true -}}
{{- end -}}
{{- if and $destinationType (not (hasKey $destination "type")) -}}
{{- $_ := set $destination "type" $destinationType -}}
{{- end -}}
{{- if and (hasKey $item "overwrite") (not (hasKey $destination "overwrite")) -}}
{{- $_ := set $destination "overwrite" $item.overwrite -}}
{{- end -}}
{{- if and $item.destinationLabels (not (hasKey $destination "labels")) -}}
{{- $_ := set $destination "labels" $item.destinationLabels -}}
{{- end -}}
{{- if and $item.destinationAnnotations (not (hasKey $destination "annotations")) -}}
{{- $_ := set $destination "annotations" $item.destinationAnnotations -}}
{{- end -}}
{{- if and $item.transformation (not (hasKey $destination "transformation")) -}}
{{- $_ := set $destination "transformation" $item.transformation -}}
{{- end -}}
vaultAuthRef: {{ include "vault-secret-operator.tplvalues.render" (dict "value" (required (printf "values.vaultStaticSecrets.%s.vaultAuthRef is required when multiple vaultAuths are configured without global.project or legacy vaultAuth defaults" $name) ($item.vaultAuthRef | default $defaultVaultAuthName)) "context" $tplContext) }}
{{- with $item.vaultNamespace }}
namespace: {{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) }}
{{- end }}
type: {{ include "vault-secret-operator.tplvalues.render" (dict "value" ($item.vaultType | default "kv-v2") "context" $tplContext) }}
mount: {{ include "vault-secret-operator.tplvalues.render" (dict "value" ($item.mount | default "develop") "context" $tplContext) }}
path: {{ include "vault-secret-operator.tplvalues.render" (dict "value" (required (printf "values.vaultStaticSecrets.%s.path is required" $name) $item.path) "context" $tplContext) }}
{{- with $item.version }}
version: {{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) }}
{{- end }}
refreshAfter: {{ include "vault-secret-operator.tplvalues.render" (dict "value" ($item.refreshAfter | default "1m") "context" $tplContext) }}
{{- if hasKey $item "hmacSecretData" }}
hmacSecretData: {{ include "vault-secret-operator.tplvalues.render" (dict "value" $item.hmacSecretData "context" $tplContext) }}
{{- end }}
destination:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" $destination "context" $tplContext) | nindent 2 }}
{{- with $item.syncConfig }}
syncConfig:
{{ include "vault-secret-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- with $item.restartTargets }}
rolloutRestartTargets:
  {{- range . }}
  {{- if kindIs "string" . }}
  - kind: Deployment
    name: {{ . | quote }}
  {{- else }}
  - kind: {{ .kind | default "Deployment" }}
    name: {{ .name | quote }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end -}}
{{- end -}}

{{- define "vault-secret-operator.renderVaultAuth" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- $item := .item | default dict -}}
{{- $tplContext := include "vault-secret-operator.tplContext" $root | fromYaml -}}
---
apiVersion: {{ default $root.Values.apiVersions.vaultAuth $item.apiVersion }}
kind: VaultAuth
{{ include "vault-secret-operator.renderMetadata" (dict "root" $root "item" $item "name" $name) }}
spec:
{{ include "vault-secret-operator.renderVaultAuthSpec" (dict "root" $root "item" $item "tplContext" $tplContext) | nindent 2 }}
{{- end -}}

{{- define "vault-secret-operator.renderVaultStaticSecret" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- $item := .item | default dict -}}
{{- $tplContext := include "vault-secret-operator.tplContext" $root | fromYaml -}}
{{- $defaultVaultAuthName := include "vault-secret-operator.defaultVaultAuthRef" $root -}}
---
apiVersion: {{ default $root.Values.apiVersions.vaultStaticSecret $item.apiVersion }}
kind: VaultStaticSecret
{{ include "vault-secret-operator.renderMetadata" (dict "root" $root "item" $item "name" $name) }}
spec:
{{ include "vault-secret-operator.renderVaultStaticSecretSpec" (dict "root" $root "name" $name "item" $item "tplContext" $tplContext "defaultVaultAuthName" $defaultVaultAuthName) | nindent 2 }}
{{- end -}}
