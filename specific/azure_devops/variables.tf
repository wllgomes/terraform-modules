variable "aws_region" {
  type        = string
  description = "region"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "enterprise_context" {
  type = map(string)
  validation {
    condition = alltrue([
      contains(["ene", "sid", "log", "ena", "data"], var.enterprise_context.vertical_initials),
      contains(["energia", "siderurgia", "logistica", "enacom", "data"], var.enterprise_context.vertical),
      contains(["dev", "hml", "prd"], var.enterprise_context.environment)
    ])
    error_message = "enterprise_context parameter are invalid, see README.md to more details"
  }
}

variable "state_bucket_kms_key_id" {
  type        = string
  description = "KMS key of state bucket"
}

variable "state_bucket_name" {
  type        = string
  description = "Name of state bucket"
}

variable "branch_independent_variables" {
  type = object({
    azure_artefacts_pat     = optional(string),
    sonarqube_token         = optional(string),
    network                 = optional(bool),
    create_old_azure_access = optional(bool, false),
    token_semantic_release  = optional(string)

    old_account_access = optional(object({
      id        = string
      secret_id = string
    }))
  })
  default     = {}
  description = "Branch indepedent variable (should there is exact one for each vertical)"
}

variable "create_cicd_agent_pool" {
  type        = bool
  description = "Create cicd agent pool"
  default     = false
}
