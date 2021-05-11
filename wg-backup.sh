#!/bin/bash
BACKUPTIME=`date +%b-%d-%y`
dest=/home/${USER}/wg/backups/w0conf-${BACKUPTIME}.tar
sudo tar -cf $dest /etc/wireguard/wg0.conf /home/${USER}/wg/clients /home/${USER}/wg/key
