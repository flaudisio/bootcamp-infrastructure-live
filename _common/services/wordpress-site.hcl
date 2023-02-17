terraform {
  source = "git::ssh://git@github.com/flaudisio/bootcamp-infrastructure-modules.git//modules/services/wordpress-site?ref=v0.3.0"
}

dependency "vpc" {
  config_path = format("%s/networking/vpc", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    vpc_id          = "vpc-aaa111"
    vpc_cidr_block  = "99.0.0.0/16"
    public_subnets  = ["subnet-aaa111", "subnet-bbb222", "subnet-ccc333"]
    private_subnets = ["subnet-ddd444", "subnet-eee555", "subnet-fff666"]

    database_subnet_group_name    = "mocked-subnet-group"
    elasticache_subnet_group_name = "mocked-subnet-group"
  }
}

inputs = {
  vpc_id          = dependency.vpc.outputs.vpc_id
  vpc_cidr_block  = dependency.vpc.outputs.vpc_cidr_block
  public_subnets  = dependency.vpc.outputs.public_subnets
  private_subnets = dependency.vpc.outputs.private_subnets

  db_subnet_group        = dependency.vpc.outputs.database_subnet_group_name
  memcached_subnet_group = dependency.vpc.outputs.elasticache_subnet_group_name
}
