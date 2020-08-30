#!/usr/bin/env bash
if [[ $# -eq 0 ]] ; then
    echo 'COMMAND required as first argument. python3.6 ...'
    exit 0
fi

SCREEN_NAME=$1
SCREEN_CMD=$2

screen -X -S "$1" stuff "^C"
screen -X -S "$1" quit
screen -d -m -S $1
screen -S "$1" -p 0 -X stuff "$2$(printf \\r)"