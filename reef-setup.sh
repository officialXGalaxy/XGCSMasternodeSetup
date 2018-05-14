#!/bin/bash
# ITIS.Network Masternode Setup Script V1.3 for Ubuntu 16.04 LTS
# (c) 2018 by Dwigt007 for ITIS.Network
#
# Script will attempt to autodetect primary public IP address
# and generate masternode private key unless specified in command line
#
# Usage:
# bash itis-setup.sh [Masternode_Private_Key]
#
# Example 1: Existing genkey created earlier is supplied
# bash itis-setup.sh 27dSmwq9CabKjo2L3UD1HvgBP3ygbn8HdNmFiGFoVbN1STcsypy
#
# Example 2: Script will generate a new genkey automatically
# bash itis-setup.sh
#

#Color codes
RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#ITIS TCP port
PORT=60222

#Clear keyboard input buffer
function clear_stdin { while read -r -t 0; do read -r; done; }

#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }

#Stop daemon if it's already running
function stop_daemon {
    if pgrep -x 'itisd' > /dev/null; then
        echo -e "${YELLOW}Attempting to stop itisd${NC}"
        itis-cli stop
        delay 30
        if pgrep -x 'itis' > /dev/null; then
            echo -e "${RED}itisd daemon is still running!${NC} \a"
            echo -e "${RED}Attempting to kill...${NC}"
            pkill itisd
            delay 30
            if pgrep -x 'itisd' > /dev/null; then
                echo -e "${RED}Can't stop itisd! Reboot and try again...${NC} \a"
                exit 2
            fi
        fi
    fi
}

#Process command line parameters
genkey=$1

