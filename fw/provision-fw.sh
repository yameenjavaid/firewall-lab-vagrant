#! /bin/bash

# Activar bit de fordwarding
echo -e "\n--- Activando bit de forwarding ---\n"
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Intslación de iptables-persistent
echo -e "\n--- Instalando iptables-persistent ---\n"
apt-get update
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
apt-get -y install iptables-persistent