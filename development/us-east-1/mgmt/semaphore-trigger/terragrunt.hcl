# We're not using this component for now
skip = true

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/mgmt/semaphore-trigger.hcl"
}

inputs = {
  enable_lambda_function = true

  semaphore_project_id = 1

  # TODO: fetch token from Secrets Manager (or equivalent)
  semaphore_token = "CHANGEME"
}