clear
echo -e "
////////////////////////////////////+osyhdmNNMMMMMMMMMMNNmmhyys+////////////////////////////////////
//////////////////////////////+oydmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNdys+//////////////////////////////
//////////////////////////+shmMMMMMMMMMMMNmmdNMMMMMMMMMdmmNMMMMMMMMMMMNds+//////////////////////////
///////////////////////oymMMMMMMMMNmhyo+////yMMMMMMMMMMh////+oshdNMMMMMMMMmho///////////////////////
////////////////////+hNMMMMMMMmhs+/////////hMMMMMsoNMMMMd/////////+shmNMMMMMMNho////////////////////
//////////////////smMMMMMMNhs+////////////dMMMMNo//+NMMMMm+////////////shmMMMMMMmy//////////////////
///////////////+yNMMMMMNho//////////////+mMMMMN+////+mMMMMm+//////////////ohNMMMMMNh+///////////////
/////////////+hNMMMMMds+///////////////+mMMMMm+///////dMMMMNo////////////////odMMMMMNh+/////////////
////////////yNMMMMNdo/////////////////oNMMMMd//////////hMMMMNs/////////////////+hNMMMMNy////////////
//////////omMMMMMd+//////////////////sNMMMMh////////////yMMMMMy//////////////////+hNMMMMms//////////
/////////yNMMMMmo///////////////////yMMMMMh//////////////yMMMMMy///////////////////odMMMMMh/////////
///////+dMMMMNy////////////////////yMMMMMy////////////////sNMMMMh////////////////////sNMMMMmo///////
//////oNMMMMmo////////////////////hMMMMNs//////////////////oNMMMMd+///////////////////+dMMMMNs//////
/////oNMMMMd/////////////////////dMMMMNo////////////////////+mMMMMm+////////////////////hMMMMMs/////
////oNMMMMh////////////////////+mMMMMm+//////////////////////+mMMMMN+////////////////////yMMMMMs////
///+NMMMMh////////////////////+NMMMMm+/////////////////////////dMMMMNo////////////////////yMMMMNo///
///mMMMMd////////////////////oNMMMMd////////////////////////////hMMMMNs////////////////////hMMMMN///
//hMMMMm////////////////////sMMMMMMm+////////////////////////////yMMMMMy////////////////////dMMMMd//
/+MMMMMo///////////////////yMMMMMMMMNo////////////////////////////sNMMMMh///////////////////+MMMMMo/
/dMMMMd///////////////////hMMMMMmMMMMNo////////////////////////////oNMMMMd///////////////////yMMMMm/
/MMMMMo//////////////////dMMMMNo/hMMMMMs////////////////////////////+NMMMMm//////////////////+MMMMM+
yMMMMm//////////////////dMMMMN+///yMMMMMyoooooooooooooooooooooooooooosMMMMMm+/////////////////hMMMMh
dMMMMy////////////////+mMMMMm+/////sMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo////////////////sMMMMm
NMMMMo///////////////oNMMMMm////////oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo///////////////+MMMMM
MMMMM+//////////////oNMMMMd//////////+NMMMMMssssssssssssNMMMMNssssssssssshMMMMMs///////////////MMMMM
MMMMM+/////////////sMMMMMy////////////+mMMMMN+/////////mMMMMN+////////////sMMMMMy//////////////MMMMM
MMMMM+////////////yMMMMMy///////////////dMMMMNo//////+NMMMMm+//////////////sMMMMMd/////////////MMMMM
NMMMMo///////////hMMMMMs/////////////////hMMMMNs////oNMMMMd/////////////////oNMMMMd///////////+MMMMM
dMMMMy//////////dMMMMNo///////////////////yMMMMMy//sMMMMMh///////////////////+mMMMMm+/////////sMMMMm
sMMMMm////////+mMMMMN+/////////////////////sMMMMMhyMMMMMy/////////////////////+mMMMMN+////////dMMMMh
/MMMMMo//////+NMMMMm+///////////////////////oNMMMMMMMMMs////////////////////////dMMMMNo//////+MMMMM+
/hMMMMd/////oNMMMMd//////////////////////////oNMMMMMMNo//////////////////////////hMMMMMs/////hMMMMm/
/+MMMMMs///sNMMMMh////////////////////////////oMMMMMNo////////////////////////////yMMMMMy///oMMMMMo/
//yMMMMN+/yMMMMMy////////////////////////////+mMMMMm+//////////////////////////////sMMMMMh//mMMMMh//
///mMMMMdhMMMMMs////////////////////////////oNMMMMd+////////////////////////////////oNMMMMdhMMMMN///
///+NMMMMMMMMNo////////////////////////////sNMMMMh///////////////////////////////////oNMMMMMMMMNo///
////oNMMMMMMMMmmmmmmmmmmmmmmmmmmmmmmmmmmmmmMMMMMMmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmNMMMMMMMNs////
/////oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNs/////
//////+mMMMMMMmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmMMMMMMNo//////
///////+dMMMMMh+/////////////////////////////////////////////////////////////////////yMMMMMm+///////
/////////yNMMMMms//////////////////////////////////////////////////////////////////omMMMMNh/////////
//////////+dMMMMMdo//////////////////////////////////////////////////////////////odMMMMMmo//////////
////////////sNMMMMMdo//////////////////////////////////////////////////////////odMMMMMNy////////////
//////////////yNMMMMMmy+////////////////////////////////////////////////////+smMMMMMNh+/////////////
////////////////ymMMMMMNds////////////////////////////////////////////////ohNMMMMMNy+///////////////
//////////////////sdNMMMMMNdy+////////////////////////////////////////+sdNMMMMMNds//////////////////
////////////////////+ymMMMMMMMNdyo////////////////////////////////+shmMMMMMMMmy+////////////////////
///////////////////////+ydNMMMMMMMNmdhso+//////////////////+osydmNMMMMMMMMmyo///////////////////////
///////////////////////////oymNMMMMMMMMMMMNmmddddhhddddmmNMMMMMMMMMMMMmhs///////////////////////////
///////////////////////////////oshmNMMMMMMMMMMMMMMMMMMMMMMMMMMMMNmhyo///////////////////////////////
/////////////////////////////////////+syyhdmNNNMMMMMMMNNmmhhyso/////////////////////////////////////
"
delay 5
echo -e "${YELLOW}ITIS Masternode Setup Script V1.3 for Ubuntu 16.04 LTS${NC}"
echo -e "${GREEN}Updating system and installing required packages...${NC}"
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y

# Determine primary public IP address
dpkg -s dnsutils 2>/dev/null >/dev/null || sudo apt-get -y install dnsutils
publicip=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [ -n "$publicip" ]; then
    echo -e "${YELLOW}IP Address detected:" $publicip ${NC}
else
    echo -e "${RED}ERROR: Public IP Address was not detected!${NC} \a"
    clear_stdin
    read -e -p "Enter VPS Public IP Address: " publicip
    if [ -z "$publicip" ]; then
        echo -e "${RED}ERROR: Public IP Address must be provided. Try again...${NC} \a"
        exit 1
    fi
