#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_ENV=`pwd`
popd > /dev/null

export CONFIG_FILE="${CWD_ENV}/platform.yml"
export INVENTORY_FILE="${CWD_ENV}/inventory/generated_ansible_inventory"

function parse_yaml () {
    local file=""
    if [[ $1 ]]; then
        file="-f $1"
    fi
    local path=""
    if [[ $2 ]]; then
        path="-p $2"
    fi
    echo "$(${CWD_ENV}/parse_yaml.rb ${file} ${path})"
}

function yaml_to_ini () {
    local yaml_file=""
    if [[ $1 ]]; then
        yaml_file="-s $1"
    fi
    local ini_file=""
    if [[ $2 ]]; then
        ini_file="-o $2"
    fi
    echo "$(${CWD_ENV}/yaml_to_ini.rb ${yaml_file} ${ini_file})"
}

function vagrant_ssh_config_to_ansible_inventory () {
    local vagrant_ssh_config_file=""
    if [[ $1 ]]; then
        vagrant_ssh_config_file="-s $1"
    fi
    local ansible_inventory_file=""
    if [[ $2 ]]; then
        ansible_inventory_file="-o $2"
    fi
    echo "$(${CWD_ENV}/vagrant_ssh_config_to_ansible_inventory.rb ${vagrant_ssh_config_file} ${ansible_inventory_file})"
}

function config () {
    parse_yaml ${CONFIG_FILE} $@
}
