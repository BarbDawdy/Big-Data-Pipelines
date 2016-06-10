
#################################################################################
#
#  program - producer911.py
#  usage - this program expects the input JSON file is in the same directrory that the producer is run
#          json data is 911-rowsonly.json
#  note -  expected to be run in python version 2.x not tested in python 3.x
#
#  description - see https://gitlab2.bigdata220uw.mooo.com/dawdyb/Assignment4/tree/master
#
#  program based on http://kafka-python.readthedocs.io/en/master/usage.html
#
#################################################################################
import sys
import os
from kafka import KafkaProducer
from kafka.errors import KafkaError
import json

producer = KafkaProducer(bootstrap_servers=['localhost:9092'])

# produce json messages
with open("911-rowsonly.json", 'r') as msg911:
    msg911 = json.load(msg911)

producer.send('SPD_911', json.dumps(msg911))

# make sure to flush the buffer
producer.flush()

# configure multiple retries
#producer = KafkaProducer(retries=5)