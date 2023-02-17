include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/networking/vpc.hcl"
}

inputs = {
  cidr = "10.70.0.0/16"

  # Use single NAT Gateway for reduced costs
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
