#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env.sh
source ./env-ansible-playbook.sh
popd > /dev/null

function provision () {
    ansible_playbook "$@" ${PROVISION_PLAYBOOK}
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    provision "$@"
fi
