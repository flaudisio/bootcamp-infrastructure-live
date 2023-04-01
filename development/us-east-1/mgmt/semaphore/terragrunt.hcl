# We're not using this component for now
skip = true

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${get_repo_root()}/_common/mgmt/semaphore-ecs.hcl"
}

inputs = {
  # WARNING: Semaphore does not work well with multiple containers!
  # Only use container_count > 1 for special cases (e.g. tests and service recycling)
  container_count = 1

  semaphore_image = "flaudisio/bootcamp-semaphore:2.8.77"

  semaphore_max_parallel_tasks = 4

  housekeeper_image    = "flaudisio/bootcamp-semaphore-housekeeper:0.1.0"
  housekeeper_schedule = "0 * * * *"

  ecs_task_cpu    = 512
  ecs_task_memory = 1024

  db_instance_type = "db.t4g.micro"
  db_multi_az      = false

  db_snapshot_identifier = "final-semaphore-91ad60f4"
  # db_skip_final_snapshot = true

  # Uncomment for tests and troubleshooting
  # allow_vpc_access = true
}
