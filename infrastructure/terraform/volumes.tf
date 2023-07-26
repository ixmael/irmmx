resource "docker_volume" "reverseproxy_logs" {
  name = "${local.project_name}-reverseproxyLogs-${var.environment}"
  driver_opts = {
    type   = "none"
    device = "${path.cwd}/logs/reverseproxy"
    o      = "bind"
  }
}

resource "docker_volume" "web_logs" {
  name = "${local.project_name}-webLogs-${var.environment}"
  driver_opts = {
    type   = "none"
    device = "${path.cwd}/logs/web"
    o      = "bind"
  }
}

resource "docker_volume" "web_certs" {
  name = "${local.project_name}-webCerts-${var.environment}"
  driver_opts = {
    type   = "none"
    device = "${var.webCertsPath}"
    o      = "bind"
  }
}

resource "docker_volume" "web_content" {
  name = "${local.project_name}-webContent-${var.environment}"
  driver_opts = {
    type   = "none"
    device = "${var.webContentPath}"
    o      = "bind"
  }
}
