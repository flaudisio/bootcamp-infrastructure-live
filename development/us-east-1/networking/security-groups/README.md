# Common security groups

This directory deploys security groups to be allowed in infrastructure components so region-level services like Ansible
Semaphore and Prometheus can work.

## Available security groups

| Terraform output | Goal | How to use in modules |
|------------------|------|-----------------------|
| `semaphore_access_security_group` | SSH access from Ansible Semaphore server | Attach to instances |
| `prometheus_scrape_security_group`| Prometheus scraping | Create security group rules to allow access to application/metrics ports |
