resource "docker_container" "reverseproxy" {
  name  = "${local.project_name}-reverseproxy-${var.environment}"
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

  // Port for syncthing
  ports {
    protocol = "tcp"
    internal = local.syncthing.bridge_ports.default
    external = 22000
  }

  // Port for syncthing
  ports {
    protocol = "udp"
    internal = local.syncthing.bridge_ports.default
    external = 22000
  }

  // Port for syncthing
  ports {
    protocol = "udp"
    internal = local.syncthing.bridge_ports.discover
    external = 21027
  }

  networks_advanced {
    name = "bridge"
  }

  networks_advanced {
    name = docker_network.local.name
    aliases = [
      "reverseproxy"
    ]
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

  labels {
    label = "traefik.http.routers.reverseproxy.entrypoints"
    value = "default,syncthingTCP,syncthingQUIC,syncthingDiscover"
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

  networks_advanced {
    name = docker_network.local.name
    aliases = [
      "web"
    ]
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
    label = "traefik.http.routers.web.rule"
    value = "Host(`${var.host}`)"
  }

  labels {
    label = "traefik.docker.network"
    value = docker_network.local.name
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
    internal = 22000
    external = local.syncthing.bridge_ports.default
  }

  ports {
    protocol = "udp"
    internal = 22000
    external = local.syncthing.bridge_ports.default
  }

  ports {
    protocol = "udp"
    internal = 21027
    external = local.syncthing.bridge_ports.discover
  }

  networks_advanced {
    name = docker_network.local.name
    aliases = [
      "syncthing"
    ]
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
    label = "traefik.docker.network"
    value = docker_network.local.name
  }
}
