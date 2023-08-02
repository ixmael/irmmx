resource "docker_container" "syncthing" {
  name     = "${local.project_name}-syncthing-${var.environment}"
  image    = "syncthing/syncthing:1.23"
  hostname = "syncthing"

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
    external = 8384
  }

  ports {
    internal = 22000
    external = 22000
  }

  ports {
    protocol = "udp"
    internal = 22000
    external = 22000
  }

  ports {
    protocol = "udp"
    internal = 21027
    external = 21027
  }

  networks_advanced {
    name = docker_network.local.name
    aliases = [
      "syncthing"
    ]
  }
}
