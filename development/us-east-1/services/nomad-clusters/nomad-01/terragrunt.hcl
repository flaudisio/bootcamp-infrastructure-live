include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/services/nomad-cluster.hcl"
}

inputs = {
  owner = "platform-team"

  cluster_name       = "nomad-01"
  cluster_public_key = file("public-key.txt")

  server_instance_type  = "t3a.micro"
  server_instance_count = 3

  client_instance_groups = {
    standard-amd64 = {
      ami_name       = "ubuntu-base-22.04-*"
      ami_owner      = "self"
      architecture   = "x86_64"
      instance_type  = "t3a.micro"
      instance_count = 2
    }
    standard-arm64 = {
      ami_name       = "ubuntu-base-22.04-*"
      ami_owner      = "self"
      architecture   = "arm64"
      instance_type  = "t4g.micro"
      instance_count = 2
    }
    # al2023-arm64 = {
    #   ami_name       = "al2023-ami-minimal-2023.*"
    #   ami_owner      = "amazon"
    #   architecture   = "arm64"
    #   instance_type  = "t4g.micro"
    #   instance_count = 1
    # }
  }

  # Uncomment for tests and troubleshooting
  allow_vpc_access = true
}
