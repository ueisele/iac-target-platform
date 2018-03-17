#!/usr/bin/env bash
set -e
pushd . > /dev/null
cd $(dirname ${BASH_SOURCE[0]})
source ./env.sh
popd > /dev/null

function dns_enable () {
    local domain=$(config domain)
    local publiclbip=$(config publiclbip)
    sudo sh -c "echo \"server=/${domain}/127.0.0.1#10053\" > /etc/NetworkManager/dnsmasq.d/${domain//./-}_vagrant-landrush.conf"
    sudo sh -c "echo \"server=/consul/192.168.17.21#8600\" > /etc/NetworkManager/dnsmasq.d/${domain//./-}_consul.conf"
    sudo sh -c "echo \"address=/public.${domain}/${publiclbip}\" > /etc/NetworkManager/dnsmasq.d/${domain//./-}_public.conf"
    sudo systemctl restart NetworkManager
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    dns_enable
fi