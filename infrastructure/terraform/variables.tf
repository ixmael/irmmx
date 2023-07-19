variable "environment" {
  type        = string
  description = "The environment"
  default     = "production"
}

variable "host" {
  type        = string
  description = "The host"
}

variable "web_content" {
  type        = string
  description = "The web content"
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
