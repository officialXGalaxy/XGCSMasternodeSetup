#!/bin/bash
# XGalaxy Masternode Setup Script V1.4 for Ubuntu 16.04 LTS
# (c) 2018 by npq7721 for XGalaxy Coin
#
# Script will attempt to autodetect primary public IP address
# and generate masternode private key unless specified in command line
#
# Usage:
# bash uninstall.sh 
#
#Clear keyboard input buffer
function clear_stdin { while read -r -t 0; do read -r; done; }

#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1...${NC}"; sleep "$1"; }

#Stop daemon if it's already running
function stop_daemon {
    if pgrep -x 'xgalaxyd' > /dev/null; then
        echo -e "${YELLOW}Attempting to stop xgalaxyd${NC}"
        xgalaxy-cli stop
        delay 30s
        if pgrep -x 'xgalaxy' > /dev/null; then
            echo -e "${RED}xgalaxyd daemon is still running!${NC} \a"
            echo -e "${RED}Attempting to kill...${NC}"
            pkill -9 xgalaxyd
            delay 30s
            if pgrep -x 'xgalaxyd' > /dev/null; then
                echo -e "${RED}Can't stop xgalaxyd! Reboot and try again...${NC} \a"
                exit 2
            fi
        fi
        rm ~/.xgalaxycore/
    fi
}

  stop_daemon
sudo rm -rf /usr/bin/xgalaxy*
echo -e "xgalaxy is uninstall and removed"
