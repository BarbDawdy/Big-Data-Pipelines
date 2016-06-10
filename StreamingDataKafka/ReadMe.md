# <center>Seattle Police Department Data Pipeline</center>
# <center>Assignment 4</center>

## Data Selection
Streaming data was chosen from Seattle Police Department (SPD) as the data is current, streaming and interesting to the team.

### Data Used
#### Entity A - Seattle Police Department Report Data

- Contained many fields including; Offence Type, Offence Code, Summary of Offence Date/Time, Hundred Block Location, District, Zone Beat, etc.
- https://data.seattle.gov/Public-Safety/Seattle-Police-Department-Police-Report-Incident/7ais-f98f  
- Date/Time, Summary of Offence, and Zone Beat
- 2016 data only used
- CSV format loaded into MySQL RDBMS
- Kafka Topic SPD_Reports

#### Entity B - Seattle 911 Police Data

- Contained many fields including; Event Clearance Description, Initial Type Group, Initial Type Description, Event Clearance Date/Time, Hundred Block Location, District, Zone Beat, etc.
- https://data.seattle.gov/Public-Safety/Seattle-Police-Department-911-Incident-Response/3k2p-39jp
- Event Clearance Date/Time, Initial Type Description, and Zone Beat
- Latest 48 hours data only used
- JSON file processed with custom python consumer
- Kafka Topic SPD_911

## Business Use
Best fit deployment of resources and appropriate response to Police Calls in Seattle.
- Deploying appropriate resources to area (beat, zone or districts) based on need, call/report type, location and threshold of 911 calls and police reports from the location.

- Deploying appropriate resources due to trends seen in data (ongoing crime patterns).

## Program Plan
The team did come up with and initial program plan.  Please see the Program Plan file on the master branch of this gitlab for details.

- https://gitlab2.bigdata220uw.mooo.com/dawdyb/Assignment4/blob/master/SDP-DataPipes-ProjectPlan.pptx

## Metrics
The team defined that metric would be a count of offenses from the SPD Report data based on Zone Beat for a 4 hour time frame, count of incidents from the SPD 911 data based on Zone Beat for a 4 hour time frame and then joining the data to get a total count of offenses/incidents based on a zone beat for a 4 hour time frame.

## Setup
Setup of the system was preformed by following the instructions provided on the following website.

- http://www.confluent.io/blog/how-to-build-a-scalable-etl-pipeline-with-kafka-connect

## MySQL
MySql is setup as part of the instructions preformed in the Setup section.
Schema setup and other commands to setup the the SPD_Report table are included in the mysqldb_setup.txt file included in this gitlab.

## Testing System
Each team member setup vagrant and other tools using the link provided in setup to work with the Seattle Police Department Data.  

Team members used both the Kafka Command Line interface and the producerTestMessageTyps.py

Kafka Comamnd Line Interface was useful to ensure that all ports were working in vagrant and that the system was operating
- https://gitlab2.bigdata220uw.mooo.com/dawdyb/Assignment4/blob/master/Kafka_CommandLine_Notes.txt

Test code written to test kafka producer to work with the json 911 data.
- https://gitlab2.bigdata220uw.mooo.com/dawdyb/Assignment4/blob/master/kafka_test

## Setup Issues and Running
Some setup and issues running were documented in the file on the master branch of this gitlab for details use the following link.

- https://gitlab2.bigdata220uw.mooo.com/dawdyb/Assignment4/blob/master/vagrant_mysql_kafka_setup.docx

## Kafka Topics
To setup the two kafka topics used the following create topic and list should be used.
cd to the /vagrant directory before running these commands



### Create Topics
>kafka-topics --zookeeper localhost:2181 --create --topic SPD_Report --partitions 1 --replication-factor 1<br>
>kafka-topics --zookeeper localhost:2181 --create --topic SPD_911 --partitions 1 --replication-factor 1

The describe or list commands can be used to verify that the topics have been setup.

### List Kafka Topics

> -topics --list --zookeeper localhost:2181<br>
> __confluent.support.metrics<br>
> __consumer_offsets<br>
> _schemas<br>
> SPD_911<br>
> SPD_Report<br>

### Describe Kafka Topics
> kafka-topics --describe --zookeeper localhost:2181 --topic SPD_911<br>
> Topic:SPD_911      PartitionCount:1        ReplicationFactor:1     Configs:<br>
> Topic: SPD_911     Partition: 0    Leader: 0       Replicas: 0     Isr: 0<br>


## Code
The code for this project is two parts a producer and consumer.  These programs will need to be run in two separate bash windows.

### Producer
The producer purpose is to read in the 911 JSON data (later update to streaming data).<br>
Run the producer with the command below.

> python producer911.py

### Consumer
The consumer processes the two Kafka topics SPD_Report and SPD_911 and joins the data to produce the metrics defined above.  The goal was to produce a metric for each data source and then join the data sources.

#### Consumer test with command line

The KafkaTopic-SPD911CLI.md shows the output from running the kafka-console-consumer to ennsure that the producer is producing messages propertly
> https://gitlab2.bigdata220uw.mooo.com/dawdyb/Assignment4/blob/Barb/KafkaTopic-SPD911CLI.md

#### Consumer Python Program

> python consumerSPD.py <zk> <topicA> <topicB>


