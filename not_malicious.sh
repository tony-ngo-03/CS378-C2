#!/bin/bash

PASTEBIN_DEV_API_KEY=""
PASTEBIN_USER_API_KEY=""
PASTEBIN_USER_NAME=""
PASTEBIN_USER_PASS=""


while true
do
    PASTE_LIST=$(curl -s -X POST \
    -d "api_dev_key=$API_DEV_KEY" \
    -d "api_user_key=$API_USER_KEY" \
    -d "api_option=list" \
    "https://pastebin.com/api/api_post.php")

    echo $PASTE_LIST
    sleep 1





