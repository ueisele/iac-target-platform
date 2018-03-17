#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_ROOT=`pwd`
CWD_ENV_BASE="${CWD_ROOT}/environment"
export PROVISION_DIR="${CWD_ROOT}/provisioning"
export PROVISION_PLAYBOOK="${PROVISION_DIR}/playbook.yml"
popd > /dev/null

function environment_root() {
    local env=${1:?'Requires environment as first parameter!'}
    echo -e "${CWD_ENV_BASE}/${env}"
}

function environment_inventory() {
    local env=${1:?'Requires environment as first parameter!'}
    echo -e "$(environment_root $1)/inventory"
}

function environments() {
    local envs=()
    for env in $(ls ${CWD_ENV_BASE}); do
        if [ -d $(environment_inventory ${env}) ]; then
            envs+=(${env})
        fi
    done
    echo ${envs[@]}
}

function is_env() {
    local env=${1:?'Requires environment as first parameter!'}
    if [[ "$(environments)[@]" =~ "${env}" ]]; then
        echo true
    else
        echo false
    fi
}
