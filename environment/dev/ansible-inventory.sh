#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env.sh
source ./vagrant.sh
popd > /dev/null

function ansible_hosts () {
    vagrant_in_env ssh-config | vagrant_ssh_config_to_ansible_inventory
}

function ansible_groups () {
    config groups | yaml_to_ini
}

function ansible_inventory () {
     echo -e "$(ansible_hosts)\n\n$(ansible_groups)"
}

function generate_ansible_inventory () {
     ansible_inventory > ${INVENTORY_FILE}
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        --to-file)
        TO_FILE=true
        shift # past argument
        ;;
        --print)
        PRINT=true
        shift # past argument
        ;;
        *)    # unknown option
        shift # past argument
        ;;
    esac
    done

    if [[ -z ${TO_FILE} ]] && [[ -z ${PRINT} ]]; then
        echo -e "Usage: $0 [options]"
        echo -e "\t--to-file\tGenerate and save Ansible inventory file"
        echo -e "\t--print\tGenerate and print Ansible inventory file"
    fi

    if [[ -n ${TO_FILE} ]]; then
        generate_ansible_inventory
    fi
    if [[ -n ${PRINT} ]]; then
        ansible_inventory
    fi
fi