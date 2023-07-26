resource "docker_container" "reverseproxy" {
  name  = "${local.project_name}-reverseproxy-${var.environment}"
  image = "traefik:v2.10"

  env = [
    "ENVIRONMENT=${var.environment}",
  ]

  command = [
    "--api.insecure=false",

    "--log.level=${var.traefikDebugLevel}",
    "--log.filePath=/var/log/traefik/traefik.log",
    "--accessLog.filePath=/var/log/traefik/access.log",


    // Allow to use https within internal services
    "--serversTransport.insecureSkipVerify=true",

    // EntryPoints
    "--entrypoints.web.address=:80",
    "--entrypoints.webSecure.address=:443",

    // Redirect to https from http
    "--entrypoints.web.http.redirections.entryPoint.to=webSecure",
    "--entrypoints.web.http.redirections.entryPoint.scheme=https",

    // Providers
    "--providers.docker",
    "--providers.docker.exposedbydefault=false",
    "--providers.docker.endpoint=unix:///var/run/docker.sock",
    "--providers.docker.swarmMode=false",
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
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    type      = "bind"
    read_only = true
  }

  volumes {
    volume_name    = docker_volume.reverseproxy_logs.name
    container_path = "/var/log/traefik"
  }

  labels {
    label = "traefik.enable"
    value = true
  }

  labels {
    label = "traefik.http.routers.dashboard.rule"
    value = "Host(`dashboard.${var.host}`)"
  }

  labels {
    label = "traefik.http.routers.dashboard.service"
    value = "api@internal"
  }

  labels {
    label = "traefik.http.routers.dashboard.service"
    value = "api@internal"
  }

  labels {
    label = "traefik.http.routers.dashboard.entrypoints"
    value = "webSecure"
  }

  labels {
    label = "traefik.http.routers.dashboard.tls"
    value = true
  }

  labels {
    label = "traefik.http.routers.dashboard.middlewares"
    value = "dashboardAuth"
  }

  labels {
    label = "traefik.http.middlewares.dashboardAuth.basicauth.users"
    value = "${var.traefikDashboardBasicAuth}"
  }
}
