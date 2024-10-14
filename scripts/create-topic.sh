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

# Parse the command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --topic) TOPIC_NAME="$2"; shift ;;
    --ip) IP_ADDRESS="$2"; shift ;;
    *) printf "${RED}${emoji_error} Unknown parameter passed: $1${RESET}\n" exit 1;;
  esac
  shift
done

# Check if both topic and IP are provided
if [ -z "$TOPIC_NAME" ] || [ -z "$IP_ADDRESS" ]; then
  printf "${YELLOW}${emoji_hint} Usage: ./run-all-services.sh --topic <topic_name> --ip <ip_address>${RESET}\n"
  exit 1
fi

# Create Kafka topic
printf "${GREEN}${emoji_begin} Creating topic: $TOPIC_NAME ${RESET}\n"
bin/kafka-topics.sh --create --topic "$TOPIC_NAME" --bootstrap-server "$IP_ADDRESS:9092" --replication-factor 1 --partitions 1

printf "\n===============================\n\n"

printf "${CYAN}Topic successfully created!\n"
printf "Topic\t\t: ${TOPIC_NAME}\n"
printf "IP Address\t: ${IP_ADDRESS}\n"