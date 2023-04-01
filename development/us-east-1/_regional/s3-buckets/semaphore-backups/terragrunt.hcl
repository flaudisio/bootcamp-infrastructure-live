include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/storage/s3-bucket.hcl"
}

inputs = {
  owner   = "infra"
  service = "semaphore-server"

  bucket_name = "semaphore-backups"

  append_environment = true
  append_account_id  = true
  append_region      = true
}
