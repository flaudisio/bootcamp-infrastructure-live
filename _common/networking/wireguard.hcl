terraform {
  source = "git::ssh://git@github.com/flaudisio/bootcamp-infrastructure-modules.git//modules/networking/wireguard-server?ref=v0.3.0"
}

dependency "vpc" {
  config_path = format("%s/networking/vpc", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    vpc_id         = "vpc-aaa111"
    public_subnets = ["subnet-aaa111", "subnet-bbb222", "subnet-ccc333"]
  }
}

inputs = {
  vpc_id           = dependency.vpc.outputs.vpc_id
  public_subnet_id = dependency.vpc.outputs.public_subnets[0]
}