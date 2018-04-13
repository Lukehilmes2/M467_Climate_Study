###############################################################################################
#Author: Seth Thompson
#Title: meps.py
#Date: 2-9-18
#Description: Designed to open files from the meps webpage
#             intended for the M_467 climate study.
###############################################################################################
import os
import sys
import csv
import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict
from collections import namedtuple


###############################################################################################
###############################################################################################
# Med Conditions file 2013
# h162.dat
# dupersID = record[8:16]   #used to identify people across files
# icd9 = record[48:51]      #code used to identify condition
#                           #can have multiple icd9 codes
###############################################################################################
# Full year file 2013
# h163.dat
# 36,940 results
# dupersID = record[8:16]
# age = record[176:178]
# sex = record[186:187]    ##1 = Male, 2 = Female
# education = record[228:230]
# fincome = record[1368:1369]
# income = record[1388:1394]
###############################################################################################
###############################################################################################

## Files used for year 2013
medCond2013 = './Meps_Input_Data/h162.dat'
FY2013 = './Meps_Input_Data/h163.dat'

myDict13 = {}    # Dictionary for 2013 file with dupersid is the key and value of [[demos],[icd9's],[chronicICD9]]

demos = namedtuple('data', 'age income education employment')

demoList = []   # used to hold the demos information
icd9List = []   #This is the list for the ICD9 codes
chronicICD9List = [] # this will hold the chronic icd9's
valueList = []  #This is the list for the [demoList , icd9List , chronicICD9]

dupersIDList = []   #This is the list for holding DupersID's

dupersID = 0        # set first one = 0
thisDupersID = 0    # set first one = 0
tempDuper = 0       # set first one = 0



count = 0

with open(FY2013, 'r', encoding = 'latin-1') as f:
    for record in f:
        count += 1
        dupersID = record[8:16]         # Holds the dupersID
        dupersIDList.append(dupersID)   # Appends the dupersID to a list
        age = record[176:178]           # extract age from file
        education = record[228:230]
        income = record[1388:1394]      # extract individual income from file
        employment = record[1093:1095]


        if employment == '01' or employment == '02' or employment == '03':
            employment = 1
        else:
            employment = 0
        
        demoi = demos(age = age, income = income, education = education, employment = employment)  #add everything to a named tuple

        demoList.append(demoi)          # add named tuple to a list for organizational purposes
            
        myDict13[dupersID] = demoList   # Create a new key: value pair in our dictionary with dupersID key and demolist
        demoList = []                   # reset demoList to be an empty list


# hard coded list of chronic illness codes
chronicList = ['493', '393', '402', '403', '404', '414', '416', '472', '473', '474', '476', '490', '491', '496', '428', '494', '413', '311', '515', '465']

with open(medCond2013, 'r', encoding='latin-1') as f:
    for record in f:
        thisDupersID = record[8:16]     # thisDupersID is the same as a dupersID, need different variable names
        icd9 = record[48:51]            # Extract the icd9 from the medical conditions file
        if thisDupersID == tempDuper or tempDuper == 0:     # if first thisDupersID or equal to the previous dupersID 
            icd9List.append(icd9)                           # then add this icd9 code to the matching it's dupersID
            if icd9 in chronicList:
                chronicICD9List.append(icd9)
            tempDuper = thisDupersID                        # reset tempDuper for next comparison          
        elif thisDupersID != tempDuper:                     # if thisDupersID is not equal to the previous
            myDict13[tempDuper].append(icd9List)            # insert the key:value pair with previous dupersID and icd9List
            myDict13[tempDuper].append(chronicICD9List)

            myDict13[tempDuper].append(len(icd9List))
            myDict13[tempDuper].append(len(chronicICD9List))

            chronicICD9List = []
            icd9List = []                                   # reset icd9List to empty
            icd9List.append(icd9)                           # Add the first icd9 to the empty list
            if icd9 in chronicList:
                chronicICD9List.append(icd9)
            tempDuper = thisDupersID                        # reset tempDuper for next comparison


with open('Meps_Output_Data/Meps_2013.csv', 'w', newline = '') as f:
    fieldNames = ['DupersID', 'Total ICD9', 'Chronic ICD9', 'Age', 'Income', 'Education', 'Employment']
    writer = csv.DictWriter(f, fieldnames = fieldNames)

    writer.writeheader()

    for k, v in myDict13.items():
        if v[0].age != '-1':
            if len(v) == 1:
                writer.writerow({'DupersID' : k, 'Total ICD9' : 0, 'Chronic ICD9' : 0, 'Age' : v[0].age,
                             'Income' : v[0].income, 'Education' : v[0].education, 'Employment' : v[0].employment})
            elif len(v) > 1:
                writer.writerow({'DupersID' : k, 'Total ICD9' : v[3], 'Chronic ICD9' : v[4], 'Age' : v[0].age,
                             'Income' : v[0].income, 'Education' : v[0].education, 'Employment' : v[0].employment})




