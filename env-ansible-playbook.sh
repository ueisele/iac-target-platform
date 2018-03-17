#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_ANSIBLE_ROOT=`pwd`
source ./env.sh
source ./env-ansible-roles.sh
popd > /dev/null

function ansible_playbook () {
    local env=${1:?'Requires environment as first parameter!'}
    if [[ "$(is_env ${env})" != "true" ]]; then
        echo "The environment '${env}' is not valid! Use one of '$(environments)'!"
        exit
    fi
    shift
    if [[ $# = 0 ]] || [[ ! ${@: -1} =~ ^.*\.y(a)?ml$ ]]; then
        echo "Requires playbook as last parameter!"
        exit
    fi
    local playbook=$(realpath ${@: -1})
    local provision_dir=$(dirname ${playbook})
    local options=${@:1:$(($#-1))}

    ansible_install_roles ${provision_dir}
    (cd ${CWD_ANSIBLE_ROOT} && ANSIBLE_ROLES_PATH=$(ansible_roles_path ${provision_dir}) ansible-playbook -i $(environment_inventory ${env}) ${options} ${playbook})
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    ansible_playbook "$@"
fi