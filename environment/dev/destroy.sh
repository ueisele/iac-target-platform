#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./vagrant.sh
popd > /dev/null

function destroy_in_env () {
   vagrant_in_env destroy -f
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    destroy_in_env
fi