terraform {
  source = "github.com/flaudisio/bootcamp-infrastructure-modules//modules/mgmt/prometheus-server?ref=v0.7.0"
}

dependency "vpc" {
  config_path = format("%s/networking/vpc", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    vpc_id          = "vpc-aaa111"
    vpc_cidr_block  = "99.0.0.0/16"
    private_subnets = ["subnet-ddd444", "subnet-eee555", "subnet-fff666"]
  }
}

dependency "security_groups" {
  config_path = format("%s/networking/security-groups", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    prometheus_server_security_group = "sg-aaa111"
  }
}

inputs = {
  vpc_id          = dependency.vpc.outputs.vpc_id
  vpc_cidr_block  = dependency.vpc.outputs.vpc_cidr_block
  private_subnets = dependency.vpc.outputs.private_subnets

  attach_security_groups = [
    dependency.security_groups.outputs.prometheus_server_security_group,
  ]
}