fi

# update packages and upgrade Ubuntu
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y install wget nano htop jq
sudo apt-get -y install libzmq3-dev
sudo apt-get -y install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get -y install libevent-dev

sudo apt -y install software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get -y update
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev

sudo apt-get -y install libminiupnpc-dev

sudo apt-get -y install fail2ban
sudo service fail2ban restart

sudo apt-get install ufw -y
sudo apt-get update -y

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow $PORT/tcp
sudo ufw allow 20025/tcp
sudo ufw allow 22/tcp
sudo ufw limit 22/tcp
echo -e "${YELLOW}"
sudo ufw --force enable
echo -e "${NC}"

#Generating Random Password for itisd JSON RPC
rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#Create 2GB swap file
if grep -q "SwapTotal" /proc/meminfo; then
    echo -e "${GREEN}Skipping disk swap configuration...${NC} \n"
else
    echo -e "${YELLOW}Creating 2GB disk swap file. \nThis may take a few minutes!${NC} \a"
    touch /var/swap.img
    chmod 600 swap.img
    dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
    mkswap /var/swap.img 2> /dev/null
    swapon /var/swap.img 2> /dev/null
    if [ $? -eq 0 ]; then
        echo '/var/swap.img none swap sw 0 0' >> /etc/fstab
        echo -e "${GREEN}Swap was created successfully!${NC} \n"
    else
        echo -e "${RED}Operation not permitted! Optional swap was not created.${NC} \a"
        rm /var/swap.img
    fi
fi

 #Installing Daemon
 cd ~
 #add git binaries here
 
 stop_daemon
 
 # Deploy binaries to /usr/bin
 sudo cp ItisMasternodeSetup/itis-linux-cli-v2.0.0.1/itis* /usr/bin/
 sudo chmod 755 -R ~/ItisMasternodeSetup
 sudo chmod 755 /usr/bin/itis*
 
 # Deploy masternode monitoring script
 cp ~/ItisMasternodeSetup/nodemon.sh /usr/local/bin
 sudo chmod 711 /usr/local/bin/nodemon.sh
 
 #Create itis datadir
 if [ ! -f ~/.itis/itis.conf ]; then 
 	sudo mkdir ~/.itis
 fi

echo -e "${YELLOW}Creating itis.conf...${NC}"

# If genkey was not supplied in command line, we will generate private key on the fly
if [ -z $genkey ]; then
    cat <<EOF > ~/.itis/itis.conf
rpcuser=itisrpc
rpcpassword=$rpcpassword
EOF

    sudo chmod 755 -R ~/.itis/itis.conf

    #Starting daemon first time just to generate masternode private key
    itisd -daemon
    delay 30

    #Generate masternode private key
    echo -e "${YELLOW}Generating masternode private key...${NC}"
    genkey=$(itis-cli masternode genkey)
    if [ -z "$genkey" ]; then
        echo -e "${RED}ERROR: Can not generate masternode private key.${NC} \a"
        echo -e "${RED}ERROR: Reboot VPS and try again or supply existing genkey as a parameter.${NC}"
        exit 1
    fi
    
    #Stopping daemon to create isis.conf
    stop_daemon
    delay 30
fi

# Create itis.conf
cat <<EOF > ~/.itis/itis.conf
rpcuser=itisrpc
rpcpassword=$rpcpassword
rpcallowip=127.0.0.1
onlynet=ipv4
rpcport=20025
listen=1
server=1
daemon=1
maxconnections=64
externalip=$publicip
masternode=1
masternodeprivkey=$genkey
addnode=45.76.85.193
addnode=85.214.230.101
addnode=104.238.188.93
addnode=140.82.37.169
addnode=45.32.183.12
addnode=107.191.58.32
addnode=207.218.118.8
addnode=81.177.166.101
addnode=185.203.243.243
addnode=62.77.156.207
addnode=95.84.138.69
addnode=5.135.76.216
addnode=144.202.83.84
addnode=185.26.28.154
EOF

#Finally, starting itis daemon with new itis.conf
itisd
delay 5

#Setting auto start cron job for itisd
cronjob="@reboot sleep 30 && itisd"
crontab -l > tempcron
if ! grep -q "$cronjob" tempcron; then
    echo -e "${GREEN}Configuring crontab job...${NC}"
    echo $cronjob >> tempcron
    crontab tempcron
