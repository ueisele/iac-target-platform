#!/bin/bash
cd $(dirname $(readlink -f $0))

sudo rm /etc/NetworkManager/dnsmasq.d/vagrant-landrush_platform-novatec.conf
sudo systemctl restart NetworkManager

vagrant destroy -f
