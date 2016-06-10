#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ../..
export adirExamples=$(pwd)
popd > /dev/null

export LOG=/dev/null
#export LOG=$adirExamples/test.log

if [ ! -e "$HOME/.uwbd2/config" ]
then
	echo "could not find required configuration at: $HOME/.uwbd2/config" 1>&2
	exit 1
fi

. "$HOME/.uwbd2/config"

if ! docker ps &> /dev/null
then
	echo "Could not find the docker engine.  Did you forget to run this?" 1>&2
	echo "" 1>&2
	echo "    eval \$(docker-machine env $vmUwbd)" 1>&2
	exit 1
fi

if [ -z "$DOCKER_IP" ]
then
	export DOCKER_IP=$(docker-machine ip $vmUwbd)
fi

docker ps --filter 'label=unittest' | cut -c1-12 | tail -n+2 | xargs -L1 "$adirExamples/assignment3/bin/docker-rm.sh" 

bash $adirExamples/bats/libexec/bats $adirExamples/assignment3/test/testKafkaInfrastructurePart1.sh

bash kafka_infrastructure/deploy/restart.sh >> "$LOG"
sleep 3
docker run --label=unittest -i --link zookeeper:zookeeper --link kafka:kafka assn3_confluent_tools //usr/bin/kafka-topics  --zookeeper zookeeper --list
sleep 2
docker run \
	-v //var/run/docker.sock://var/run/docker.sock \
	-v "/$adirVmHome/.docker://root/.docker" \
	-v "/$adirVmHome/.uwbd2://root/.uwbd2" \
	-v "/$adirVmHome:/$adirVmHome" \
	-e DOCKER_IP=$DOCKER_IP \
	-e "LOG=/$LOG" \
	-e "WD=/$(pwd)" \
	assn3_docker-build \
	bash -c "/$adirExamples/bats/libexec/bats /$adirExamples/assignment3/test/testKafkaInfrastructurePart2.sh"
bash kafka_infrastructure/deploy/stop.sh >> "$LOG"

docker ps --filter 'label=unittest' | cut -c1-12 | tail -n+2 | xargs -L1 "$adirExamples/assignment3/bin/docker-rm.sh" 
