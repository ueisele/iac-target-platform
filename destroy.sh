#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_DESTROY=`pwd`
source ./env.sh
popd > /dev/null

function destroy () {
    (cd ${CWD_DESTROY} && vagrant destroy -f)
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    destroy
fi