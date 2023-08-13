variable "environment" {
  type        = string
  description = "The environment"
  default     = "production"
}

variable "syncthing_data" {
  type = string
  description = "The data path to share"
}

variable "gogs_data" {
  type = string
  description = "The data path to keep repositories"
}
