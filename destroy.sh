#!/bin/bash
cd $(dirname $(readlink -f $0))

sudo rm /etc/NetworkManager/dnsmasq.d/vagrant-landrush_platform-dev.conf || true
sudo rm /etc/NetworkManager/dnsmasq.d/consul_platform-dev.conf || true
sudo rm /etc/NetworkManager/dnsmasq.d/public_platform-dev.conf || true
sudo systemctl restart NetworkManager

vagrant destroy -f
