resource "docker_container" "reverseproxy" {
  name  = "${local.project_name}-reverseproxy-${var.environment}"
  image = "traefik:v2.10"

  hostname = "reverseproxy"

  env = [
    "ENVIRONMENT=${var.environment}",
  ]

  command = [
    // Traefik
    var.environment != "production" ? "--api.insecure=true" : "--api.insecure=false",
    "--log.level=DEBUG",
    "--log.filePath=/var/log/traefik/traefik.log",
    "--accessLog.filePath=/var/log/traefik/access.log",

    //
    "--serversTransport.insecureSkipVerify=true",

    //
    "--certificatesResolvers.letsencrypt.acme.email=${var.email}",
    "--certificatesResolvers.letsencrypt.acme.storage=/letsencrypt/acme.json",
    "--certificatesresolvers.letsencrypt.acme.tlsChallenge=true",
    "--certificatesResolvers.letsencrypt.acme.caServer=https://acme-staging-v02.api.letsencrypt.org/directory",

    // Entrypoints
    "--entrypoints.http.address=:80",
    "--entrypoints.httpSecure.address=:443",

    // Syncthing
    // "--entrypoints.syncthing.address=:8485",
    // "--entrypoints.syncthingSync.address=:22000",
    // "--entrypoints.syncthingSyncUDP.address=:22000/udp",
    // "--entrypoints.syncthingBroadcastUDP.address=:21027/udp",

    // Redirect to https
    "--entrypoints.http.http.redirections.entrypoint.to=httpSecure",
    "--entrypoints.http.http.redirections.entrypoint.scheme=https",
    "--entrypoints.http.http.redirections.entrypoint.permanent=true",

    // Docker
    "--providers.docker",
    "--providers.docker.exposedbydefault=false",
    "--providers.docker.endpoint=unix:///var/run/docker.sock",
    "--providers.docker.swarmMode=false",
  ]

  ports {
    external = 80
    internal = 80
  }

  ports {
    external = 443
    internal = 443
  }

  dynamic "ports" {
    for_each = var.environment == "production" ? {} : { vault_disabled = true }

    content {
      external = 8080
      internal = 8080
    }
  }

  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    type      = "bind"
    read_only = true
  }
  labels {
    label = "traefik.enable"
    value = var.environment != "production" ? true : false
  }

  labels {
    label = "traefik.http.routers.reverseproxy.entrypoints"
    value = "http,httpSecure"
  }
}

resource "docker_container" "web" {
  name  = "${local.project_name}-web-${var.environment}"
  image = "nginx:1.25.1-alpine"

  hostname = "web"

  env = [
    "ENVIRONMENT=${var.environment}",
  ]

  ports {
    external = 444
    internal = 443
  }

  mounts {
    target    = "/etc/nginx/conf.d/default.conf"
    source    = var.web_config
    type      = "bind"
    read_only = true
  }

  mounts {
    target    = "/etc/ssl/certs/cert.pem"
    source    = var.web_cert_file
    type      = "bind"
    read_only = true
  }

  mounts {
    target    = "/etc/ssl/certs/cert.key.pem"
    source    = var.web_cert_key_file
    type      = "bind"
    read_only = true
  }

  volumes {
    volume_name    = docker_volume.web.name
    container_path = "/web"
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
    label = "traefik.http.routers.web.tls"
    value = true
  }

  labels {
    label = "traefik.http.services.web.loadbalancer.server.port"
    value = "443"
  }

  labels {
    label = "traefik.http.services.web.loadbalancer.server.scheme"
    value = "https"
  }

  labels {
    label = "traefik.http.routers.web.entrypoints"
    value = "httpSecure"
  }
}

/*
resource "docker_container" "syncthing" {
  name  = "${local.project_name}-syncthing-${var.environment}"
  image = "syncthing/syncthing:1.23"

  hostname = "syncthing"

  env = [
    "ENVIRONMENT=${var.environment}",
    "PUID=1000",
    "PGID=1000"
  ]

  volumes {
    volume_name    = docker_volume.syncthing.name
    container_path = "/var/syncthing"
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

  labels {
    label = "traefik.enable"
    value = true
  }

  labels {
    label = "traefik.http.routers.syncthing.rule"
    value = "Host(`syncthing.${var.host}`)"
  }

  labels {
    label = "traefik.http.routers.syncthing.tls"
    value = true
  }

  labels {
    label = "traefik.http.services.syncthing.loadbalancer.server.port"
    value = "8384"
  }

  labels {
    label = "traefik.http.services.syncthing.loadbalancer.server.scheme"
    value = "https"
  }

  labels {
    label = "traefik.http.routers.syncthing.entrypoints"
    value = "httpSecure,syncthing"
  }
}
*/
