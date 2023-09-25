resource "docker_container" "syncthing" {
  name     = "${local.project_name}-syncthing-${var.environment}"
  image    = "syncthing/syncthing:1.23"
  hostname = "syncthing"

  restart = "unless-stopped"

  env = [
    "ENVIRONMENT=${var.environment}",
    "PUID=1000",
    "PGID=1000"
  ]

  volumes {
    container_path = "/var/syncthing"
    volume_name    = docker_volume.syncthing.name
  }

  ports {
    internal = 8384
    external = 8385
  }

  ports {
    internal = 22000
    external = 22001
  }

  ports {
    protocol = "udp"
    internal = 22000
    external = 22001
  }

  ports {
    protocol = "udp"
    internal = 21027
    external = 21028
  }

  networks_advanced {
    name = docker_network.local.name
    aliases = [
      "syncthing"
    ]
  }
}
