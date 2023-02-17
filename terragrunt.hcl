# ------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# ------------------------------------------------------------------------------

# Version constraints
terraform_version_constraint  = "~> 1.3"
terragrunt_version_constraint = "~> 0.42"

# Local aliases for improved maintainability
locals {
  # Load account and region-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals

  # Extract the variables we need for easy access
  account_id  = local.account_vars.account_id
  aws_region  = local.region_vars.aws_region
  environment = local.env_vars.environment

  # Tags for state resources (S3 bucket, DynamoDB table, etc)
  state_tags = {
    iac-repo   = "bootcamp-sre-infrastructure-live"
    created-by = "terragrunt"
  }
}

# Generate the AWS provider config
generate "aws_provider" {
  path      = "_tg-aws-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      region = "${local.aws_region}"

      # Only these AWS account IDs may be operated on by this template
      allowed_account_ids = ["${local.account_id}"]
    }
  EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  generate = {
    path      = "_tg-backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  backend = "s3"

  config = {
    encrypt = true
    bucket  = format("bootcamp-sre-tfstate-%s-%s", local.environment, local.account_id)
    key     = format("%s/terraform.tfstate", path_relative_to_include())
    region  = "us-east-1"

    dynamodb_table = "terraform-locks"

    s3_bucket_tags      = local.state_tags
    dynamodb_table_tags = local.state_tags
  }
}

# ------------------------------------------------------------------------------
# AUTO RETRY
# The errors below are well known and should be retried.
# See https://terragrunt.gruntwork.io/docs/features/auto-retry/
# ------------------------------------------------------------------------------

retry_max_attempts       = 3
retry_sleep_interval_sec = 5

retryable_errors = [
  # Intermittent network issues
  "(?s).*Error installing provider.*tcp.*connection reset by peer.*",
  "(?s).*read:.*software caused connection abort.*",
  "(?s).*ssh_exchange_identification.*Connection closed by remote host.*",
]

# ------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. They are
# automatically merged into child 'terragrunt.hcl' configs via the include block.
# ------------------------------------------------------------------------------

inputs = merge(
  local.account_vars,
  local.region_vars,
  local.env_vars,
)
