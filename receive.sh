#!/bin/bash

REPO_LINK="https://github.com/tony-ngo-03/CS378-C2-SR.git"
REPO_DIR="CS378-CS-SR"

# if repo_directory is not found then clone it
if [! -d "$REPO_DIR"] ; then
    git clone $REPO_LINK
fi

# receiving loop every second
while true
do
    cd $REPO_DIR
    git pull
    input='recieve.txt'

    # constantly read the lines of the recieve.txt
    while IFS= read -r line
    do
        echo "$line"
    done < "$input"

    # TODO: add logic that if the input is empty then do not do any of this

    echo "" > receive.txt
    git add recieve.txt
    git commit -m "read output"
    git push
    cd ..

    sleep 1
done