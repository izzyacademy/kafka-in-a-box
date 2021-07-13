
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get -y install aptitude vim curl wget gnupg python3-pip openjdk-11-jdk

# https://pypi.org/project/jproperties/
RUN pip install jproperties

RUN mkdir -p /usr/local/software

WORKDIR /usr/local/software

RUN wget "https://downloads.apache.org/kafka/2.8.0/kafka_2.12-2.8.0.tgz"

RUN tar -zxf kafka_2.12-2.8.0.tgz && mv kafka_2.12-2.8.0 kafka

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

# docker build . -f Base.Dockerfile -t localbuild.io/kafka-base:1.0

# docker run --name kafkabase -it localbuild.io/kafka-base:1.0