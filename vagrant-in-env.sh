#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_VAGRANT=`pwd`
source ./env.sh
popd > /dev/null

function up () {
    (cd ${CWD_VAGRANT} && vagrant $@)
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    up $@
fi