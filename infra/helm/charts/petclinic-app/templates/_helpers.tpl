{{/*
Expand the name of the chart.
*/}}
{{- define "petclinic-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "petclinic-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "petclinic-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "petclinic-app.labels" -}}
helm.sh/chart: {{ include "petclinic-app.chart" . }}
{{ include "petclinic-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "petclinic-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "petclinic-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "petclinic-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "petclinic-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database connection URL
*/}}
{{- define "petclinic-app.databaseUrl" -}}
{{- if .Values.database.external.enabled }}
{{- printf "jdbc:postgresql://%s:%d/%s" .Values.database.external.host (.Values.database.external.port | int) .Values.database.external.database }}
{{- else }}
{{- printf "jdbc:postgresql://%s-postgresql:%d/%s" .Release.Name (.Values.database.port | int) .Values.database.name }}
{{- end }}
{{- end }} 