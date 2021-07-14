#!/bin/bash

BASE_DIRECTORY="/usr/local/software/kafka"
DEFAULT_CONFIG_FILE="/usr/local/software/kafka/scripts/broker.default.properties"
TARGET_CONFIG_FILE="/usr/local/software/kafka/config/broker.izzy.properties"
COMMAND="KAFKA"

# Generate the configuration file based on the current environment variables
# Override any pre-existing configuration files
function generate_configs {
  echo ""
  echo "Generating Configuration files"
  echo ""
  $BASE_DIRECTORY/scripts/generate-configs.py -c $COMMAND -t $TARGET_CONFIG_FILE -d $DEFAULT_CONFIG_FILE
}

## Checks if the process.roles, node.id and cluster.id variables are set for KRaft Mode
## If this is true, we need to format the storage directories
function kafka_format_storage_directory {

  if [ "x$KAFKA_PROCESS_ROLES" != "x" ] && [ "x$KAFKA_NODE_ID" != "x" ] && [ "x$KAFKA_CLUSTER_ID" != "x" ]; then
    echo ""
    echo "Running in KRaft Mode without Zookeeper"
    echo "Storage Directory needs to be formatted using Cluster Identifier in Environment Variable"
    echo ""
    echo ""
    $BASE_DIRECTORY/bin/kafka-storage.sh format --ignore-formatted -t "${KAFKA_CLUSTER_ID}" -c "$TARGET_CONFIG_FILE"
    echo ""
    echo ""
  elif [ "x$KAFKA_PROCESS_ROLES" != "x" ] && [ "x$KAFKA_NODE_ID" != "x" ] && [ "x$KAFKA_CLUSTER_ID" = "x" ]; then
    echo ""
    echo "KAFKA_CLUSTER_ID environment variable cannot be empty for KRaft mode"
    echo "Use the ./kafka-storage.sh random-uuid command to generate a cluster id guid"
    echo "Then set the KAFKA_CLUSTER_ID environment variable to this value"
    echo ""
    exit 1
  elif [ "x$KAFKA_PROCESS_ROLES" != "x" ] && [ "x$KAFKA_NODE_ID" = "x" ]; then
    echo ""
    echo "KAFKA_NODE_ID environment variable cannot be empty for KRaft mode"
    echo "Please set the KAFKA_NODE_ID environment variable to a non-negative integer"
    echo ""
    exit 2
  else
    echo ""
    echo "Not running in KRaft Mode"
    echo "Kafka Broker Running in Legacy Mode with Zookeeper"
    echo ""
    echo ""
  fi
}

function startup_kafka_node {
  echo ""
  echo "Starting Up Kafka Node"
  $BASE_DIRECTORY/bin/kafka-server-start.sh $TARGET_CONFIG_FILE
  echo ""
  echo ""
}

# Step 1: Generate the configuration files
generate_configs

# Step 2: (Optional) - format the storage directory if we are running in KRaft Mode
kafka_format_storage_directory

# Step 3: Start up the Kafka Node
startup_kafka_node
