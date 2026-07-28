{{- define "keda.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "keda.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "keda.labels" -}}
app.kubernetes.io/name: {{ include "keda.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "keda.chart" . }}
{{- end -}}

{{- define "keda.renderResource" -}}
{{- $root := .root -}}
{{- $item := .item -}}
{{- $resourceName := .resourceName -}}
{{- $defaultLabels := include "keda.labels" $root | fromYaml -}}
{{- $labels := mustMergeOverwrite (dict) $defaultLabels ($root.Values.commonLabels | default dict) ($item.labels | default dict) -}}
{{- $annotations := mustMergeOverwrite (dict) ($root.Values.commonAnnotations | default dict) ($item.annotations | default dict) -}}
{{- if ne $resourceName "__helm_docs_example__" }}
apiVersion: {{ default .defaultApiVersion $item.apiVersion }}
kind: {{ .kind }}
metadata:
  name: {{ $resourceName }}
  {{- if .namespaced }}
  namespace: {{ default $root.Release.Namespace $item.namespace }}
  {{- end }}
  labels:
{{ toYaml $labels | nindent 4 }}
  {{- if $annotations }}
  annotations:
{{ toYaml $annotations | nindent 4 }}
  {{- end }}
{{- with $item.spec }}
spec:
{{ toYaml . | nindent 2 }}
{{- end }}
{{- with $item.status }}
status:
{{ toYaml . | nindent 2 }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "keda.renderResources" -}}
{{- $collection := .collection | default dict -}}
{{- $documents := list -}}
{{- range $resourceName := keys $collection | sortAlpha -}}
{{- $item := get $collection $resourceName -}}
{{- if kindIs "map" $item -}}
{{- $rendered := include "keda.renderResource" (dict
  "root" $.root
  "item" $item
  "resourceName" $resourceName
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
