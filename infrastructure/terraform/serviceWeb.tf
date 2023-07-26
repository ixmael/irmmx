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
    source    = "${path.cwd}/infrastructure/docker/web/default.conf"
    type      = "bind"
    read_only = true
  }

  volumes {
    volume_name    = docker_volume.web_logs.name
    container_path = "/var/log/web"
  }

  volumes {
    volume_name    = docker_volume.web_certs.name
    container_path = "/etc/ssl/certs"
  }

  volumes {
    volume_name    = docker_volume.web_content.name
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
    value = "webSecure"
  }
}
