#!/bin/bash
source ~/.bashrc

class TerminalColor:
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 18

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
echo -e "${TerminalColor.OKCYAN}cd into $SCRIPT_DIR ...${TerminalColor.ENDC}"
cd $SCRIPT_DIR

echo -e "${TerminalColor.OKGREEN}Sourcing .env ...${TerminalColor.ENDC}"
source $SCRIPT_DIR/.env

# Checkout to main branch
git checkout main

# Pull the latest code
echo -e "${TerminalColor.OKBLUE}Pulling the latest code...${TerminalColor.ENDC}"
git fetch && git pull origin main

# Check if pnpm is installed
echo -e "${TerminalColor.GRAY}Checking if pnpm is installed and install if not...${TerminalColor.ENDC}"
if ! command -v pnpm &> /dev/null; then
    echo -e "${TerminalColor.WARNING}pnpm not found! Installing...${TerminalColor.ENDC}"
    sudo npm install -g pnpm
    if [ $? -ne 0 ]; then
        echo -e "${TerminalColor.FAIL}Failed to install pnpm. Exiting.${TerminalColor.ENDC}"
        exit 1
    fi
    echo -e "${TerminalColor.OKGREEN}pnpm installed successfully.${TerminalColor.ENDC}"
else
    echo -e "${TerminalColor.OKGREEN}pnpm is already installed.${TerminalColor.ENDC}"
fi

# Install dependencies
echo -e "${TerminalColor.PINK}Installing dependencies...${TerminalColor.ENDC}"
pnpm install

# Run the build command
# echo -e "${TerminalColor.SLATE}Building the frontend...${TerminalColor.ENDC}"
# pnpm frontend:build

# Deploy to Fleek
# echo -e "${TerminalColor.DARK_GRAY}Deploying to Fleek...${TerminalColor.ENDC}"
# pnpm frontend:deploy

# Exit
echo -e "${TerminalColor.BOLD}Done.${TerminalColor.ENDC}"
