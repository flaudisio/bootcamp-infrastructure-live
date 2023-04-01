# S3 bucket for Ansible Semaphore backups

This folder creates an S3 bucket to (optionally) store the database backups of Ansible Semaphore. This bucket is decoupled from the Semaphore
module to allow recreating the Semaphore stack repeatedly without having to manually seed its database.
