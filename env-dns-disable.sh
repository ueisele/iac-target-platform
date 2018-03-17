#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env-run-cmd.sh
popd > /dev/null

function dns_disable () {
    run_cmd $1 "dns-disable.sh"
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    dns_disable "$@"
fi