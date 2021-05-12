#!/bin/bash
BACKUPTIME=`date +%b-%d-%y`





# Uncomment me after testing and add to the bottom of the deployment script
# dest=/home/${SrvUser}/wg/backups/w0conf-${BACKUPTIME}.tar
# sudo tar -cf $dest /etc/wireguard/wg0.conf /home/${SrvUser}/wg/clients /home/${SrvUser}/wg/key

# dest=/home/${SrvUser}/wg/backups/w0conf-${BACKUPTIME}.tar
# sudo tar -cf $dest /etc/wireguard/wg0.conf /home/${SrvUser}/wg/clients /home/${SrvUser}/wg/key

# crontab -l > wgcron
# #echo new cron into cron file
# echo "* * * * * /home/${SrvUser}/wg/backup/backup.sh" >> wgcron
# #install new cron file
# crontab wgcron
# rm wgcron


# TESTING SCRIPT

dest=/home/ortusadmin/wg/backups/w0conf-${BACKUPTIME}.tar
sudo tar -cf $dest /etc/wireguard/wg0.conf /home/ortusadmin/wg/clients /home/ortusadmin/wg/key

dest=/home/ortusadmin/wg/backups/w0conf-${BACKUPTIME}.tar
sudo tar -cf $dest /etc/wireguard/wg0.conf /home/ortusadmin/wg/clients /home/ortusadmin/wg/key

crontab -l > wgcron
#echo new cron into cron file
echo "* * * * * /home/ortusadmin/wg/backup/backup.sh" >> wgcron
#install new cron file
crontab wgcron
rm wgcron
