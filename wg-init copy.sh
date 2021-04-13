#!/bin/bash

sleep 30
sudo apt-get update -y
sudo apt install wireguard -y


mkdir ./wg &&
mkdir ./wg/keys &&
umask 077 &&
wg genkey |tee wg/keys/server_private_key|wg pubkey>wg/keys/server_public_key

echo "
[Interface]
Address = 10.200.200.1/24
SaveConfig = true 
ListenPort = 443
PrivateKey=$(cat wg/keys/server_private_key)"|sudo tee /etc/wireguard/wg0.conf

sudo sysctl -w net.ipv4.ip_forward=1

## IP Forwarding
sed -i -e 's/#net.ipv4.ip_forward.*/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i -e 's/#net.ipv6.conf.all.forwarding.*/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p

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

#Variables Declared
# How Many Keys to be Generated
HowMany=$1

#What is the starting Static IP of Clients
StartIPAddr=$2

#Public IP
serverIP=$3

# Change User
SrvUser=$4

#Domanin Controllers DNS
DNS1=$5
DNS2=$6

#Allowed IPs
AllowedIPs="10.200.200.0/24"

# Setup Folders & Server Keys
mkdir /home/${SrvUser}/wg
mkdir /home/${SrvUser}/wg/keys
mkdir /home/${SrvUser}/wg/clients
umask 077

# This overwrites the previous Key without prompt. Maybe needs a if Statement to check if something is there or not. 
# wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
# wg genkey | tee /home/$SrvUser/wg/keys/server_private_key | wg pubkey > /home/$SrvUser/wg/keys/server_public_key
# wg genpsk > /home/$SrvUser/wg/keys/preshared_key

#Config Loop
for i in $(seq $HowMany); do
# Test Loop and Show current Static IP ending
    echo $StartIPAddr

    wg genkey | tee /home/$SrvUser/wg/keys/${StartIPAddr}_private_key | wg pubkey > /home/$SrvUser/wg/keys/${StartIPAddr}_public_key
    
    wg set wg0 peer $(cat /home/$SrvUser/wg/keys/${StartIPAddr}_public_key) allowed-ips 10.200.200.${StartIPAddr}/32

    echo "[Interface]
        Address = 10.200.200.10/32
        PrivateKey = $(cat "/home/${SrvUser}/wg/keys/${StartIPAddr}_private_key")
        DNS = ${DNS1},${DNS2}

        [Peer]
        PublicKey = $(cat "/home/${SrvUser}/wg/keys/server_public_key")
        Endpoint = ${serverIP}:443
        AllowedIPs = ${AllowedIPs}
        PersistentKeepalive = 21" > /home/$SrvUser/wg/clients/${StartIPAddr}.conf
    
    
    StartIPAddr=$((StartIPAddr+1))

           
    done


sudo chown -R $SrvUser /home/$SrvUser/wg
