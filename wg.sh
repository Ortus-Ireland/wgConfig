#!/bin/bash

sudo apt-get update -y
sudo apt install wireguard -y


mkdir ./home/ortusadmin/wg &&
mkdir ./home/ortusadmin/wg/keys &&
umask 077 &&
wg genkey |tee wg/keys/server_private_key|wg pubkey>wg/keys/server_public_key

echo "
[Interface]
Address = 10.200.200.1/24
SaveConfig = true 
ListenPort = 443
PrivateKey=$(cat wg/keys/server_private_key)"|sudo tee /etc/wireguard/wg0.conf

sudo sysctl -w net.ipv4.ip_forward=1

# Assign the filename
filename="/etc/sysctl.conf"

# Take the search string
read -p "#net.ipv4.ip_forward=1" search

# Take the replace string
read -p "net.ipv4.ip_forward=1" replace

if [[ $search != "" && $replace != "" ]]; then
sed -i "s/$search/$replace/" $filename
fi

sudo sysctl -p /etc/sysctl.conf

sudo iptables -A FORWARD -i wg0 -j ACCEPT

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sudo iptables -t nat -A POSTROUTING -s 10.200.200.0/24 -o eth0 -j MASQUERADE

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections

sudo apt install iptables-persistent -y
sudo systemctl enable netfilter-persistent
sudo netfilter-persistent save
 
sudo wg-quick up wg0 &&log
sudo systemctl enable wg-quick@wg0