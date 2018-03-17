#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env-create.sh
source ./env-provision.sh
popd > /dev/null

function up () {
    local env=${1:?'Requires environment as first parameter!'}
    create ${env}
    provision ${env}
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    up "$@"
fi
