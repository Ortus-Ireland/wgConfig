#!/bin/bash
#SrvUser="ortusadmin"
SrvUser=$1
BACKUPTIME=`date +%b-%d-%y`
dest=/home/${SrvUser}/wg/backup/w0conf-${BACKUPTIME}.tar
sudo tar -cf $dest /etc/wireguard/wg0.conf /home/${SrvUser}/wg/clients /home/${SrvUser}/wg/keys

