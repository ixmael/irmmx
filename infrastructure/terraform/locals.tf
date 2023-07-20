locals {
  # Project
  project_name = "irmmx"

  # Syncthing ports
  syncthing = {
    bridge_ports = {
      default  = 22001
      discover = 21028
    }
  }
}
