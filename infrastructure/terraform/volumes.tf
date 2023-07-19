resource "docker_volume" "web" {
  name = "${local.project_name}-web-${var.environment}"
  driver_opts = {
    type   = "none"
    device = var.web_content
    o      = "bind"
  }
}

resource "docker_volume" "syncthing" {
  name = "${local.project_name}-syncthing-${var.environment}"
  driver_opts = {
    type   = "none"
    device = var.syncthing_shared_path
    o      = "bind"
  }
}
