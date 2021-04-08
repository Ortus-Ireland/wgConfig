#!/bin/bash


#Variables Declared
# How Many Keys to be Generated
HowMany=5

#What is the starting Static IP of Clients
StartIPAddr=10

#Domanin Controllers DNS
DNS1="123.16.164.19"
DNS2="123.16.164.19"

#Public IP
serverIP="13.70.207.134"

#Allowed IPs
AllowedIPs="172.16.164.0/24"

# Setup Folders & Server Keys
# RE ENABLE ME!!!!!!!
mkdir /home/${USER}/wg
mkdir /home/${USER}/wg/keys
mkdir /home/${USER}/wg/clients
umask 077

# This overwrites the previous Key without prompt. Maybe needs a if Statement to check if something is there or not. 
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
wg genkey | tee /home/$USER/wg/keys/server_private_key | wg pubkey > /home/$USER/wg/keys/server_public_key
wg genpsk > /home/$USER/wg/keys/preshared_key

# Set Variables for Global Key Creation
# server_private_key=$(</home/$USER/wg/keys/server_private_key)
# preshared_key=$(</home/$USER/wg/keys/preshared_key)
# server_public_key=$(</home/$USER/wg/keys/server_public_key)


#Config Loop
for i in $(seq $HowMany); do
# Test Loop and Show current Static IP ending
    echo $StartIPAddr
    StartIPAddr=$((StartIPAddr+1))

    wg genkey | tee /home/$USER/wg/keys/${StartIPAddr}_private_key | wg pubkey > /home/$USER/wg/keys/${StartIPAddr}_public_key
    
    wg set wg0 peer $(cat /home/$USER/wg/keys/${StartIPAddr}_public_key) allowed-ips 10.200.200.${StartIPAddr}/32ls

    echo "[Interface]
        Address = 10.200.200.10/32
        PrivateKey = $(cat "/home/${USER}/wg/keys/${StartIPAddr}_private_key")
        DNS = ${DNS1},${DNS2}

        [Peer]
        PublicKey = $(cat "/home/${USER}/wg/keys/server_public_key")
        Endpoint = ${serverIP}:443
        AllowedIPs = ${AllowedIPs}/24
        PersistentKeepalive = 21" > /home/$USER/wg/clients/${StartIPAddr}.conf

           
    done
