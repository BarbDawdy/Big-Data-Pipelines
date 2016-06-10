import os
import sys
from subprocess import Popen, PIPE
import json
import collections
from itertools import islice

#################################################################################
#
#  program - helloStreams.py
#  usage - dependent on afileSimulator jar file -n was set to 200
#          helloStreams.py is run directly in pycharm or by using python.ext and full path to the helloStreams.py program
#  note -  expected to be run in python version 3.x or greater
#
#  description - see https://gitlab2.bigdata220uw.mooo.com/jhenri/uwbd-instructions/blob/master/Assignment%202:%20Hello%20Stream.md
#  assumptions -
#                o	All storage internal in program was based on store and product (only 1) was not considered at this time.
#                o	It was assumed that a –n (number) of 200 generated records to the jar file was sufficient for the output needed by the teacher.
#                o	Since only one product I used a simple dictionary structure which allowed for simple storage of the inventory changes and alerts due to
#                   only one product.  With more than one product I would need to be more complex data structure which would include storage of the store and product.
#                o	Frequency was determined by quantity change divided time since last purchase or event.  Previous time was stored in a dictionary by store and used with the current event time for that store to get a delta time.
#                o	Per the class office hrs I assumed it was acceptable to display all information in Q2 from the assignment in the json output event line and also to display the alert message when it occurred.
#                o	3 different alert messages were provided: one when inventory =<5 but inventory >0, when inventory = 0, and when inventory goes negative.  This could be used for escalation notification
#                   in future for that stores management or inventory dept. in real world.
#
#
#  history - 1.0    - based Jeff Henrikson helloStreams.py for UW DataPipes class Spring 2016
#            1.1    - BLD  2016 May 03 - updates per assignment as defined in description link
#
#
##################################################################################



def getScriptPath():
    return os.path.dirname(os.path.realpath(sys.argv[0]))

adirScript = getScriptPath()

afileSimulator = os.path.join(
    adirScript,
    '..',
    'storeInventoryGenerator/storeInventoryGenerator-assembly-1.0.jar')

#proc = Popen(['java', '-jar', afileSimulator], stdout=PIPE, stderr=PIPE)
#put in -n option set to 200 for generating data
proc = Popen(['java', '-jar', afileSimulator, '-n', '200'], stdout=PIPE, stderr=PIPE)

#setup a store previous time to use with time delta in frequency and store frequency dictionary
dStoreTimePrevious = {}
dStoreFrequency = {}
#setup store inventory dictionary
dStoreInvt = {}

#setup  for store frequency

for line in iter(proc.stdout.readline,''):

    #orginal lines commented out work in python 2.7 but using 3.0
    # stjson1 = line.rstrip()
    # event1 = json.loads(stjson1)

    #had to use the utf8 rstrip due to python 3.x changes
    stjson1 = str(line.rstrip(), 'utf8')
    event1 = json.loads(stjson1)

    #if inventory event1 and t==0 then init of quanityChange in inventory list then save for each store to calculate for alarm
    if ('inventory' in event1) and event1['t']==0:
        #setup alarm dict where key matches store id
        store = int(event1['inventory']['store']['id'])
        #dont need product right now as only one but in future will use for list in list
        #prodt = int(event1['inventory']['product']['id'])

        dStoreInvt[store] = event1['inventory']['quantityChange']
        #init a starting time for the store to use in the delta for frequency
        dStoreTimePrevious[store] = event1['t']
        dStoreFrequency[store] = 0


    #calculate frequency of pruchase in each store across all products.
    #check if quanity negitive then purchase and use that number to increment the store counter
    if ('inventory' in event1) and 0 > event1['inventory']['quantityChange']:
        #update store frequency list with the index in the list at the store
        #mult by -1 to turn to postitive number
        store = int(event1['inventory']['store']['id'])
        time_current = event1['t']
        dStoreInvt[store] =  dStoreInvt[store] + event1['inventory']['quantityChange']

        #check if their is an alarm condition and then add to json
        if dStoreInvt[store] <= 5 and dStoreInvt[store] > 0 :
            msg = '**Alarm*** quantity of 5 or less found.  Actual Quantity is ' + str(dStoreInvt[store])
            event1['alarm'] = msg
        elif dStoreInvt[store] == 0:
            msg = '**Alarm*** Out of Inventory out of product you are now at 0 quantity better get this product back in stock'
            event1['alarm'] = msg
        elif dStoreInvt[store] < 0:
            msg = '**Alarm*** Negative inventory need to let customers know back order status or they might be very very unhappy.'
            event1['alarm'] = msg
            
        #calculate the frequency with quality/time delta for store
        time_delta = event1['t'] - dStoreTimePrevious[store]
        dStoreFrequency[store] = (event1['inventory']['quantityChange']*-1)/time_delta

        #use ordered dictionary and islice to get the top two stores frequency
        od = collections.OrderedDict(sorted(dStoreFrequency.items(), key=lambda x: x[1], reverse=True))
        od = list(islice(od.items(), 0, 2))
        #add the top two stores by frequency to the json
        event1['Top2Stores [Store,Frequency]'] = od

        #update previous store time dictionary to new time for store
        dStoreTimePrevious[store] = event1['t']

    #event1['message'] = 'hello'

    print(json.dumps(event1))

