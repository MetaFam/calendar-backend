#!/bin/bash
source ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 18

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
echo "cd into $SCRIPT_DIR ..."
cd $SCRIPT_DIR


echo "Sourcing .env ..."
source $SCRIPT_DIR/.env

# env > $SCRIPT_DIR/packages/frontend/debug_env.log

# Checkout to main branch
git checkout main

# Pull the latest code
echo "Pulling the latest code..."
git fetch && git pull origin main

# Check if pnpm is installed
echo "Checking if pnpm is installed and install if not..."
if ! command -v pnpm &> /dev/null; then
    echo "pnpm not found! Installing..."
    sudo npm install -g pnpm
    if [ $? -ne 0 ]; then
        echo "Failed to install pnpm. Exiting."
        exit 1
    fi
    echo "pnpm installed successfully."
else
    echo "pnpm is already installed."
fi

# # Install dependencies
echo "Installing dependencies..."
pnpm install

# echo "Operating inside pwd $PWD ..."

# # Run the build command
# echo "Building the frontend..."
# pnpm frontend:build

# # Deploy to Fleek
# echo "Deploying to Fleek..."
# pnpm frontend:deploy

# Exit
echo "Done."
