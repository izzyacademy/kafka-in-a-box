#!/bin/bash

BASE_DIRECTORY="/usr/local/software/kafka"
DEFAULT_CONFIG_FILE="/usr/local/software/kafka/scripts/zookeeper.default.properties"
TARGET_CONFIG_FILE="/usr/local/software/kafka/config/zookeeper.izzy.properties"
COMMAND="ZOOKEEPER"

# Generate the configuration file based on the current environment variables
# Override any pre-existing configuration files
$BASE_DIRECTORY/scripts/generate-configs.py -c $COMMAND -t $TARGET_CONFIG_FILE -d $DEFAULT_CONFIG_FILE

$BASE_DIRECTORY/bin/zookeeper-server-start.sh $TARGET_CONFIG_FILE
