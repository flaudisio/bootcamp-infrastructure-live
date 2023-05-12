# Bootcamp SRE - Infrastructure Live

Terragrunt manifests for deploying the AWS infrastructure for ElvenWorks' [SRE Bootcamp][bootcamp] (class \#3) final challenge.

[bootcamp]: https://aprenda.elven.works/programas-de-formacao-bootcamp-sre

## Deploying the infrastructure

The following repositories are required:

- [bootcamp-infrastructure-live](https://github.com/flaudisio/bootcamp-infrastructure-live)
- [bootcamp-infrastructure-modules](https://github.com/flaudisio/bootcamp-infrastructure-modules)
- [bootcamp-ansible-playbooks](https://github.com/flaudisio/bootcamp-ansible-playbooks)
- [bootcamp-packer-templates](https://github.com/flaudisio/bootcamp-packer-templates)

### Step 1 - Create AWS account and user

- Create the account.
- Create an IAM user an access/secret key. The user must have the `AdministratorAccess` policy attached.

### Step 2 - Configure the `ansible-playbooks` repository

- Fork and create your own `ansible-playbooks` repository. It will be called from user data scripts configured in the
  `bootcamp-infrastructure-modules` repository.

### Step 3 - Create the AMIs

- Fork and create your own `bootcamp-packer-templates` repository.
- Create the AMIs in your AWS account (see the repository documentation). The generated images are used by several Terraform
  modules maintained in the `bootcamp-infrastructure-modules` repository.

### Step 4 - Prepare your Terraform modules

- Fork and create your own `bootcamp-infrastructure-modules` repository.
- Search for `bootcamp-ansible-playbooks` and change the user data scripts according to the repository created in step 2.
- Search for `ami_name` and change them if necessary according to the AMIs generated in step 3.

### Step 5 - Prepare your Live repository

- Fork and create your own `bootcamp-infrastructure-live` repository.
- Install dependencies (see the [`.tool-versions` file](.tool-versions)).
- For each environment:
  - Change the `account.hcl` file according to your AWS account created in step 1.
  - Rename the `<env>/_global/route53-zones/<zone-name>` directory and change its `terragrunt.hcl` file according to the
    zone name of your account.
  - Deploy the account Route 53 zone:

    ```
    cd <env>/_global/route53-zones/<zone-name>/
    terragrunt apply
    ```

  - Deploy the account baseline config:

    ```
    cd <env>/_global/account-baseline/
    terragrunt apply
    ```

  - Deploy the region baseline config:

    ```
    cd <env>/us-east-1/_regional/region-baseline/
    terragrunt apply
    ```

  - Deploy the core networking (VPC):

    ```
    cd <env>/us-east-1/networking/vpc/
    terragrunt apply

    cd <env>/us-east-1/networking/security-groups/
    terragrunt apply
    ```

  - Deploy the VPN server:

    ```
    cd <env>/us-east-1/networking/wireguard/
    terragrunt apply
    ```

### Step 6 - Explore!

At this point you should have a minimally functional AWS account! From now on you may explore other infrastructure components to
learn and deploy, for example:

- `mgmt/prometheus-server/` - a [Prometheus](https://prometheus.io/) server instance.

- `mgmt/semaphore/` - an [Ansible Semaphore](https://www.ansible-semaphore.com/) deployment on ECS to
  configure EC2 instances using your `bootcamp-ansible-playbooks` repository.

- `mgmt/semaphore-trigger/` - a Lambda function that uses the Ansible Semaphore APIs to automatically
  configure EC2 instances as soon as they are launched and enter the `running` state.

- `services/nomad-clusters/` - a simple way to deploy a fully functional [Nomad](https://www.nomadproject.io/) cluster to
  schedule, orchestrate and deploy applications (specially containers).
