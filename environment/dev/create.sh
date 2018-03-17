#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./vagrant.sh
source ./ansible-inventory.sh
popd > /dev/null

function up_in_env () {
    vagrant_in_env up
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    up_in_env
    generate_ansible_inventory
fi