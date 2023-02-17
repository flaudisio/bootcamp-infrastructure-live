locals {
  # Components in the '_global' directory don't actually belong to a region, but we still
  # need to define it for configuring the AWS provider in the root 'terragrunt.hcl' file
  aws_region = "us-east-1"
}
