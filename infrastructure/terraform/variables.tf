variable "environment" {
  type        = string
  description = "The environment"
  default     = "production"
}

variable "host" {
  type        = string
  description = "The host"
}

variable "traefikDebugLevel" {
  type        = string
  description = "The debug level for the reverse proxy"
}

variable "traefikDashboardBasicAuth" {
  type        = string
  description = "The user and hashed password for the dashboard"
}

variable "webCertsPath" {
  type = string
  description = "The path to the web certs"
}

variable "webContentPath" {
  type        = string
  description = "The path to the web content"
}
