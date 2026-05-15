resource "azuredevops_variable_group" "aws_account_info" {
  project_id   = data.azuredevops_project.this.id
  name         = "aws-${var.enterprise_context.vertical_initials}-${var.enterprise_context.environment}-account"
  description  = "Data abount AWS Account ${local.account_name} (${data.aws_caller_identity.current.account_id})"
  allow_access = true

  variable {
    name  = "AWS_ACCOUNT_ID"
    value = data.aws_caller_identity.current.account_id
  }

  variable {
    name         = "KMS_KEY_ID"
    secret_value = var.state_bucket_kms_key_id
    is_secret    = true
  }

  variable {
    name  = "PROJECT_POOL_NAME"
    value = local.account_name
  }

  variable {
    name  = "PROJECT_TF_STATE_BUCKET_NAME"
    value = var.state_bucket_name
  }

  variable {
    name  = "PROJECT_TF_STATE_BUCKET_REGION"
    value = var.aws_region
  }

  variable {
    name  = "VERTICAL"
    value = var.enterprise_context.vertical
  }

  variable {
    name  = "VERTICAL_INITIALS"
    value = var.enterprise_context.vertical_initials
  }
}

resource "azuredevops_variable_group" "azure_artefacts_authentication" {
  count = var.branch_independent_variables.azure_artefacts_pat == null ? 0 : 1

  project_id   = data.azuredevops_project.this.id
  name         = "azure-artefacts-authentication"
  description  = "PAT to azure artefacts"
  allow_access = true

  variable {
    name         = "AZURE_PASSWORD"
    secret_value = var.branch_independent_variables.azure_artefacts_pat
    is_secret    = true
  }

  variable {
    name         = "BASE64_AZURE_PASSWORD"
    secret_value = base64encode(var.branch_independent_variables.azure_artefacts_pat)
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "sonarqube_access" {
  count = var.branch_independent_variables.sonarqube_token == null ? 0 : 1

  project_id   = data.azuredevops_project.this.id
  name         = "sonarqube-access"
  description  = "SonarQube Token"
  allow_access = true

  variable {
    name         = "Token Analysis 1"
    secret_value = var.branch_independent_variables.sonarqube_token
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "semantic_access" {
  count = var.branch_independent_variables.token_semantic_release == null ? 0 : 1

  project_id   = data.azuredevops_project.this.id
  name         = "semantic-access"
  description  = "Commitizen - Semantic Release"
  allow_access = false

  variable {
    name         = "TokenSemanticRelease"
    secret_value = var.branch_independent_variables.token_semantic_release
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "ena-network-account" {
  count = coalesce(var.branch_independent_variables.network, false) ? 1 : 0

  project_id   = data.azuredevops_project.this.id
  name         = "aws-ena-network-account"
  description  = "Data abount AWS Account ENA-Network"
  allow_access = true

  variable {
    name  = "NETWORK_POOL_NAME"
    value = "ENA-Network"
  }
  variable {
    name  = "NETWORK_TF_STATE_BUCKET_NAME"
    value = "enanet-s3-prd-tf"
  }
  variable {
    name  = "NETWORK_TF_STATE_BUCKET_REGION"
    value = "us-east-1"
  }
}

resource "azuredevops_variable_group" "azure_access_old" {
  count = (var.branch_independent_variables.azure_artefacts_pat != null) && (var.branch_independent_variables.create_old_azure_access) ? 1 : 0

  project_id   = data.azuredevops_project.this.id
  name         = "azure-access"
  description  = "Azure Token for old pipeline"
  allow_access = true

  variable {
    name  = "azureUser"
    value = "enacom"
  }

  variable {
    name         = "azurePassword"
    secret_value = var.branch_independent_variables.azure_artefacts_pat
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "enacom_old_account_access" {
  count = var.branch_independent_variables.old_account_access == null ? 0 : 1

  project_id   = data.azuredevops_project.this.id
  name         = "aws-enacom-account"
  description  = "old ENACOM account (337842449453) access"
  allow_access = true

  variable {
    name  = "AWS_ACCESS_KEY_ID"
    value = var.branch_independent_variables.old_account_access.id
  }

  variable {
    name         = "AWS_SECRET_ACCESS_KEY"
    secret_value = var.branch_independent_variables.old_account_access.secret_id
    is_secret    = true
  }

  variable {
    name  = "AWS_ACCOUNT_ID"
    value = "337842449453"
  }

  variable {
    name  = "BUCKET_NAME"
    value = "tf-states-enacom"
  }
}
