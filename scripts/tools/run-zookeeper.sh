#!/bin/bash

# Ensure the script stops if any command fails
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Emojis
emoji_begin='\U0001F680'
emoji_error='\U0001F4A5'
emoji_hint='\U0001F4A1'


# Start Zookeeper in background
printf "${GREEN}${emoji_begin} Starting Zookeeper...${RESET}\n"
nohup bin/zookeeper-server-start.sh config/zookeeper.properties
sleep 5 # Wait for Zookeeper to start