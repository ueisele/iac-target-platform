#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_ANSIBLE_ROOT=`pwd`
source ./env.sh
popd > /dev/null

function ansible_install_roles () {
    local provision_dir=${1:-${PROVISION_DIR}}  
    local requirements=${provision_dir}/requirements.yml
    if [ -f ${requirements} ]; then
        (cd ${CWD_ANSIBLE_ROOT} && ansible-galaxy install --roles-path ${provision_dir}/roles-galaxy --role-file ${requirements})
    fi
}

function ansible_roles_path () {
    local provision_dir=${1:-${PROVISION_DIR}}  
    echo "${provision_dir}/roles-galaxy:${provision_dir}/roles"
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    ACTUAL_PROVISION_DIR=${PROVISION_DIR}

    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        --install)
        INSTALL=true
        shift # past argument
        ;;
        --print)
        PRINT=true
        shift # past argument
        ;;
        --provision-dir)
        ACTUAL_PROVISION_DIR=$2
        shift # past argument
        shift # past value
        ;;        
        *)    # unknown option
        shift # past argument
        ;;
    esac
    done

    if [[ -z ${INSTALL} ]] && [[ -z ${PRINT} ]]; then
        echo -e "Usage: $0 [options]"
        echo -e "\t--install\tInstall Ansible roles"
        echo -e "\t--print\tPrint Ansible roles directories"
        echo -e "\t--provision-dir\tSet the provisioning directory (default: ${PROVISION_DIR})"
    fi

    if [[ -n ${INSTALL} ]]; then
        ansible_install_roles ${ACTUAL_PROVISION_DIR}
    fi
    if [[ -n ${PRINT} ]]; then
        ansible_roles_path ${ACTUAL_PROVISION_DIR}
    fi
fi
