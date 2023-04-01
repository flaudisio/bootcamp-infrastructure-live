terraform {
  source = "github.com/flaudisio/bootcamp-infrastructure-modules//modules/mgmt/semaphore-ec2?ref=v0.7.0"
}

dependency "vpc" {
  config_path = format("%s/networking/vpc", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    vpc_id          = "vpc-aaa111"
    vpc_cidr_block  = "99.0.0.0/16"
    private_subnets = ["subnet-ddd444", "subnet-eee555", "subnet-fff666"]

    database_subnet_group_name = "mocked-subnet-group"
  }
}

dependency "security_groups" {
  config_path = format("%s/networking/security-groups", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    semaphore_server_security_group = "sg-aaa111"
  }
}

dependency "backup_bucket" {
  config_path = format("%s/_regional/s3-buckets/semaphore-backups", dirname(find_in_parent_folders("region.hcl")))

  mock_outputs = {
    bucket_name = "mocked-bucket-name"
  }
}

inputs = {
  vpc_id          = dependency.vpc.outputs.vpc_id
  vpc_cidr_block  = dependency.vpc.outputs.vpc_cidr_block
  private_subnets = dependency.vpc.outputs.private_subnets

  db_subnet_group = dependency.vpc.outputs.database_subnet_group_name

  attach_security_groups = [
    dependency.security_groups.outputs.semaphore_server_security_group,
  ]

  backup_bucket = dependency.backup_bucket.outputs.bucket_name
}
