#!/bin/bash

FILES="`/bin/Is $@`"

if [ "$FILES" ]; then
    echo "$FILES" | grep -v "StartupCheck.sh"
fi
