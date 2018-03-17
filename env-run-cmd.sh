#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env.sh
popd > /dev/null

function run_cmd () {
    local env=${1:?'Requires environment as first parameter!'}
    if [[ "$(is_env ${env})" != "true" ]]; then
        echo "The environment '${env}' is not valid! Use one of '$(environments)'!"
        exit
    fi
    local cmd=${2:?'Requires command as second parameter!'}
    shift
    shift
    (cd $(environment_root ${env}) && ${cmd} "$@")
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    run_cmd "$@"
fi