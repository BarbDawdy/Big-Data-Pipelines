
#################################################################################
#
#  program - consumerSPD.py
#  usage - this program expects that there are two topics passed in one for enitity A and one for enitity B
#  note -  expected to be run in python version 2.x not tested in python 3.x
#
#  description - see https://gitlab2.bigdata220uw.mooo.com/dawdyb/Assignment4/tree/master
#  usage: consumerSPD.py <zk> <topicA> <topicB>
#
#  program based on https://github.com/apache/spark/blob/master/examples/src/main/python/streaming/kafka_wordcount.py
#
#################################################################################
import sys
import os
from kafka import KafkaProducer
from kafka.errors import KafkaError
import json

from __future__ import print_function

import sys

from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: consumerSPD.py <zk> <topicA> <topicB>", file=sys.stderr)
        exit(-1)

    sc = SparkContext(appName="PythonStreamingSPDCrimeZoneBeat")
    ssc = StreamingContext(sc, 1)

    zkQuorum, topicSPDReport, topicSPD911,  = sys.argv[1:]
    kvs = KafkaUtils.createStream(ssc, zkQuorum, "spark-streaming-consumer", {topic: 1})

      
    911_stream = KafkaUtils.createDirectStream(ssc, [topicSPD911], {"metadata.broker.list": "localhost:9092,localhost:9092"}, valueDecoder=decoder)
    report_stream = KafkaUtils.createStream(ssc, zkQuorum, "spark-streaming-consumer", {topicSPDReport: 1})
	
    ssc.start()
	#write some code to print and then RDD for each metric
	#join the 911_RDD and report_RDD by date and zone beat.
	
    ssc.awaitTermination()