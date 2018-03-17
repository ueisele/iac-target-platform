#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_ANSIBLE_ROOT=`pwd`
source ./env.sh
popd > /dev/null

function ansible_adhoc () {
    local env=${1:?'Requires environment as first parameter!'}
    if [[ "$(is_env ${env})" != "true" ]]; then
        echo "The environment '${env}' is not valid! Use one of '$(environments)'!"
        exit
    fi
    shift
    (cd ${CWD_ANSIBLE_ROOT} && ansible all -i $(environment_inventory ${env}) "$@")
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    ansible_adhoc "$@"
fi
