#!/bin/bash
SrvUser=$1
BACKUPTIME=`date +%b-%d-%y`
dest=/home/${SrvUser}/wg/backups/w0conf-${BACKUPTIME}.tar
sudo tar -cf $dest /etc/wireguard/wg0.conf /home/${SrvUser}/wg/clients /home/${SrvUser}/wg/key

