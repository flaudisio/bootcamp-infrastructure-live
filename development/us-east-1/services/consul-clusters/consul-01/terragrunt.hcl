include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/services/consul-cluster.hcl"
}

inputs = {
  owner = "platform-team"

  cluster_name       = "consul-01"
  cluster_public_key = file("public-key.txt")

  instance_type  = "t3a.micro"
  instance_count = 3

  # Uncomment for tests and troubleshooting
  allow_vpc_access = true
}
