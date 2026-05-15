data "azuredevops_agent_pool" "vertical" {
  name = local.account_name
}

resource "azuredevops_agent_queue" "vertical" {
  count         = var.create_cicd_agent_pool ? 1 : 0
  project_id    = data.azuredevops_project.this.id
  agent_pool_id = data.azuredevops_agent_pool.vertical.id
}

data "azuredevops_agent_pool" "on_premise" {
  name = "on-premise"
}

resource "azuredevops_agent_queue" "on_premise" {
  count         = coalesce(var.branch_independent_variables.network, false) ? 1 : 0
  project_id    = data.azuredevops_project.this.id
  agent_pool_id = data.azuredevops_agent_pool.on_premise.id
}


data "azuredevops_agent_pool" "network" {
  name = "ENA-Network"
}

resource "azuredevops_agent_queue" "network" {
  count         = coalesce(var.branch_independent_variables.network, false) ? 1 : 0
  project_id    = data.azuredevops_project.this.id
  agent_pool_id = data.azuredevops_agent_pool.network.id
}

