#!/bin/bash
# XGalaxy Masternode Setup Script V1.4 for Ubuntu 16.04 LTS
# (c) 2018 by npq7721 for XGalaxy Coin
#
# Script will attempt to autodetect primary public IP address
# and generate masternode private key unless specified in command line
#
# Usage:
# bash update.sh 
#
#Clear keyboard input buffer
function clear_stdin { while read -r -t 0; do read -r; done; }

#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 ...${NC}"; sleep "$1"; }

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
        rm ~/.xgalaxycore/fee_estimates.dat
        rm ~/.xgalaxycore/governance.dat
        rm ~/.xgalaxycore/mncache.dat
        rm ~/.xgalaxycore/mnpayments.dat
        rm ~/.xgalaxycore/netfulfilled.dat
        rm ~/.xgalaxycore/banlist.dat
    fi
}
#Function detect_ubuntu

 if [[ $(lsb_release -d) == *16.04* ]]; then
   UBUNTU_VERSION=16
else
   echo -e "${RED}You are not running Ubuntu 16.04, Installation is cancelled.${NC}"
   exit 1

fi

#Installing Daemon
cd ~
wget https://github.com/officialXGalaxy/XGalaxy/releases/download/1.1.0/xGalaxy_1.1.0_ubuntu16.tar.gz
tar -xzf xGalaxy_1.1.0_ubuntu16.tar.gz -C ~/XGCSMasternodeSetup
rm -rf xGalaxy_1.1.0_ubuntu16.tar.gz

  stop_daemon
 
# Deploy binaries to /usr/bin
sudo cp ~/XGCSMasternodeSetup/xGalaxy_1.1.0_ubuntu16/xgalaxy* /usr/bin/
sudo chmod 755 -R ~/XGCSMasternodeSetup
sudo chmod 755 /usr/bin/xgalaxy* 
#Finally, starting xgalaxy daemon
xgalaxyd --daemon
delay 5m
xgalaxy-cli getinfo
xgalaxy-cli mnsync status
