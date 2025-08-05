{{- define "selector.labels" -}}
app.kubernetes.io/name: {{ include "chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Legacy helper to maintain compatibility (can be deprecated later)
*/}}
{{- define "application.selectorLabels" -}}
{{ include "selector.labels" . }}
{{- end }}

{{/*
Common labels used in metadata
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "chart.name" . | quote }}
app.kubernetes.io/name: {{ include "chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Values.global.labels }}
{{- range $key, $value := .Values.global.labels }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}

{{- define "common.serviceAccountName" -}}
{{- if .Values.serviceAccount | kindIs "slice" }}
  {{- if (index .Values.serviceAccount 0).name }}
    {{- (index .Values.serviceAccount 0).name -}}
  {{- else }}
    {{- .Release.Name -}}
  {{- end }}
{{- else if .Values.serviceAccount | kindIs "map" }}
  {{- coalesce .Values.serviceAccount.name .Release.Name -}}
{{- else if .Values.security.serviceAccount | kindIs "slice" }}
  {{- if (index .Values.security.serviceAccount 0).name }}
    {{- (index .Values.security.serviceAccount 0).name -}}
  {{- else }}
    {{- .Release.Name -}}
  {{- end }}
{{- else if .Values.security.serviceAccount | kindIs "map" }}
  {{- coalesce .Values.security.serviceAccount.name .Release.Name -}}
{{- else }}
  {{- .Release.Name -}}
{{- end }}
{{- end }}

{{- define "chart.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "chart.version" -}}
{{ .Chart.Version }}
{{- end }}
