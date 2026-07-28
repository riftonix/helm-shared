{{- define "kserve.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kserve.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kserve.labels" -}}
app.kubernetes.io/name: {{ include "kserve.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "kserve.chart" . }}
{{- end -}}

{{- define "kserve.renderResource" -}}
{{- $root := .root -}}
{{- $item := .item -}}
{{- $resourceKey := .resourceKey -}}
{{- $resourceName := .resourceName -}}
{{- $defaultLabels := include "kserve.labels" $root | fromYaml -}}
{{- $labels := mustMergeOverwrite (dict) $defaultLabels ($root.Values.commonLabels | default dict) ($item.labels | default dict) -}}
{{- $annotations := mustMergeOverwrite (dict) ($root.Values.commonAnnotations | default dict) ($item.annotations | default dict) -}}
apiVersion: {{ default .defaultApiVersion $item.apiVersion }}
kind: {{ .kind }}
metadata:
  name: {{ required (printf "%s key must not be empty" $resourceKey) $resourceName }}
  {{- if .namespaced }}
  namespace: {{ default $root.Release.Namespace $item.namespace }}
  {{- end }}
  labels:
{{- toYaml $labels | nindent 4 }}
  {{- if $annotations }}
  annotations:
{{- toYaml $annotations | nindent 4 }}
  {{- end }}
{{- with $item.spec }}
spec:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with $item.status }}
status:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}

{{- define "kserve.renderResourceCollection" -}}
{{- $root := .root -}}
{{- $items := .items | default dict -}}
{{- $resourceKey := .resourceKey -}}
{{- $defaultApiVersion := .defaultApiVersion -}}
{{- $kind := .kind -}}
{{- $namespaced := .namespaced -}}
{{- $documents := list -}}
{{- range $resourceName, $item := $items -}}
{{- if and (kindIs "map" $item) (or (not (hasKey $item "enabled")) $item.enabled) -}}
{{- $documents = append $documents (include "kserve.renderResource" (dict "root" $root "item" $item "resourceKey" (printf "%s[%q]" $resourceKey $resourceName) "resourceName" $resourceName "defaultApiVersion" $defaultApiVersion "kind" $kind "namespaced" $namespaced)) -}}
{{- end -}}
{{- end -}}
{{- join "\n---\n" $documents -}}
{{- end -}}
