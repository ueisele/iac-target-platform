#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env.sh
popd > /dev/null

function dns_enable () {
    sudo sh -c "echo \"server=/${PLATFORM_DOMAIN}/127.0.0.1#10053\" > /etc/NetworkManager/dnsmasq.d/${PLATFORM_DOMAIN//./-}_vagrant-landrush.conf"
    sudo sh -c "echo \"server=/consul/192.168.17.21#8600\" > /etc/NetworkManager/dnsmasq.d/${PLATFORM_DOMAIN//./-}_consul.conf"
    sudo sh -c "echo \"address=/public.${PLATFORM_DOMAIN}/${PLATFORM_PUBLICLBIP}\" > /etc/NetworkManager/dnsmasq.d/${PLATFORM_DOMAIN//./-}_public.conf"
    sudo systemctl restart NetworkManager
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    dns_enable
fi