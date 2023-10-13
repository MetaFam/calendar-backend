#!/bin/bash
source ~/.bashrc

HEADER='\033[95m'
OKBLUE='\033[94m'
OKCYAN='\033[96m'
OKGREEN='\033[92m'
WARNING='\033[93m'
FAIL='\033[91m'
ENDC='\033[0m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
SLATE='\033[38;2;112;128;144m'
GRAY='\033[38;2;128;128;128m'
DARK_GRAY='\033[38;2;68;68;68m'
PINK='\033[38;2;255;20;147m'

echo -e "${HEADER}Deploying the stuff...${ENDC}"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 18

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
echo -e "${OKCYAN}cd into $SCRIPT_DIR ...${ENDC}"
cd $SCRIPT_DIR

echo -e "${OKGREEN}Sourcing .env ...${ENDC}"
source $SCRIPT_DIR/.env

# Checkout to main branch
git checkout main

# Pull the latest code
echo -e "${OKBLUE}Pulling the latest code...${ENDC}"

git fetch && OUTPUT=$(git pull origin main)

# Check if pnpm is installed
echo -e "${GRAY}Checking if pnpm is installed and install if not...${ENDC}"
if ! command -v pnpm &> /dev/null; then
    echo -e "${WARNING}pnpm not found! Installing...${ENDC}"
    sudo npm install -g pnpm
    if [ $? -ne 0 ]; then
        echo -e "${FAIL}Failed to install pnpm. Exiting.${ENDC}"
        exit 1
    fi
    echo -e "${OKGREEN}pnpm installed successfully.${ENDC}"
else
    echo -e "${OKGREEN}pnpm is already installed.${ENDC}"
fi

# Install dependencies
echo -e "${PINK}Installing dependencies...${ENDC}"
pnpm install

# Check if there were changes
if [[ $OUTPUT != *"Already up to date."* ]]; then
    echo -e "${OKBLUE}Restarting server...${ENDC}"
    cd $HOME && pm2 restart ecosystem.config.js --only metagame-api

    # Sleep for a few seconds to give the server time to start
    sleep 5

    # Check server status
    if pm2 list | grep "metagame-api" | grep -q "online"; then
        echo -e "${OKGREEN}Server restarted successfully.${ENDC}"
    else
        echo -e "${FAIL}Server failed to start.${ENDC}"
    fi
else
    echo -e "${OKGREEN}No changes detected. Server restart not required.${ENDC}"
fi

# Exit
echo -e "${OKGREEN}Done.${ENDC}"
