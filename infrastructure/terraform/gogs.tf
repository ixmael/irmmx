// Git selfhosted
resource "docker_container" "gogs" {
  name = "${local.project_name}-gogs-${var.environment}"
  image    = "gogs/gogs"
  hostname = "gogs"

  restart = "unless-stopped"

  env = [
    "ENVIRONMENT=${var.environment}",
    "PUID=1000",
    "PGID=1000"
  ]

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.gogs.name
  }

  ports {
    external = 10022
    internal = 22
  }

  ports {
    external = 10880
    internal = 3000
  }
}
