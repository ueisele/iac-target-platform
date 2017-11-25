#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_UP=`pwd`
source ./env.sh
popd > /dev/null

function up () {
    (cd ${CWD_UP} && vagrant up --no-provision)
    (cd ${CWD_UP} && vagrant provision)
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    up
fi