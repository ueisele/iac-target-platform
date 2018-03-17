#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_ENV_VAGRANT=`pwd`
source ./env.sh
popd > /dev/null

function vagrant_in_env () {
    (cd ${CWD_ENV_VAGRANT} && vagrant $@)
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    vagrant_in_env "$@"
fi