#!/usr/bin/env bash
#
# update-providers.sh
#
# Update Terraform providers in the specified directory.
#
# Usage:
#   ./update-providers.sh TARGET_DIR
#
# Example:
#   ./update-providers.sh development/_global/
#   ./update-providers.sh development/us-east-1/networking/vpc/
#
##

set -e
set -u
set -o pipefail

readonly TargetDir="$1"

: "${NO_INIT_UPGRADE:=""}"
: "${SKIP_INIT:=""}"
: "${SKIP_PROVIDERS_LOCK:=""}"

if [[ -z "$NO_INIT_UPGRADE" ]] ; then
    export TF_CLI_ARGS_init="-upgrade"
fi

set -x

if [[ -z "$SKIP_INIT" ]] ; then
    terragrunt run-all init --terragrunt-working-dir "$TargetDir"
fi

if [[ -z "$SKIP_PROVIDERS_LOCK" ]] ; then
    terragrunt run-all providers lock -platform=linux_amd64 --terragrunt-working-dir "$TargetDir"
fi
