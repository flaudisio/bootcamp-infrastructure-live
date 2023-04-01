terraform {
  source = "github.com/flaudisio/bootcamp-infrastructure-modules//modules/mgmt/semaphore-trigger?ref=v0.7.0"
}

dependency "vpc" {
  config_path = format("%s/networking/vpc", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    vpc_id          = "vpc-aaa111"
    private_subnets = ["subnet-ddd444", "subnet-eee555", "subnet-fff666"]
  }
}

dependency "security_groups" {
  config_path = format("%s/networking/security-groups", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    semaphore_server_security_group = "sg-aaa111"
  }
}

dependency "semaphore" {
  config_path = format("%s/mgmt/semaphore", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    semaphore_endpoint = "http://mocked.example.com"
  }
}

inputs = {
  vpc_id          = dependency.vpc.outputs.vpc_id
  private_subnets = dependency.vpc.outputs.private_subnets

  attach_security_groups = [
    dependency.security_groups.outputs.semaphore_server_security_group,
  ]

  semaphore_endpoint = dependency.semaphore.outputs.semaphore_endpoint
}
