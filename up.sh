#!/bin/bash
set -e
cd $(dirname $(readlink -f $0))

vagrant up --no-provision
vagrant provision

sudo sh -c 'echo "server=/platform.dev/127.0.0.1#10053" > /etc/NetworkManager/dnsmasq.d/vagrant-landrush_platform-dev.conf'
sudo sh -c 'echo "server=/consul/192.168.17.20#8600" > /etc/NetworkManager/dnsmasq.d/consul_platform-dev.conf'
sudo sh -c 'echo "address=/public.platform.dev/192.168.17.10" > /etc/NetworkManager/dnsmasq.d/public_platform-dev.conf'
sudo systemctl restart NetworkManager