#!/bin/bash

GITHUB_API_KEY=""
GIST_ID=""


while true
do
    GIST=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_API_KEY}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/gists/${GIT_ID})

    
    sleep 1
done