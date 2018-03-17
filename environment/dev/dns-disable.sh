#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env.sh
popd > /dev/null

function dns_disable () {
    local domain=$(config domain)
    for file in $(find /etc/NetworkManager/dnsmasq.d/ -name "*${domain/./-}*"); do
        sudo rm ${file}
    done
    sudo systemctl restart NetworkManager
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    dns_disable
fi