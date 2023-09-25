resource "docker_volume" "syncthing" {
  name = "${local.project_name}-syncthing-${var.environment}"
  driver_opts = {
    type   = "none"
    device = var.syncthing_data
    o      = "bind"
  }
}

resource "docker_volume" "gogs" {
  name = "gogs"
  driver_opts = {
    type   = "none"
    device = var.gogs_data
    o      = "bind"
  }
}

resource "docker_volume" "vikunja" {
  name = "vikunja"
  driver_opts = {
    type   = "none"
    device = var.vikunja_database
    o      = "bind"
  }
}

resource "docker_volume" "vikunja_files" {
  name = "vikunja_files"
  driver_opts = {
    type   = "none"
    device = var.vikunja_files
    o      = "bind"
  }
}
