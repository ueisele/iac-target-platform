#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
CWD_VAGRANT=`pwd`
export ANSIBLE_ROLES_PATH=${CWD_VAGRANT}/provisioning/roles:${CWD_VAGRANT}/provisioning/roles-galaxy
source ./env.sh
popd > /dev/null

function ansible_playbook () {
    ansible-playbook -i ${CWD_VAGRANT}/.vagrant/provisioners/ansible/inventory -e domainname=${DOMAIN_NAME} -e publiclb_ip=${PUBLICLB_IP} $@
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    ansible_playbook $@
fi
