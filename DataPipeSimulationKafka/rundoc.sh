#!/bin/bash
set -o errexit
set -o pipefail
echo $(pwd)
if [ -z "$DOCKER_IP" ]
then
  echo Please provide the address of your docker machine in \$DOCKER_IP
  exit 1
else
  echo $DOCKER_IP
fi

echo "starting python consumer"
docker run --label=unittest --name kafka_consume_python_2 -i -e DOCKER_IP=kafka -v /$(pwd):/$(pwd) --link kafka:kafka assn3_py sh -c "python $(pwd)/kafka_python/hello-kafka-consumer2.py"
###docker run -i -e DOCKER_IP=kafka -v $(pwd):$(pwd) --link kafka:kafka assn3_py sh -c "python $(pwd)/kafka_python/hello-kafka-consumer2.py"

