variable "environment" {
  type        = string
  description = "The environment"
  default     = "production"
}

variable "host" {
  type        = string
  description = "The host"
}

variable "dashboardBasicAuth" {
  type        = string
  description = "The user and hashed password for the dashboard"
}

variable "debugLevel" {
  type        = string
  description = "The debug level for the reverse proxy"
}
