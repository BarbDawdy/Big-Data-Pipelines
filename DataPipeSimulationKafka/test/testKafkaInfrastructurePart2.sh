#!/usr/bin/env bats

setup() {
#  . "$adirUtil/libexec/detectConfig.sh" "$adirUtil"
  cd "$WD"
  . "$HOME/.uwbd2/config"
  cTopics=$(docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-topics  --zookeeper zookeeper --list --topic topicNew | wc -l)
  echo found cTopics=$cTopics >> "$LOG"
  if expr $cTopics \> 0
  then
    echo deleting >> "$LOG"
    docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-topics  --zookeeper zookeeper --delete --topic topicNew
    sleep 1
    cTopicsAfter=$(docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-topics  --zookeeper zookeeper --list --topic topicNew | wc -l)
    echo found cTopicsAfter=$cTopicsAfter >> "$LOG"
  else
    echo not deleting >> "$LOG"
  fi
  docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-topics  --zookeeper zookeeper --create --topic topicNew --partitions 1 --replication-factor 1
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

### Provided: Topic manipulation:
@test "kafka topic list" {
  docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools ///usr/bin/kafka-topics  --zookeeper zookeeper --list
}

### Provided: Produce topic
@test "kafka produce from command line" {
  echo "hello" | docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-console-producer --broker-list kafka:9092 --topic topicNew
}

### Provided: Consume topic
@test "kafka consume from python" {
  run docker rm -f kafka_consume_python_1
  run rm -f /$(pwd)/kafka_python_out.log
  echo "starting python consumer" >> "$LOG"
  docker run --label=unittest --name kafka_consume_python_1 -i -e DOCKER_IP=kafka -v /$(pwd):/$(pwd) --link kafka:kafka assn3_py sh -c "python /$(pwd)/kafka_python/hello-kafka-consumer.py > /$(pwd)/kafka_python_out.log" &
  for i in {1..5}
  do
    echo "sending message i=$i" >> "$LOG"
    docker run --label=unittest --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools bash -c "echo -e 'hello\nhello\n' | //usr/bin/kafka-console-producer --broker-list kafka:9092 --topic topicNew"
    echo "sleeping" >> "$LOG"
    sleep 1
  done
  echo "docker rm" >> "$LOG"
  docker rm -f kafka_consume_python_1
  echo "testing success: $line1" >> "$LOG"
  line1=$(head -1 kafka_python_out.log)
  echo "line1=$line1 subst=${line1//hello/}" >> "$LOG"
  [ "${line1//hello/}" != "${line1}" ]
}

@test "kafka consume from scala" {
  run docker rm -f kafka_consume_scala_1
  run rm -f /$(pwd)/kafka_scala_out.log
  echo "starting scala consumer" >> "$LOG"
  docker run --label=unittest --name kafka_consume_scala_1 -i -v "/$(pwd):/$(pwd)" --link kafka:kafka assn3_jre sh -c "java -jar /$(pwd)/kafka_scala/kafka_consumer_eg-assembly-1.0.jar --brokers=kafka:9092  > /$(pwd)/kafka_scala_out.log" &
  for i in {1..5}
  do
    echo "sending message i=$i" >> "$LOG"
    docker run --label=unittest --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools bash -c "echo -e 'hello\nhello\n' | //usr/bin/kafka-console-producer --broker-list kafka:9092 --topic topicNew"
    echo "sleeping" >> "$LOG"
    sleep 1
  done
  run docker rm -f kafka_consume_scala_1
  echo "testing success: $line1" >> "$LOG"
  line1=$(head -1 kafka_scala_out.log)
  echo "line1=$line1 subst=${line1//hello/}" >> "$LOG"
  [ "${line1//hello/}" != "${line1}" ]
}
#

### Provided: The assignment 2 generator:
@test "Run the assignment 2 generator in docker" {
  docker run -i -v "/$(pwd):/$(pwd)" --label=unittest assn3_jre sh -c "java -jar /$(pwd)/storeInventoryGenerator/storeInventoryGenerator-assembly-1.0.jar"
}

@test "Pipe the assignment 2 generator into kafka" {
  docker run -i -v "/$(pwd):/$(pwd)" --label=unittest assn3_jre sh -c "java -jar /$(pwd)/storeInventoryGenerator/storeInventoryGenerator-assembly-1.0.jar" \
    | docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-console-producer --broker-list kafka:9092 --topic topicNew
}