fi
rm tempcron

echo -e "========================================================================
${YELLOW}Masternode setup is complete!${NC}
========================================================================
Masternode was installed with VPS IP Address: ${YELLOW}$publicip${NC}
Masternode Private Key: ${YELLOW}$genkey${NC}
Now you can add the following string to the masternode.conf file
for your Hot Wallet (the wallet with your Itis.Network collateral funds):
======================================================================== \a"
echo -e "${YELLOW}mn1 $publicip:$PORT $genkey TxId TxIdx${NC}"
echo -e "========================================================================
Use your mouse to copy the whole string above into the clipboard by
tripple-click + single-click (Dont use Ctrl-C) and then paste it 
into your ${YELLOW}masternode.conf${NC} file and replace:
    ${YELLOW}mn1${NC} - with your desired masternode name (alias)
    ${YELLOW}TxId${NC} - with Transaction Id from masternode outputs
    ${YELLOW}TxIdx${NC} - with Transaction Index (0 or 1)
     Remember to save the masternode.conf and restart the wallet!
To introduce your new masternode to the Itis network, you need to
issue a masternode start command from your wallet, which proves that
the collateral for this node is secured."

clear_stdin
read -p "*** Press any key to continue ***" -n1 -s

echo -e "1) Wait for the node wallet on this VPS to sync with the other nodes
on the network. Eventually the 'Is Synced' status will change
to 'true', which will indicate a comlete sync, although it may take
from several minutes to several hours depending on the network state.
Your initial Masternode Status may read:
    ${YELLOW}Node just started, not yet activated${NC} or
    ${YELLOW}Node  is not in masternode list${NC}, which is normal and expected.
2) Wait at least until 'IsBlockchainSynced' status becomes 'true'.
At this point you can go to your wallet and issue a start
command by either using Debug Console:
    Tools->Debug Console-> enter: ${YELLOW}masternode start-alias mn1${NC}
    where ${YELLOW}mn1${NC} is the name of your masternode (alias)
    as it was entered in the masternode.conf file
    
or by using wallet GUI:
    Masternodes -> Select masternode -> RightClick -> ${YELLOW}start alias${NC}
Once completed step (2), return to this VPS console and wait for the
Masternode Status to change to: 'Masternode successfully started'.
This will indicate that your masternode is fully functional and
you can celebrate this achievement!
Currently your masternode is syncing with the Itis network...
The following screen will display in real-time
the list of peer connections, the status of your masternode,
node synchronization status and additional network and node stats.
"
clear_stdin
read -p "*** Press any key to continue ***" -n1 -s

echo -e "
${GREEN}...scroll up to see previous screens...${NC}
Here are some useful commands and tools for masternode troubleshooting:
========================================================================
To view masternode configuration produced by this script in methuselah.conf:
${YELLOW}cat ~/.methuselah/methuselah.conf${NC}
Here is your itis.conf generated by this script:
-------------------------------------------------${YELLOW}"
cat ~/.itis/itis.conf
echo -e "${NC}-------------------------------------------------
NOTE: To edit itis.conf, first stop the itisd daemon,
then edit the itis.conf file and save it in nano: (Ctrl-X + Y + Enter),
then start the itisd daemon back up:
             to stop:   ${YELLOW}itis-cli stop${NC}
             to edit:   ${YELLOW}nano ~/.itis/itis.conf${NC}
             to start:  ${YELLOW}itisd${NC}
========================================================================
To view Itis debug log showing all MN network activity in realtime:
             ${YELLOW}tail -f ~/.itis/debug.log${NC}
========================================================================
To monitor system resource utilization and running processes:
                   ${YELLOW}htop${NC}
========================================================================
To view the list of peer connections, status of your masternode, 
sync status etc. in real-time, run the nodemon.sh script:
                 ${YELLOW}nodemon.sh${NC}
or just type 'node' and hit <TAB> to autocomplete script name.
========================================================================
Enjoy your Itis Masternode and thanks for using this setup script!

If you found this script useful, please donate to : i5tTc1KpuSpwagAKBnJajKfVe1FRmD7Hry
...and make sure to check back for updates!
Authors: Allroad [fasterpool] , Dwigt007
"
delay 30
# Run nodemon.sh
nodemon.sh

# EOF
