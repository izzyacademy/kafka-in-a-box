
# Kafka in a Box

A repository for generating artifacts and resources to run an Apache Kafka cluster on docker containers using vanilla Apache Kafka

It uses the upstream Apache Kafka project with very minimal adaptation to run them on containers.

The vanilla Apache Kafka artifacts are packaged into a container and environment variables are converted into configuration files that can be used to run the containers for 
- Zookeeper
- Kafka Broker
- Kafka Connect

It also containers docker compose scripts that allow you to run Apache Kafka 2.8.0 in both legacy mode (with Zookeeper) and KRaft mode (without Zookeeper)

To get started, simply clone the repository to your local machine and follow the steps to get in running in no time

You will need to have Docker installed locally to run the containers

```shell

git clone git@github.com:izzyacademy/kafka-in-a-box.git

cd kafka-in-a-box


```

## Building the Docker Images

Once the repository has been checked out, you can build the Docker images and have them ready for use

```shell

docker build . -f Base.Dockerfile -t localbuild.io/kafka-base:1.0

docker build . -f Zookeeper.Dockerfile -t localbuild.io/zookeeper:1.0

docker build . -f Broker.Dockerfile -t localbuild.io/kafka:1.0

docker build . -f Connect.Dockerfile -t localbuild.io/connect:1.0

```


## Running the Containers in Docker Compose

### Running in Legacy Mode (With Zookeeper)

It provides a 3-node cluster that depends on Zookeeper

- Node 1 (Broker)
- Node 2 (Broker)
- Node 3 (Broker)

```shell

cd compose/legacy

# Deploys a multi-node cluster using Zookeeper 
docker-compose up

# Shuts down containers
docker-compose down --remove-orphans

```


### Running in KRaft Mode (Single-Node Cluster)


```shell

cd compose/kraft

# Deploys a simple single-node cluster in KRaft Mode
docker-compose up

# Shuts down the containers
docker-compose down --remove-orphans
```

### Running in KRaft Mode (Multi-Node Cluster)

This deploys a multi-node cluster in KRaft mode
- Node 1 (Controller)
- Node 2 (Broker)
- Node 3 (Controller, Broker)
- Node 4 (Controller, Broker)

This provides 3 controller nodes and 3 broker nodes

It also has a debugger container that you can log in to explore the cluster

```shell

cd compose/kraft

# Deploys a multi-node cluster in KRaft Mode
docker-compose --env-file ./environment-variables.sh -f multi-node-docker-compose.yml up

# Shuts down the containers
docker-compose --env-file ./environment-variables.sh -f multi-node-docker-compose.yml down --remove-orphans

```

### Commands to Explore the Cluster

```shell
# Log on to NodeId=2
docker exec -it node2 /bin/bash

# Navigate to the directory
cd /usr/local/software/kafka/bin

./kafka-cluster.sh cluster-id --bootstrap-server localhost:9092

./kafka-log-dirs.sh --describe --bootstrap-server localhost:9092

./kafka-storage.sh info -c ../config/broker.izzy.properties

./kafka-broker-api-versions.sh --bootstrap-server localhost:9092

./kafka-metadata-shell.sh  --snapshot /tmp/kraft-logs/@metadata-0/00000000000000000000.log

# Then explore the following metadata, if present : brokers  local  metadataQuorum  topicIds  topics

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic citypopulation --partitions 1 --replication-factor 1

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic countrypopulation --partitions 2 --replication-factor 1

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic worldcapitals --partitions 3 --replication-factor 2

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic uscapitals --partitions 3 --replication-factor 5

./kafka-topics.sh --bootstrap-server localhost:9092 --list

./kafka-topics.sh --bootstrap-server localhost:9092 --describe uscapitals

./kafka-topics.sh --bootstrap-server localhost:9092 --describe worldcapitals

./kafka-topics.sh --bootstrap-server localhost:9092 --describe countrypopulation

./kafka-topics.sh --bootstrap-server localhost:9092 --describe citypopulation

./kafka-metadata-shell.sh  --snapshot /tmp/kraft-logs/@metadata-0/00000000000000000000.log

# Then explore the following metadata, if present : brokers  local  metadataQuorum  topicIds  topics

# Keys with numbers as the keys and the square roots as the value
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic freedomzone --property "parse.key=true" --property "key.separator=,"

64,Eight
100,Ten
4,Two
1,One

# https://www.britannica.com/topic/list-of-state-capitals-in-the-United-States-2119210

./kafka-console-producer.sh --broker-list localhost:9092 --topic uscapitals --property "parse.key=true" --property "key.separator=:"

Florida:Tallahasee
Georgia:Atlanta
Maine:Augusta
Hawaii:Hononulu

./kafka-console-consumer.sh --new-consumer --bootstrap-server localhost:9092 --topic uscapitals --property print.key=true --property key.separator=":" --from-beginning


```
