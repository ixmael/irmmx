variable "environment" {
  type        = string
  description = "The environment"
  default     = "production"
}

variable "host" {
  type        = string
  description = "The host"
}

variable "email" {
  type = string
  description = "The letsencrypt email"
}

variable "web_content" {
  type        = string
  description = "The web content"
}

variable "web_config" {
  type = string
  description = "The web config"
}

variable "web_cert_file" {
  type = string
  description = "The cert file"
}

variable "web_cert_key_file" {
  type = string
  description = "The cert key file"
}

variable "certs_config_path" {
  type = string
  description = "The certs configuration file"
}

variable "certs_path" {
  type = string
  description = "The certs file"
}

variable "traefik_config_file" {
  type        = string
  description = "The configuration file for traefik"
}

variable "syncthing_shared_path" {
  type        = string
  description = "The syncthing to store de shared data"
}

variable "syncthing_config" {
  type = string
  description = "The path to the syncthing configuration"
}
