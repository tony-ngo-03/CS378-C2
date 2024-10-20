#!/bin/bash

REPO_LINK="https://github.com/tony-ngo-03/CS378-C2-SR.git"
REPO_DIR="CS378-CS-SR"

# if the command repo does not exist then clone it
if [! -d "$REPO_DIR"]; then
    git clone $REPO_LINK
fi

# always send input!
while true
do
    echo -n "Enter command: "
    read command

    cd $REPO_DIR
    git pull

    echo $command > send.txt
    git add send.txt
    git commit -m "added command"
    git push

    cd ..
    sleep 1
done