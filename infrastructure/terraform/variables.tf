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

variable "vikunja_database" {
  type = string
  description = "The database path"
}

variable "vikunja_files" {
  type = string
  description = "The files path"
}

variable "vikunja_secret" {
  type = string
  description = "The secret to generate JWT token"
}
