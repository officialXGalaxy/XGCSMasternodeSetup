#!/bin/bash
# XGalaxy Restart Script
# (c) 2018 by npq7721 for node cheker 
#
# Usage:
# bash node-checker.sh [begin coin command] [data_dir]
#

echo "execute $1 getblockcount to ping node availability"
count="$(${1}-cli getblockcount)"
echo "$count"
if ! [[ "$count" =~ ^[0-9]+$ ]]
    then
        pid="$(cat $2/*.pid)"
        echo "$pid"
        kill -9 $pid
        sleep 30
        ${1}d -daemon -index
fi
# EOF
