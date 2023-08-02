resource "docker_volume" "syncthing" {
  name = "${local.project_name}-syncthing-${var.environment}"
  driver_opts = {
    type   = "none"
    device = var.syncthing_data
    o      = "bind"
  }
}
