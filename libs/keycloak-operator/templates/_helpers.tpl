{{- define "keycloak-operator.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "keycloak-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "keycloak-operator.fullname" -}}
{{- if .name -}}
{{- if .context.Values.releasePrefix -}}
{{- printf "%s-%s" .context.Values.releasePrefix .name | trunc 63 | trimAll "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "keycloak-operator.name" .context) .name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- include "keycloak-operator.name" .context -}}
{{- end -}}
{{- end -}}

{{- define "keycloak-operator.labels" -}}
app.kubernetes.io/name: {{ include "keycloak-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "keycloak-operator.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{- define "keycloak-operator.hookAnnotations" -}}
helm.sh/hook: pre-install,pre-upgrade
helm.sh/hook-weight: "1"
helm.sh/hook-delete-policy: before-hook-creation
{{- end -}}

{{- define "keycloak-operator.tplvalues.render" -}}
{{- if typeIs "string" .value -}}
{{- tpl .value .context -}}
{{- else -}}
{{- tpl (.value | toYaml) .context -}}
{{- end -}}
{{- end -}}

{{- define "keycloak-operator.tplContext" -}}
{{- $tplContext := deepCopy . -}}
{{- if .Values.global -}}
{{- $_ := set $tplContext "Values" (mergeOverwrite (deepCopy .Values.global) .Values) -}}
{{- end -}}
{{- $tplContext | toYaml -}}
{{- end -}}

{{- define "keycloak-operator.resourceLabels" -}}
{{- $root := .root -}}
{{- $item := .item | default dict -}}
{{- $labels := mustMergeOverwrite (dict) (include "keycloak-operator.labels" $root | fromYaml) ($root.Values.commonLabels | default dict) ($item.labels | default dict) -}}
{{- toYaml $labels -}}
{{- end -}}

{{- define "keycloak-operator.resourceAnnotations" -}}
{{- $root := .root -}}
{{- $item := .item | default dict -}}
{{- $annotations := mustMergeOverwrite (dict) ($root.Values.commonAnnotations | default dict) ($item.annotations | default dict) -}}
{{- toYaml $annotations -}}
{{- end -}}

{{- define "keycloak-operator.renderMetadata" -}}
{{- $root := .root -}}
{{- $item := .item | default dict -}}
metadata:
  name: {{ .name }}
  namespace: {{ default $root.Release.Namespace $item.namespace }}
  labels:
{{ include "keycloak-operator.resourceLabels" (dict "root" $root "item" $item) | nindent 4 }}
  annotations:
{{ include "keycloak-operator.resourceAnnotations" (dict "root" $root "item" $item) | nindent 4 }}
{{- end -}}

{{- define "keycloak-operator.renderGenericResource" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- $item := .item | default dict -}}
{{- $tplContext := include "keycloak-operator.tplContext" $root | fromYaml -}}
---
apiVersion: {{ default .defaultApiVersion $item.apiVersion }}
kind: {{ .kind }}
{{ include "keycloak-operator.renderMetadata" (dict "root" $root "item" $item "name" $name) }}
{{- with $item.spec }}
spec:
{{ include "keycloak-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- with $item.status }}
status:
{{ include "keycloak-operator.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- end -}}

{{- define "keycloak-operator.renderGenericResources" -}}
{{- if .root.Values.enabled }}
{{- $collection := .collection | default dict -}}
{{- range $name := keys $collection | sortAlpha }}
{{- $item := get $collection $name -}}
{{- if and (ne $name "__helm_docs_example__") $item }}
{{ include "keycloak-operator.renderGenericResource" (dict
  "root" $.root
  "name" $name
  "item" $item
  "kind" $.kind
  "defaultApiVersion" $.defaultApiVersion
) }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
