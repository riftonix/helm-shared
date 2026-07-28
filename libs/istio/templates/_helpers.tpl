{{- define "istio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "istio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "istio.labels" -}}
app.kubernetes.io/name: {{ include "istio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "istio.chart" . }}
{{- end -}}

{{- define "istio.tplvalues.render" -}}
{{- if typeIs "string" .value -}}
{{- tpl .value .context -}}
{{- else -}}
{{- tpl (.value | toYaml) .context -}}
{{- end -}}
{{- end -}}

{{- define "istio.tplContext" -}}
{{- $tplContext := deepCopy . -}}
{{- if .Values.global -}}
{{- $_ := set $tplContext "Values" (mergeOverwrite (deepCopy .Values.global) .Values) -}}
{{- end -}}
{{- $tplContext | toYaml -}}
{{- end -}}

{{- define "istio.renderMap" -}}
{{- $value := .value | default dict -}}
{{- $context := .context -}}
{{- if $value -}}
{{- include "istio.tplvalues.render" (dict "value" $value "context" $context) | fromYaml | default dict | toYaml -}}
{{- else -}}
{{- dict | toYaml -}}
{{- end -}}
{{- end -}}

{{- define "istio.commonLabels" -}}
{{- $root := .root -}}
{{- $context := .context -}}
{{- $commonLabels := include "istio.renderMap" (dict "value" ($root.Values.commonLabels | default dict) "context" $context) | fromYaml | default dict -}}
{{- $genericLabels := include "istio.renderMap" (dict "value" ((get ($root.Values.generic | default dict) "labels") | default dict) "context" $context) | fromYaml | default dict -}}
{{- mustMergeOverwrite (dict) $commonLabels $genericLabels | toYaml -}}
{{- end -}}

{{- define "istio.commonAnnotations" -}}
{{- $root := .root -}}
{{- $context := .context -}}
{{- $commonAnnotations := include "istio.renderMap" (dict "value" ($root.Values.commonAnnotations | default dict) "context" $context) | fromYaml | default dict -}}
{{- $genericAnnotations := include "istio.renderMap" (dict "value" ((get ($root.Values.generic | default dict) "annotations") | default dict) "context" $context) | fromYaml | default dict -}}
{{- mustMergeOverwrite (dict) $commonAnnotations $genericAnnotations | toYaml -}}
{{- end -}}

{{- define "istio.resourceSpec" -}}
{{- $root := .root -}}
{{- $item := .item | default dict -}}
{{- $kind := .kind -}}
{{- $context := .context -}}
{{- if hasKey $item "spec" -}}
{{ include "istio.tplvalues.render" (dict "value" $item.spec "context" $context) }}
{{- else if eq $kind "Gateway" -}}
selector:
{{ include "istio.tplvalues.render" (dict "value" $item.selector "context" $context) | nindent 2 }}
servers:
{{ include "istio.tplvalues.render" (dict "value" $item.servers "context" $context) | nindent 2 }}
{{- else if eq $kind "VirtualService" -}}
hosts:
{{ include "istio.tplvalues.render" (dict "value" $item.hosts "context" $context) | nindent 2 }}
gateways:
{{ include "istio.tplvalues.render" (dict "value" $item.gateways "context" $context) | nindent 2 }}
{{- with $item.http }}
http:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
{{- with $item.tls }}
tls:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
{{- with $item.tcp }}
tcp:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
{{- with $item.exportTo }}
exportTo:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
{{- else if eq $kind "DestinationRule" -}}
host: {{ include "istio.tplvalues.render" (dict "value" $item.host "context" $context) | quote }}
{{- with $item.trafficPolicy }}
trafficPolicy:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
{{- with $item.subsets }}
subsets:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
{{- with $item.exportTo }}
exportTo:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
{{- with $item.workloadSelector }}
workloadSelector:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
{{- else if eq $kind "AuthorizationPolicy" -}}
{{- with $item.selector }}
selector:
{{ include "istio.tplvalues.render" (dict "value" . "context" $context) | nindent 2 }}
{{- end }}
action: {{ default "ALLOW" $item.action }}
rules:
{{ include "istio.tplvalues.render" (dict "value" $item.rules "context" $context) | nindent 2 }}
{{- end -}}
{{- end -}}

{{- define "istio.resolveApiVersion" -}}
{{- $root := .root -}}
{{- $key := .key -}}
{{- $legacyKey := .legacyKey -}}
{{- $topLevel := get ($root.Values.apiVersions | default dict) $key -}}
{{- $globalApiVersions := get ($root.Values.global | default dict) "apiVersions" | default dict -}}
{{- $globalValue := get $globalApiVersions $legacyKey -}}
{{- if and $topLevel (ne $topLevel .default) -}}
{{- $topLevel -}}
{{- else if $globalValue -}}
{{- $globalValue -}}
{{- else -}}
{{- default .default $topLevel -}}
{{- end -}}
{{- end -}}

{{- define "istio.renderResource" -}}
{{- $root := .root -}}
{{- $item := .item -}}
{{- $resourceName := .resourceName -}}
{{- $resourceKey := .resourceKey -}}
{{- $tplContext := include "istio.tplContext" $root | fromYaml -}}
{{- $shouldIgnore := eq (get ($item.annotations | default dict) "helm-docs.nuc.internal/ignore") "true" -}}
{{- if not $shouldIgnore -}}
{{- $defaultLabels := include "istio.labels" $root | fromYaml -}}
{{- $commonLabels := include "istio.commonLabels" (dict "root" $root "context" $tplContext) | fromYaml -}}
{{- $itemLabels := include "istio.renderMap" (dict "value" ($item.labels | default dict) "context" $tplContext) | fromYaml | default dict -}}
{{- $labels := mustMergeOverwrite (dict) $defaultLabels $commonLabels $itemLabels -}}
{{- $commonAnnotations := include "istio.commonAnnotations" (dict "root" $root "context" $tplContext) | fromYaml -}}
{{- $itemAnnotations := include "istio.renderMap" (dict "value" ($item.annotations | default dict) "context" $tplContext) | fromYaml | default dict -}}
{{- $annotations := mustMergeOverwrite (dict) $commonAnnotations $itemAnnotations -}}
{{- $nameValue := required (printf "%s key is required" $resourceKey) ($item.name | default $resourceName) -}}
apiVersion: {{ default .defaultApiVersion $item.apiVersion }}
kind: {{ .kind }}
metadata:
  name: {{ include "istio.tplvalues.render" (dict "value" $nameValue "context" $tplContext) }}
  {{- if .namespaced }}
  namespace: {{ default $root.Release.Namespace $item.namespace }}
  {{- end }}
  labels:
{{ toYaml $labels | nindent 4 }}
  {{- if $annotations }}
  annotations:
{{ toYaml $annotations | nindent 4 }}
  {{- end }}
{{- $spec := include "istio.resourceSpec" (dict "root" $root "item" $item "kind" .kind "context" $tplContext) -}}
{{- if $spec }}
spec:
{{ $spec | nindent 2 }}
{{- end }}
{{- with $item.status }}
status:
{{ include "istio.tplvalues.render" (dict "value" . "context" $tplContext) | nindent 2 }}
{{- end }}
{{- end -}}
{{- end -}}

{{- define "istio.renderResources" -}}
{{- $collection := .collection | default dict -}}
{{- $documents := list -}}
{{- range $resourceName := keys $collection | sortAlpha -}}
{{- $item := get $collection $resourceName -}}
{{- if and (ne $resourceName "__helm_docs_example__") (kindIs "map" $item) -}}
{{- $rendered := include "istio.renderResource" (dict
  "root" $.root
  "item" $item
  "resourceName" $resourceName
  "resourceKey" (printf "%s[%q]" $.resourceKey $resourceName)
  "kind" $.kind
  "defaultApiVersion" $.defaultApiVersion
  "namespaced" $.namespaced
) -}}
{{- if $rendered -}}
{{- $documents = append $documents $rendered -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- join "\n---\n" $documents -}}
{{- end -}}

{{/* Compatibility aliases for umbrella helpers. */}}
{{- define "helpers.tplvalues.render" -}}
{{- include "istio.tplvalues.render" . -}}
{{- end -}}

{{- define "helpers.app.fullname" -}}
{{- include "istio.name" .context -}}
{{- end -}}

{{- define "helpers.app.labels" -}}
{{- include "istio.labels" . -}}
{{- end -}}

{{- define "helpers.app.genericAnnotations" -}}
{{- $tplContext := include "istio.tplContext" . | fromYaml -}}
{{- include "istio.commonAnnotations" (dict "root" . "context" $tplContext) -}}
{{- end -}}
