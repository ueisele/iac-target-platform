#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env-run-cmd.sh
popd > /dev/null

function destroy () {
    run_cmd $1 "destroy.sh"
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    destroy "$@"
fi