###############################################################################################
###############################################################################################
# Med Conditions file 2014
# h170.dat
# dupersID = record[8:16]   #used to identify people across files
# icd9 = record[48:51]      #code used to identify condition
#                           #can have multiple icd9 codes
###############################################################################################
# Full year file 2014
# h171.dat
# 34,875 results
# dupersID = record[8:16]
# age = record[176:178]
# income = record[1464:1470]
################################################################################################
################################################################################################



## Files used for year 2013
medCond2014 = './Meps_Input_Data/h170.dat'
FY2014 = './Meps_Input_Data/h171.dat'

myDict14 = {}    # Dictionary for 2013 file with dupersid is the key and value of [[demos],[icd9's],[chronicICD9]]

demos = namedtuple('data', 'age income education employment')

demoList = []   # used to hold the demos information
icd9List = []   #This is the list for the ICD9 codes
chronicICD9List = [] # this will hold the chronic icd9's
valueList = []  #This is the list for the [demoList , icd9List , chronicICD9]

dupersIDList = []   #This is the list for holding DupersID's

dupersID = 0        # set first one = 0
thisDupersID = 0    # set first one = 0
tempDuper = 0       # set first one = 0





with open(FY2014, 'r', encoding = 'latin-1') as f:
    for record in f:
        dupersID = record[8:16]         # Holds the dupersID
        dupersIDList.append(dupersID)   # Appends the dupersID to a list
        age = record[176:178]           # extract age from file
        education = record[225:226]
        income = record[1464:1470]      # extract individual income from file
        employment = record[1270:1272]

        if employment == '01' or employment == '02' or employment == '03':
            employment = 1
        else:
            employment = 0

        demoi = demos(age = age, income = income, education = education, employment = employment)  #add everything to a named tuple

        demoList.append(demoi)          # add named tuple to a list for organizational purposes
        myDict14[dupersID] = demoList   # Create a new key: value pair in our dictionary with dupersID key and demolist
        demoList = []                   # reset demoList to be an empty list


# hard coded list of chronic illness codes
chronicList = ['493', '393', '402', '403', '404', '414', '416', '472', '473', '474', '476', '490', '491', '496', '428', '494', '413', '311', '515', '465']

with open(medCond2014, 'r', encoding='latin-1') as f:
    for record in f:
        thisDupersID = record[8:16]     # thisDupersID is the same as a dupersID, need different variable names
        icd9 = record[48:51]            # Extract the icd9 from the medical conditions file
        if thisDupersID == tempDuper or tempDuper == 0:     # if first thisDupersID or equal to the previous dupersID 
            icd9List.append(icd9)                           # then add this icd9 code to the matching it's dupersID
            if icd9 in chronicList:
                chronicICD9List.append(icd9)
            tempDuper = thisDupersID                        # reset tempDuper for next comparison          
        elif thisDupersID != tempDuper:                     # if thisDupersID is not equal to the previous
            myDict14[tempDuper].append(icd9List)            # insert the key:value pair with previous dupersID and icd9List
            myDict14[tempDuper].append(chronicICD9List)

            myDict14[tempDuper].append(len(icd9List))
            myDict14[tempDuper].append(len(chronicICD9List))

            chronicICD9List = []
            icd9List = []                                   # reset icd9List to empty
            icd9List.append(icd9)                           # Add the first icd9 to the empty list
            if icd9 in chronicList:
                chronicICD9List.append(icd9)
            tempDuper = thisDupersID                        # reset tempDuper for next comparison


with open('Meps_Output_Data/Meps_2014.csv', 'w', newline = '') as f:
    fieldNames = ['DupersID', 'Total ICD9', 'Chronic ICD9', 'Age', 'Income', 'Education', 'Employment']
    writer = csv.DictWriter(f, fieldnames = fieldNames)

    writer.writeheader()

    for k, v in myDict14.items():
        if v[0].age != '-1':
            if len(v) == 1:
                writer.writerow({'DupersID' : k, 'Total ICD9' : 0, 'Chronic ICD9' : 0, 'Age' : v[0].age,
                             'Income' : v[0].income, 'Education' : v[0].education, 'Employment' : v[0].employment})
            elif len(v) > 1:
                writer.writerow({'DupersID' : k, 'Total ICD9' : v[3], 'Chronic ICD9' : v[4], 'Age' : v[0].age,
                             'Income' : v[0].income, 'Education' : v[0].education, 'Employment' : v[0].employment})



