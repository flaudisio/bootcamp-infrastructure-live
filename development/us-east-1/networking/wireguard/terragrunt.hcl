include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/networking/wireguard.hcl"
}

inputs = {
  instance_type = "t4g.micro"

  public_key = file("public-key.txt")

  # Uncomment and change to your IP
  # WARNING: use only for tests and troubleshooting!
  # allow_ssh_from_cidrs = ["123.4.5.6/32"]
}
