#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env-run-cmd.sh
popd > /dev/null

function ssh () {
    local env=${1:?'Requires environment as first parameter!'}
    shift
    run_cmd ${env} "ssh.sh" "$@"
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    ssh $@
fi