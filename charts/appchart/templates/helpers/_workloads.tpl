{{- define "helpers.workloads.envs" -}}
{{- $ctx := .context -}}
{{- $root := .root -}}
{{- $general := .general -}}
{{- $v := .value -}}
{{- if or (or (or $v.envsFromConfigmap $v.envsFromSecret) $v.env) (or (or $general.envsFromConfigmap $general.envsFromSecret) $general.env) (or (not (empty $v.containerEnvs)) (not (empty $general.containerEnvs)) (not (empty $root.containerEnvs)) (not ($root.envsFromSecret)))}}
env:
{{ with $general.envsFromConfigmap }}{{- include "helpers.configmaps.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $v.envsFromConfigmap }}{{- include "helpers.configmaps.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $root.envsFromSecret }}{{- include "helpers.secrets.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $general.envsFromSecret }}{{- include "helpers.secrets.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $v.envsFromSecret }}{{- include "helpers.secrets.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $general.env }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $v.env }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- if or (not (empty $v.containerEnvs)) (not (empty $general.containerEnvs)) (not (empty $root.containerEnvs)) }}
{{- $mergedEnvs := merge (default dict $v.containerEnvs) (default dict $general.containerEnvs) (default dict $root.containerEnvs) }}
{{- range $key, $value := $mergedEnvs }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "helpers.workloads.envsFrom" -}}
{{- $ctx := .context -}}
{{- $general := .general -}}
{{- $v := .value -}}
{{- if or (or (or $v.envConfigmaps $v.envSecrets) $v.envFrom) (or (or $general.envConfigmaps $general.envSecrets) $general.envFrom)}}
envFrom:
{{ with $general.envConfigmaps }}{{- include "helpers.configmaps.includeEnvConfigmap" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $v.envConfigmaps }}{{- include "helpers.configmaps.includeEnvConfigmap" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $general.envSecrets }}{{- include "helpers.secrets.includeEnvSecret" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $v.envSecrets }}{{- include "helpers.secrets.includeEnvSecret" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $general.envFrom }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $v.envFrom }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- end }}
{{- end }}

{{- define "helpers.workload.checksum" -}}
{{ . | toString | sha256sum }}
{{- end -}}