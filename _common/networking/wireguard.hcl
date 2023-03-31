terraform {
  source = "github.com/flaudisio/bootcamp-infrastructure-modules//modules/networking/wireguard-server?ref=v0.6.2"
}

dependency "vpc" {
  config_path = format("%s/networking/vpc", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    vpc_id         = "vpc-aaa111"
    public_subnets = ["subnet-aaa111", "subnet-bbb222", "subnet-ccc333"]
  }
}

dependency "security_groups" {
  config_path = format("%s/networking/security-groups", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    infra_services_security_group = "sg-aaa111"
  }
}

inputs = {
  vpc_id           = dependency.vpc.outputs.vpc_id
  public_subnet_id = dependency.vpc.outputs.public_subnets[0]

  attach_security_groups = [
    dependency.security_groups.outputs.infra_services_security_group,
  ]
}
