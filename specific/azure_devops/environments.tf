resource "azuredevops_environment" "this" {
  project_id = data.azuredevops_project.this.id
  name       = var.enterprise_context.environment
}

resource "azuredevops_check_branch_control" "this" {
  count                    = var.enterprise_context.environment == "prd" ? 1 : 0
  project_id               = data.azuredevops_project.this.id
  display_name             = "Managed by Terraform"
  target_resource_id       = azuredevops_environment.this.id
  target_resource_type     = "environment"
  verify_branch_protection = true
  allowed_branches         = "refs/heads/master,refs/heads/main"
}


resource "azuredevops_check_approval" "this" {
  count = var.enterprise_context.environment == "prd" ? 1 : 0

  project_id           = data.azuredevops_project.this.id
  target_resource_id   = azuredevops_environment.this.id
  target_resource_type = "environment"

  minimum_required_approvers = 1

  requester_can_approve = true
  approvers = [
    data.azuredevops_group.administrators.origin_id,
  ]
}
