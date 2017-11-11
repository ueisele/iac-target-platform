#!/bin/bash
set -e
cd $(dirname $(readlink -f $0))

vagrant up --no-provision
vagrant provision

sudo sh -c 'echo "server=/platform.novatec/127.0.0.1#10053" > /etc/NetworkManager/dnsmasq.d/vagrant-landrush_platform-novatec.conf'
sudo systemctl restart NetworkManager