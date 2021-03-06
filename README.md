
# Running Vanilla Apache Kafka (Docker Compose and Kubernetes)

## Outline
- [Building the Docker Images from Scratch](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#building-the-docker-images-from-scratch-if-you-want-to)
- [Running in Legacy Mode (With Zookeeper) on Docker Compose](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#running-in-legacy-mode-with-zookeeper)
- [Running in Apache Kafka 3.0 KRaft Mode (Single-Node Cluster) on Docker Compose](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#running-in-kraft-mode-single-node-cluster)
- [Running in Apache Kafka 3.0 KRaft Mode (Multi-Node Cluster) on Docker Compose](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#running-in-kraft-mode-multi-node-cluster)
- [Running Apache Kafka 3.0 on Kubernetes Locally](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#running-apache-kafka-30-on-kubernetes-locally)
- [Running Apache Kafka 3.0 on Kubernetes in Azure](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#running-in-the-cloud-via-azure-kubernetes-service)
- [Exploring the Clusters in Legacy Mode](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#commands-to-explore-the-cluster-in-legacy-mode)
- [Exploring the Clusters in KRaft Mode](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#commands-to-explore-the-cluster-in-kraft-mode)

### Building the Docker Images from Scratch (if you want to)

Once the repository has been checked out, if you would like to build the images yourself and customize it to your linking, you can build the Docker images and have them ready for use.

If you are building your own images, please make sure to update the Docker Compose files accordingly to use your own image names.


```bash

# Builds the base image
docker build . -f Base.Dockerfile -t apache.org/kafka-base:3.0

# Creates the Docker image for Zookeeper
docker build . -f Zookeeper.Dockerfile -t apache.org/zookeeper:3.0

# Creates the Docker image for Kafka Brokers and Quorum Controllers
docker build . -f Broker.Dockerfile -t apache.org/kafka:3.0

# Creates the Docker image for Kafka Connect
docker build . -f Connect.Dockerfile -t apache.org/connect:3.0

```

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

## Running Apache Kafka 3.0 on Docker Compose

A repository for generating artifacts and resources to run an Apache Kafka cluster on docker containers using vanilla Apache Kafka

It uses the upstream Apache Kafka project with very minimal adaptation to run them on containers.

The vanilla Apache Kafka artifacts are packaged into a container and environment variables are converted into configuration files that can be used to run the containers for 
- Zookeeper
- Kafka Broker
- Kafka Connect

It also containers docker compose scripts that allow you to run Apache Kafka 2.8.1 or 3.0.0 in both legacy mode (with Zookeeper) and KRaft mode (without Zookeeper)

To get started, simply clone the repository to your local machine and follow the steps to get in running in no time

You will need to have Docker installed locally to run the containers.

All the docker images used to run the cluster are built locally on your machine.

```bash

# get the git repository
git clone git@github.com:izzyacademy/kafka-in-a-box.git

# navigate to the code base
cd kafka-in-a-box

# switch to the 3.0.0 branch, you can also try out the 2.8.1 branch if you are interested in that version of Kafka
git checkout 3.0.0

```

If you would like to build the Docker images yourself, checkout the section below on building Docker images from scratch.

Otherwise, you can run the Docker Compose scripts AS-IS to use my latest build for Kafka 3.0.0

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

## Running the Containers in Docker Compose

The following sections describe how to run the docker images as Kafka clusters

The first section describes how to run a Kafka cluster in Zookeeper mode (legacy mode)

The second section describes how to run a single and multi-node cluster in KRaft mode (without Zookeeper)

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Running in Legacy Mode (With Zookeeper)

It provides a 3-node cluster that depends on Zookeeper

- Zookeeper Instance
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

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Running in KRaft Mode (Single-Node Cluster)

This setup creates a single node cluster that runs without Zookeeper

```shell

cd compose/kraft

# Deploys a simple single-node cluster in KRaft Mode
docker-compose up

# Shuts down the containers
docker-compose down --remove-orphans
```

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Running in KRaft Mode (Multi-Node Cluster)

This deploys a multi-node cluster in KRaft mode (without Zookeeper)

- Node 1 (Controller)
- Node 2 (Broker)
- Node 3 (Controller, Broker)
- Node 4 (Controller, Broker)

This provides 3 controller nodes and 3 broker nodes (6-nodes altogether)

Which ends up looking like this when you expand it:

- Node 1 (Controller)
- Node 2 (Broker)
- Node 3 (Controller)
- Node 3 (Broker)
- Node 4 (Controller)
- Node 4 (Broker)

It also has a debugger docker container that you can log in to explore the cluster

Running the following commands allow you to boot up the cluster

```shell

cd compose/kraft

# Deploys a multi-node cluster in KRaft Mode
docker-compose --env-file ./environment-variables.sh -f multi-node-docker-compose.yml up

# Shuts down the containers
docker-compose --env-file ./environment-variables.sh -f multi-node-docker-compose.yml down --remove-orphans

```

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Commands to Explore the Cluster in Legacy Mode

These commands are primarily for exploring the cluster in Legacy mode with Zookeeper.

```bash
# Log on to NodeId=2
docker exec -it broker2 /bin/bash

# Navigate to the directory
cd /usr/local/software/kafka/bin


./kafka-log-dirs.sh --describe --bootstrap-server localhost:9092

./kafka-broker-api-versions.sh --bootstrap-server localhost:9092

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic citypopulation --partitions 1 --replication-factor 1

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic countrypopulation --partitions 2 --replication-factor 1

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic worldcapitals --partitions 3 --replication-factor 2

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic uscapitals --partitions 3 --replication-factor 5

./kafka-topics.sh --bootstrap-server localhost:9092 --list

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic uscapitals

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic worldcapitals

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic countrypopulation

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic citypopulation

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

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Commands to Explore the Cluster in Kraft Mode

These commands are primarily for exploring the cluster in KRaft mode without Zookeeper.

However, you can also use the syntax for creating topics to interact with clusters in legacy mode.

```bash
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

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic uscapitals

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic worldcapitals

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic countrypopulation

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic citypopulation

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
[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

## Running Apache Kafka 3.0 on Kubernetes Locally

Running on Kubernetes is very similar to running on Docker Hub expect that the set up instructions are slightly different.

Directions for setting up your Kubernetes environment is available [here](kubernetes/setting-up-the-cluster/README.md)

Then we can navigate to the kubernetes/helm-charts folder to start installing our cluster components.

Note that the hostnames within the Kubernetes cluster (using Cluster IP addresses) are different from the experience in Docker Compose

For local set up we use the desktop charts and for the Cloud, we can use the azure-cloud charts.

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Create the Kubernetes Namespace

Run the following command to create the namespace for our resources. This is a pre-requisite before any of the components are installed.

```bash

cd kubernetes/helm-charts

kubectl create ns river 

```

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Setting up Kafka Cluster in Legacy Mode (with Zookeeper)

```bash

# Run the following command to set up Zookeeper
helm upgrade --install river-zookeeper ./desktop --set zookeeper.enabled=true

# Wait for Zookeeper to be ready before you install the brokers
helm upgrade --install river-broker ./desktop --set legacy.enabled=true

# To attach to one of the broker containers within Kubernetes, you can use the following kubectl command
kubectl -n river exec deploy/broker2 -it -- bash 

# To find out about the defined services, run this command:
kubectl -n river get svc

# To tear down the cluster run the following commands
helm uninstall river-zookeeper river-broker

```

Once inside the Kubernetes cluster, you can use any of the defined services to reach any of the brokers/controllers in the cluster.

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Setting up Kafka Cluster in KRaft Mode (without Zookeeper)

```bash

# Setting up Zookeeper is NOT necessary in KRaft Mode
helm upgrade --install river-zookeeper ./desktop --set zookeeper.enabled=false

# Hence, we do NOT have to Wait for Zookeeper to be ready before we install the brokers
helm upgrade --install river-broker ./desktop --set kraft.enabled=true 

# To attach to one of the broker containers within Kubernetes, you can use the following kubectl command
kubectl -n river exec deploy/node2 -it -- bash

# To find out about the defined services, run this command:
kubectl -n river get svc

# To tear down the cluster run the following commands
helm uninstall river-zookeeper river-broker

```

Once inside the Kubernetes cluster, you can use any of the defined services to reach any of the brokers/controllers in the cluster.

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Running in the Cloud via Azure Kubernetes Service 

You can use the Azure Cloud Shell to run the following commands without having to set up any of the clients locally. That is the beauty of doing it in the cloud.

Once your Azure Kubernetes Service cluster has been set up, please follow the steps below to set it up locally.

Directions for setting up your Kubernetes environment is available [here](kubernetes/setting-up-the-cluster/README.md)

After your cluster is setup you can use [Azure Cloud Shell](https://shell.azure.com/) at [shell.azure.com](https://shell.azure.com/) to interact with the cluster to install vanilla Apache Kafka 3.0 on the Azure Kubernetes Service.

The primary differences between running it locally and running it on Azure is that in the local environment we are not using persistent volumes and cloud provided load balancers. The cloud version uses Azure Disks to persist the data across container restarts and leverages the internal Azure Load balancers to expose the services to clients. On the other hand, the local version uses NodePort services to expose the services to clients and does not use persistent volumes to store the broker data and metadata.

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Create the Kubernetes Namespace

Run the following command to create the namespace for our resources. This is a pre-requisite before any of the components are installed.

```bash

cd kubernetes/helm-charts

kubectl create ns river 

```
[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Setting up Kafka Cluster in Legacy Mode (with Zookeeper)

```bash

# Run the following command to set up Zookeeper
helm upgrade --install river-zookeeper ./azure-cloud --set zookeeper.enabled=true

# Wait for Zookeeper to be ready before you install the brokers
helm upgrade --install river-broker ./azure-cloud --set legacy.enabled=true

# To attach to one of the broker containers within Kubernetes, you can use the following kubectl command
kubectl -n river exec deploy/broker2 -it -- bash 

# To find out about the defined services, run this command:
kubectl -n river get svc

# To tear down the cluster run the following commands
helm uninstall river-zookeeper river-broker

```

Once inside the Kubernetes cluster, you can use any of the defined services to reach any of the brokers/controllers in the cluster.

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)

### Setting up Kafka Cluster in KRaft Mode (without Zookeeper)

```bash

# Setting up Zookeeper is NOT necessary in KRaft Mode
helm upgrade --install river-zookeeper ./azure-cloud --set zookeeper.enabled=false

# Hence, we do NOT have to Wait for Zookeeper to be ready before we install the brokers
helm upgrade --install river-broker ./azure-cloud --set kraft.enabled=true 

# To attach to one of the broker containers within Kubernetes, you can use the following kubectl command
kubectl -n river exec deploy/node2 -it -- bash

# To find out about the defined services, run this command:
kubectl -n river get svc

# To tear down the cluster run the following commands
helm uninstall river-zookeeper river-broker

```

Once inside the Kubernetes cluster, you can use any of the defined services to reach any of the brokers/controllers in the cluster.

[Return to the Top](https://github.com/izzyacademy/kafka-in-a-box/blob/main/README.md#outline)
