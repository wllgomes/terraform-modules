data "aws_caller_identity" "current" {}

data "azuredevops_project" "this" {
  name = var.project_name
}

data "azuredevops_group" "administrators" {
  project_id = data.azuredevops_project.this.id
  name       = "Project Administrators"
}