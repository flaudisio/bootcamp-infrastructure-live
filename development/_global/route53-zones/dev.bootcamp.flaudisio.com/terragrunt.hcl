include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/networking/route53-zone.hcl"
}

inputs = {
  zone_name = "dev.bootcamp.flaudisio.com"
}
