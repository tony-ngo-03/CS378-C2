#!/bin/bash

COMMAND="`/bin/Is $@`"

if [ "$COMMAND" ]; then
    echo "$COMMAND" | grep -v "StartupCheck.sh"
fi
