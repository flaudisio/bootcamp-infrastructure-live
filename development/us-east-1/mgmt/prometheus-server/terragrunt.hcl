# We're not using this component for now
skip = true

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/mgmt/prometheus-server.hcl"
}

inputs = {
  instance_count = 1
  instance_type  = "t3a.micro"

  public_key = file("public-key.txt")

  # Uncomment for tests and troubleshooting
  allow_vpc_access = true
}
