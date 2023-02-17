include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/services/wordpress-site.hcl"
}

inputs = {
  owner = "backend-team"

  site_name = "wp-01"

  asg_min_size         = 0
  asg_max_size         = 0
  asg_desired_capacity = 0

  asg_health_check_type = "EC2"

  ec2_instance_type = "t3.micro"
  ec2_public_key    = file("public-key.txt")

  db_instance_type = "db.t4g.micro"
  db_multi_az      = false

  # Must be 'true' to fully destroy the component, otherwise the DB option group cannot be removed
  db_skip_final_snapshot = true

  memcached_instance_type = "cache.t3.micro"
  memcached_multi_az      = false

  # NOTE: comment when not troubleshooting
  allow_vpc_access = true
}
