resource "azuredevops_serviceendpoint_sonarqube" "this" {
  count = var.branch_independent_variables.sonarqube_token == null ? 0 : 1

  project_id            = data.azuredevops_project.this.id
  service_endpoint_name = "Sonarqube"
  url                   = "https://sonarqube.enacloud.me/"
  token                 = var.branch_independent_variables.sonarqube_token
  description           = "Managed by Terraform"
}