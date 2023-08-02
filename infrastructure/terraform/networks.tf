resource "docker_network" "local" {
  name  = "${local.project_name}-local-${var.environment}"
  driver = "bridge"
}
