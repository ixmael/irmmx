resource "docker_container" "traefik" {
  name  = "${local.project_name}-traefik-${var.environment}"
  image = "traefik:v2.10"

  env = [
    "ENVIRONMENT=${var.environment}",
  ]

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  mounts {
    target    = "/etc/traefik/traefik.toml"
    source    = var.traefik_config_file
    type      = "bind"
    read_only = true
  }

  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    type      = "bind"
    read_only = true
  }
}

resource "docker_container" "web" {
  name  = "${local.project_name}-web-${var.environment}"
  image = "nginx:1.25.1-alpine"

  env = [
    "ENVIRONMENT=${var.environment}",
  ]


  volumes {
    volume_name    = docker_volume.web.name
    container_path = "/usr/share/nginx/html"
  }

  ports {
    internal = 80
    external = 3000
  }

  labels {
    label = "traefik.enable"
    value = true
  }

  labels {
    label = "traefik.http.routers.static.rule"
    value = "Host(`${var.host}`)"
  }

  labels {
    label = "traefik.http.routers.static.entrypoints"
    value = "web"
  }
}

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
    protocol = "udp"
    internal = 22000
    external = 22000
  }

  ports {
    protocol = "udp"
    internal = 21027
    external = 21027
  }

  labels {
    label = "traefik.enable"
    value = true
  }

  labels {
    label = "traefik.http.routers.syncthing.rule"
    value = "Host(`syncthing.${var.host}`)"
  }

  labels {
    label = "traefik.http.routers.syncthing.entrypoints"
    value = "web"
  }

  labels {
    label = "traefik.http.routers.syncthing.entrypoints"
    value = "syncthing"
  }

  labels {
    label = "traefik.http.routers.syncthing.entrypoints"
    value = "syncthing2"
  }
}
