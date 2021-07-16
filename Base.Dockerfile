FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Defining variables for project artifacts - location, project version and scala versions
ENV PROJECT_DOWNLOAD_URL="https://downloads.apache.org/kafka/2.8.0"
ENV PROJECT_KAFKA_VERSION="2.8.0"
ENV PROJECT_SCALA_VERSION="2.12"

RUN apt-get update

RUN apt-get -y install aptitude vim curl wget gnupg python3-pip openjdk-11-jdk

RUN apt-get -y install inetutils-telnet inetutils-ping

# https://pypi.org/project/jproperties/
RUN pip install jproperties

RUN mkdir -p /usr/local/software

WORKDIR /usr/local/software

RUN wget "${PROJECT_DOWNLOAD_URL}/kafka_${PROJECT_SCALA_VERSION}-${PROJECT_KAFKA_VERSION}.tgz"

RUN tar -zxf "kafka_${PROJECT_SCALA_VERSION}-${PROJECT_KAFKA_VERSION}.tgz" && mv "kafka_${PROJECT_SCALA_VERSION}-${PROJECT_KAFKA_VERSION}" kafka

WORKDIR /usr/local/software/kafka

RUN mkdir -p /usr/local/software/kafka/scripts

COPY scripts/generate-configs.py /usr/local/software/kafka/scripts
COPY scripts/zookeeper.default.properties /usr/local/software/kafka/scripts
COPY scripts/broker.default.properties /usr/local/software/kafka/scripts
COPY scripts/connect.default.properties /usr/local/software/kafka/scripts

RUN chmod 0775 /usr/local/software/kafka/scripts/generate-configs.py

WORKDIR /usr/local/software/kafka/scripts

# This Docker image ends here
# in Zookeeper, Brokers and Connect Docker images:
# Copy over the python scripts and generate the configs for Zookeeper
# Start up Docker containers with Config settings using ENVIRONMENT VARIABLES

# docker build . -f Base.Dockerfile -t apache.org/kafka-base:1.0

# docker run --name kafkabase -it apache.org/kafka-base:1.0