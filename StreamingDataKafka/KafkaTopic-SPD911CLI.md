# Output sample from SPD_911 Kafka topic

Running the consumer in the command line the following information from running of the producer911.py is shown.  The input JSON file was 911-rowsonly.json


> kafka-console-consumer --zookeeper localhost:2181 --from-beginning --topic SPD_911

[{"hundred_block_location": "1XX BLOCK OF PINE ST", "district_sector": "M", "event_clearance_code": "161", "cad_cdw_id": "1001512", "event_clearance_date": "2012-12-23T13:59:00.000", "event_clearance_description": "TRESPASS", "zone_beat": "M3", "event_clearance_subgroup": "TRESPASS", "census_tract": "8100.1000", "cad_event_number": "12000437316", "incident_location": {"type": "Point", "coordinates": [-122.340367, 47.610046]}, "longitude": "-122.340367253", "latitude": "47.610046276", "general_offense_number": "2012437316", "event_clearance_group": "TRESPASS"}, {"hundred_block_location": "3XX BLOCK OF HARRISON ST", "district_sector": "D", "event_clearance_code": "161", "cad_cdw_id": "1001774", "event_clearance_date": "2012-12-24T16:27:00.000", "event_clearance_description": "TRESPASS", "zone_beat": "D1", "event_clearance_subgroup": "TRESPASS", "census_tract": "7100.2001", "cad_event_number": "12000438459", "incident_location": {"type": "Point", "coordinates": [-122.350854, 47.622087]}, "longitude": "-122.350854033", "latitude": "47.622086915", "general_offense_number": "2012438459", "event_clearance_group": "TRESPASS"}, {"hundred_block_location": "4XX BLOCK OF 12TH AVE", "district_sector": "E", "event_clearance_code": "161", "cad_cdw_id": "100561", "event_clearance_date": "2010-10-22T23:43:00.000", "event_clearance_description": "TRESPASS ", "zone_beat": "E3", "event_clearance_subgroup": "TRESPASS", "census_tract": "8600.1017", "cad_event_number": "10000370180", "incident_location": {"type": "Point", "coordinates": [-122.316781, 47.605885]}, "longitude": "-122.316780576", "latitude": "47.605885165", "general_offense_number": "2010370180", "event_clearance_group": "TRESPASS"}, {"hundred_block_location": "2 AV / PINE ST", "event_clearance_code": "245", "cad_cdw_id": "1005683", "event_clearance_date": "2012-11-27T16:31:00.000", "event_clearance_description": "DISTURBANCE, OTHER", "zone_beat": "MS", "event_clearance_subgroup": "DISTURBANCES", "longitude": "-122.33981141", "cad_event_number": "12000405661", "at_scene_time": "2012-11-27T16:17:00.000", "incident_location": {"type": "Point", "coordinates": [-122.339811, 47.610278]}, "latitude": "47.610278386", "general_offense_number": "2012405661", "event_clearance_group": "DISTURBANCES"}, {"hundred_block_location": "11XX BLOCK OF MADISON ST", "district_sector": "D", "event_clearance_code": "161", "cad_cdw_id": "101888", "event_clearance_date": "2010-10-24T18:10:00.000", "event_clearance_descript


lots more data was deleted so this file was not to large.