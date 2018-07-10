#!/bin/bash
# Reef Restart Script
# (c) 2018 by Dwigt007 for Reef 
#
# Usage:
# bash reef-setup.sh 
#

#Color codes
RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color



#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }

echo -e "${YELLOW}Reef Restart Script v0.1${NC}"

#KILL THE MFER
    reef-cli stop
    pkill reefd
    delay 20

#Delete .reecore contents 
echo -e "${YELLOW}Scrapping .reefcore...${NC}"
cd ~/.reefcore
rm -rf c* b* w* p* n* m* f* d* g*



#Restarting Daemon
    reefd -daemon
echo -ne '[##                 ] (15%)\r'
sleep 6
echo -ne '[######             ] (30%)\r'
sleep 6
echo -ne '[########           ] (45%)\r'
sleep 6
echo -ne '[##############     ] (72%)\r'
sleep 10
echo -ne '[###################] (100%)\r'
echo -ne '\n'

# EOF