##########################################################################################################################
##########################################################################################################################
# Med Conditions file 2015
# h180.dat
# dupersID = record[8:16]   #used to identify people across files
# icd9 = record[48:51]      #code used to identify condition
#                           #can have multiple icd9 codes
##########################################################################################################################
# Full year file 2015
# h181.dat
# 35,427 results
# dupersID = record[8:16]
# age = record[176:178]
# income = record[1443:1449]
##########################################################################################################################
##########################################################################################################################




## Files used for year 2013
medCond2015 = './Meps_Input_Data/h180.dat'
FY2015 = './Meps_Input_Data/h181.dat'

myDict15 = {}    # Dictionary for 2013 file with dupersid is the key and value of [[demos],[icd9's],[chronicICD9]]

demos = namedtuple('data', 'age income education employment')

demoList = []   # used to hold the demos information
icd9List = []   #This is the list for the ICD9 codes
chronicICD9List = [] # this will hold the chronic icd9's
valueList = []  #This is the list for the [demoList , icd9List , chronicICD9]

dupersIDList = []   #This is the list for holding DupersID's

dupersID = 0        # set first one = 0
thisDupersID = 0    # set first one = 0
tempDuper = 0       # set first one = 0





with open(FY2015, 'r', encoding = 'latin-1') as f:
    for record in f:
        dupersID = record[8:16]         # Holds the dupersID
        dupersIDList.append(dupersID)   # Appends the dupersID to a list
        age = record[176:178]           # extract age from file
        education = record[225:226]
        income = record[1443:1449]      # extract individual income from file
        employment = record[1248:1250]

        if employment == '01' or employment == '02' or employment == '03':
            employment = 1
        else:
            employment = 0

        demoi = demos(age = age, income = income, education = education, employment = employment)  #add everything to a named tuple

        demoList.append(demoi)          # add named tuple to a list for organizational purposes
        myDict15[dupersID] = demoList   # Create a new key: value pair in our dictionary with dupersID key and demolist
        demoList = []                   # reset demoList to be an empty list


# hard coded list of chronic illness codes
chronicList = ['493', '393', '402', '403', '404', '414', '416', '472', '473', '474', '476', '490', '491', '496', '428', '494', '413', '311', '515', '465']

with open(medCond2015, 'r', encoding='latin-1') as f:
    for record in f:
        thisDupersID = record[8:16]     # thisDupersID is the same as a dupersID, need different variable names
        icd9 = record[48:51]            # Extract the icd9 from the medical conditions file
        if thisDupersID == tempDuper or tempDuper == 0:     # if first thisDupersID or equal to the previous dupersID 
            icd9List.append(icd9)                           # then add this icd9 code to the matching it's dupersID
            if icd9 in chronicList:
                chronicICD9List.append(icd9)
            tempDuper = thisDupersID                        # reset tempDuper for next comparison          
        elif thisDupersID != tempDuper:                     # if thisDupersID is not equal to the previous
            myDict15[tempDuper].append(icd9List)            # insert the key:value pair with previous dupersID and icd9List
            myDict15[tempDuper].append(chronicICD9List)

            myDict15[tempDuper].append(len(icd9List))
            myDict15[tempDuper].append(len(chronicICD9List))

            chronicICD9List = []
            icd9List = []                                   # reset icd9List to empty
            icd9List.append(icd9)                           # Add the first icd9 to the empty list
            if icd9 in chronicList:
                chronicICD9List.append(icd9)
            tempDuper = thisDupersID                        # reset tempDuper for next comparison


with open('Meps_Output_Data/Meps_2015.csv', 'w', newline = '') as f:
    fieldNames = ['DupersID', 'Total ICD9', 'Chronic ICD9', 'Age', 'Income', 'Education', 'Employment']
    writer = csv.DictWriter(f, fieldnames = fieldNames)

    writer.writeheader()

    for k, v in myDict15.items():
        if v[0].age != '-1':
            if len(v) == 1:
                writer.writerow({'DupersID' : k, 'Total ICD9' : 0, 'Chronic ICD9' : 0, 'Age' : v[0].age,
                             'Income' : v[0].income, 'Education' : v[0].education, 'Employment' : v[0].employment})
            elif len(v) > 1:
                writer.writerow({'DupersID' : k, 'Total ICD9' : v[3], 'Chronic ICD9' : v[4], 'Age' : v[0].age,
                             'Income' : v[0].income, 'Education' : v[0].education, 'Employment' : v[0].employment})


