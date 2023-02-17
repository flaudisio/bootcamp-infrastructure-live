include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/networking/wireguard.hcl"
}

inputs = {
  instance_type = "t4g.micro"

  public_key = file("public-key.txt")
}
