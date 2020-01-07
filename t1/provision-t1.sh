#! /bin/bash
rm /var/lib/dpkg/lock
apt-get install net-tools -y
rm /etc/netplan/01-network-manager-all.yaml
netplan apply
ifconfig eth1 192.168.101.11
route add default gw 192.168.101.10
