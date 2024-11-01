#!/bin/bash

COMMAND="`/bin/qs $@`"

if [ "$COMMAND" ]; then
    echo "$COMMAND" | grep -v "StartupCheck.sh"
fi
