
## Kafka in a Box
A repository for generating artifacts and resources to run an Apache Kafka cluster on docker containers using vanilla Apache Kafka

## Building the Docker Images

```shell

docker build . -f Base.Dockerfile -t localbuild.io/kafka-base:1.0

docker build . -f Zookeeper.Dockerfile -t localbuild.io/zookeeper:1.0

docker build . -f Broker.Dockerfile -t localbuild.io/kafka:1.0

docker build . -f Connect.Dockerfile -t localbuild.io/connect:1.0

```


## Running the Containers in Docker Compose

### Running in Legacy Mode (With Zookeeper)

```shell

cd compose/legacy

docker-compose up 

```