#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./vagrant.sh
popd > /dev/null

function ssh_in_env () {
    local host=${1:?'Missing host as first parameter!'}
    vagrant_in_env ssh ${host}
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    ssh_in_env $@
fi