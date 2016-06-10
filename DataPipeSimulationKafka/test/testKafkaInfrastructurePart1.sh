#!/usr/bin/env bats

setup() {
#  . "$adirUtil/libexec/detectConfig.sh" "$adirUtil"
  . "$HOME/.uwbd2/config"
}

teardown() {
  echo -n
}

@test "setup and placebo test ok" {
  echo -n
  [ "" == "" ]
}

@test "found vmUwbd configuration" {
  echo -n
  [ "$vmUwbd" != "" ]
}

@test "found required tags for docker images" {
  docker inspect assn3_py
  docker inspect assn3_jre
  docker inspect assn3_zookeeper
  docker inspect assn3_kafka
  docker inspect assn3_confluent_tools
}

@test "kafka restart" {
  bash kafka_infrastructure/deploy/restart.sh
  sleep 5
  [ "$vmUwbd" != "" ]
}

@test "kafka topic create" {
  docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-topics  --zookeeper zookeeper --create --topic topicBogus --partitions 1 --replication-factor 1
}

@test "kafka topic delete" {
  docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-topics  --zookeeper zookeeper --delete --topic topicBogus
}

@test "kafka stop" {
  bash kafka_infrastructure/deploy/stop.sh
  [ "$vmUwbd" != "" ]
}

