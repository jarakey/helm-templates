{{/*
Common labels used in metadata
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ include "app.chart" . | quote }}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.global.labels }}
{{ toYaml .Values.global.labels | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Full name for resources
*/}}
{{- define "app.fullname" -}}
{{- if .deploymentName }}
{{- printf "%s-%s" (include "app.name" .) .deploymentName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s" (include "app.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Chart name and version as used by the chart label
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Application name
*/}}
{{- define "app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Service account name
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.security.serviceAccount.create }}
{{- default (include "app.fullname" .) .Values.security.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.security.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Legacy helpers for backward compatibility
*/}}
{{- define "selector.labels" -}}
{{ include "app.selectorLabels" . }}
{{- end }}

{{- define "common.labels" -}}
{{ include "app.labels" . }}
{{- end }}

{{- define "common.serviceAccountName" -}}
{{ include "app.serviceAccountName" . }}
{{- end }}

{{- define "chart.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "chart.version" -}}
{{ .Chart.Version }}
{{- end }}

{{/*
Helper to get deployment name with component
*/}}
{{- define "deployment.fullname" -}}
{{- printf "%s-%s" (include "app.fullname" .) .name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Helper to get service name for deployment
*/}}
{{- define "deployment.serviceName" -}}
{{- printf "%s-%s" (include "app.fullname" .) .name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Helper to get ingress name for deployment
*/}}
{{- define "deployment.ingressName" -}}
{{- printf "%s-%s" (include "app.fullname" .) .name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Helper to get HPA name for deployment
*/}}
{{- define "deployment.hpaName" -}}
{{- printf "%s-%s" (include "app.fullname" .) .name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Helper to get PDB name for deployment
*/}}
{{- define "deployment.pdbName" -}}
{{- printf "%s-%s" (include "app.fullname" .) .name | trunc 63 | trimSuffix "-" }}
{{- end }} 