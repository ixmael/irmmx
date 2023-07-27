resource "docker_network" "services" {
  name  = "${local.project_name}-services-${var.environment}"
  driver = "bridge"
}
