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

# Start Zookeeper in background
printf "${GREEN}${emoji_begin} Starting Zookeeper...${RESET}\n"
nohup bin/zookeeper-server-start.sh config/zookeeper.properties > zookeeper.log 2>&1 &
sleep 5 # Wait for Zookeeper to start

# Start Kafka Server
printf "${GREEN}${emoji_begin} Starting Kafka Server...${RESET}\n"
nohup bin/kafka-server-start.sh config/server.properties > kafka.log 2>&1 &
sleep 5 # Wait for Kafka Server to start

## Create Kafka topic
#printf "Creating topic: $TOPIC_NAME"
#bin/kafka-topics.sh --create --topic "$TOPIC_NAME" --bootstrap-server "$IP_ADDRESS:9092" --replication-factor 1 --partitions 1

# Start Kafka Producer
printf "${GREEN}${emoji_begin} Starting Kafka Producer...${RESET}\n"
nohup bin/kafka-console-producer.sh --topic "$TOPIC_NAME" --bootstrap-server "$IP_ADDRESS:9092" > producer.log 2>&1 &
sleep 5 # Wait for Kafka Producer to start

# Start Kafka Consumer
printf "${GREEN}${emoji_begin} Starting Kafka Consumer...${RESET}\n"
#nohup bin/kafka-console-consumer.sh --topic "$TOPIC_NAME" --bootstrap-server "$IP_ADDRESS:9092" --from-beginning > producer.log 2>&1 &
nohup bin/kafka-console-consumer.sh --topic "$TOPIC_NAME" --bootstrap-server "$IP_ADDRESS:9092" > consumer.log 2>&1 &
sleep 5 # Wait for Kafka Consumer to start

printf "\n===============================\n\n"
printf "${CYAN}All services have been started.\n"
printf "Topic\t\t: ${TOPIC_NAME}\n"
printf "IP Address\t: ${IP_ADDRESS}\n"
printf "ZooKeeper log\t: zookeeper.log\n"
printf "Kafka log\t: kafka.log\n"
printf "Producer log\t: producer.log\n"
printf "Consumer log\t: consumer.log ${RESET}\n"
