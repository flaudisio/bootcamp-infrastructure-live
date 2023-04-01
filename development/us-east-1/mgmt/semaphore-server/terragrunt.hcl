# We're not using this component for now
skip = true

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/mgmt/semaphore-ec2.hcl"
}

inputs = {
  # WARNING: Semaphore does not work well with multiple instances!
  # Only use ec2_instance_count > 1 for special cases (e.g. tests and service recycling)
  ec2_instance_count = 1

  ec2_instance_type = "t3a.micro"
  ec2_public_key    = file("public-key.txt")

  db_instance_type = "db.t4g.micro"
  db_multi_az      = false

  # Must be 'true' to fully destroy the component, otherwise the DB option group cannot be removed
  db_skip_final_snapshot = true

  # Uncomment for tests and troubleshooting
  allow_vpc_access = true
}
