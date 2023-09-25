// Tasks selfhosted
resource "docker_container" "vikunja_frontend" {
  name = "${local.project_name}-vikunja-frontend-${var.environment}"
  image    = "vikunja/frontend"
  hostname = "vikunjafrontend"

  restart = "unless-stopped"

  env = [
    "ENVIRONMENT=${var.environment}",
    "PUID=1000",
    "PGID=1000",
    "VIKUNJA_API_URL=http://tasks.irm.mx/api/v1",
  ]

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.gogs.name
  }

  ports {
    external = 3100
    internal = 80
  }
}

// Tasks selfhosted
resource "docker_container" "vikunja_api" {
  name = "${local.project_name}-vikunja-api-${var.environment}"
  image    = "vikunja/api"
  hostname = "vikunja"

  restart = "unless-stopped"

  env = [
    "ENVIRONMENT=${var.environment}",
    "PUID=1000",
    "PGID=1000",
    "VIKUNJA_SERVICE_JWTSECRET=${var.vikunja_secret}",
    "VIKUNJA_SERVICE_FRONTENDURL=https://tasks.irm.mx",
    "VIKUNJA_DATABASE_PATH: /data/vikunja.db",
  ]

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.vikunja.name
  }

  volumes {
    container_path = "/app/vikunja/files"
    volume_name    = docker_volume.vikunja_files.name
  }

  ports {
    external = 3456
    internal = 3456
  }
}
