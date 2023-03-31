terraform {
  source = "github.com/flaudisio/bootcamp-infrastructure-modules//modules/networking/security-groups?ref=v0.7.0"
}

dependency "vpc" {
  config_path = format("%s/networking/vpc", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    vpc_id = "vpc-aaa111"
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
}
