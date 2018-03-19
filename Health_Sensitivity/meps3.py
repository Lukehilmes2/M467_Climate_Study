###############################################################################################
#Author: Seth Thompson
#Title: meps.py
#Date: 2-9-18
#Description: Designed to open files from the meps webpage
#             intended for the M_467 climate study.
###############################################################################################
import os
import sys
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
# bmi = record[715:719]
# fincome = record[1368:1369]
# income = record[1388:1394]
###############################################################################################
###############################################################################################

## Files used for year 2013
medCond2013 = './Meps_Data/h162.dat'
FY2013 = './Meps_Data/h163.dat'

myDict13 = {}    # Dictionary for 2013 file with dupersid is the key and value of [[demos],[icd9's],[chronicICD9]]

demos = namedtuple('data', 'age sex bmi income fincome')
demoList = []   # used to hold the demos information
icd9List = []   #This is the list for the ICD9 codes
valueList = []  #This is the list for the [demoList , icd9List , chronicICD9]

dupersIDList = []   #This is the list for holding DupersID's



chronicICD9List = [] # this will hold the chronic icd9's

dupersID = 0        # set first one = 0
thisDupersID = 0    # set first one = 0
tempDuper = 0       # set first one = 0





with open(FY2013, 'r', encoding = 'latin-1') as f:
    for record in f:
        dupersID = record[8:16]         # Holds the dupersID
        dupersIDList.append(dupersID)   # Appends the dupersID to a list
        age = record[176:178]           # extract age from file
        sex = record[186:187]           # extract sex from file
        bmi = record[715:719]           # extract bmi from file
        fincome = record[1368:1375]     # extract family income from file
        income = record[1388:1394]      # extract individual income from file

        demoi = demos(age = age, sex = sex, bmi = bmi, income = income, fincome = fincome)  #add everything to a named tuple

        demoList.append(demoi)          # add named tuple to a list for organizational purposes
        myDict13[dupersID] = demoList   # Create a new key: value pair in our dictionary with dupersID key and demolist
        demoList = []                   # reset demoList to be an empty list

g = 0
d = 0
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
            chronicICD9List = []
            icd9List = []                                   # reset icd9List to empty
            icd9List.append(icd9)                           # Add the first icd9 to the empty list
            tempDuper = thisDupersID                        # reset tempDuper for next comparison



thisicd9List = []               # creats an empty list to hold all other icd9 lists
patientList = [0] * 50          # This sets every value of patientList of size 50 to zero

for k, v in myDict13.items():           # iterate through all key:value pairs in the dictionary                             
    if len(v) > 1:                      # v is the value, v holds demo information and then icd9 lists if they have one if v is larger than length 1, the an icd9 list is present
        icd9 = v[1]                     # icd9 is the list of all icd9's for this specific person
        thisicd9List.append(icd9)                     # append that to the list that holds all the smaller lists
        patientList[len(v[1])] += int(v[0].age)     # this keeps track of the total age to be used for finding the mean
    elif len(v) == 1:
        patientList[0] += int(v[0].age)             # keeps track of patient age with zero icd9's

thisChronicList = []
for k, v in myDict13.items():
    if len(v) > 2:
        chronic = v[2]
        thisChronicList.append(chronic)

histList = [0] * 50         # empty list of size 50 as we know the largest icd9 list is 49 this will be used to plot a graph
histList[0] = len(myDict13) - len(thisicd9List)     # sets the zero index to correct value


histList2 = [0] * 50        # to be used for finding chronic icd9's
#histList2 = [x for x in chronicList if x in thisicd9List]
n = 0




bins = [x for x in range(len(histList))]

for i in range(len(thisicd9List)):
    histList[len(thisicd9List[i])] += 1

for i in range(len(thisChronicList)):
    histList2[len(thisChronicList[i])] += 1

histList2[0] = 0

##for i in range(len(thisicd9List)):
##    print(thisicd9List[i])


##for i in range(len(histList)):
##    print("Total ICD9's:", i)
##    print("Total Patients:" , histList[i])
##    print("Total Age:" , patientList[i])
##    if histList[i] != 0:
##        print("Average Age:" , (patientList[i] / histList[i]))
##    elif histList[i] == 0:
##        print("No Patients")
##    print()





plt.bar(bins, histList, label = 'total icd9', align = 'edge')
plt.bar(bins, histList2, label = 'chronic icd9', align = 'edge')

plt.legend()

plt.xlabel('Size of List')
plt.ylabel('Count')
plt.show()






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
# sex = record[186:187]    ##1 = Male, 2 = Female
# bmi = record[697:702]
# fincome = record[1446:1452]
# income = record[1464:1470]
################################################################################################
################################################################################################


## Files used for year 2014
medCond2014 = './Meps_Data/h170.dat'
FY2014 = './Meps_Data/h171.dat'


demos = namedtuple('data', 'age sex bmi income fincome') #Declaring namedtuple
icd9List = []
valueList = []
myDict14 = {}    #dupersid is the key with demos as the values


with open(medCond2014, 'r', encoding='latin-1') as f:
    for record in f:
        dupersID = record[8:16]
        icd9 = record[48:51]
        if dupersID == tempDuper or tempDuper == 0:
            icd9List.append(icd9)
            tempDuper = dupersID
        elif dupersID != tempDuper:
            valueList.append(icd9List)
            myDict14[tempDuper] = valueList
            valueList = []
            icd9List = []
            icd9List.append(icd9)
            tempDuper = dupersID

    

with open(FY2014, 'r', encoding = 'latin-1') as f:
    for record in f:
        thisDupersID = record[8:16]
        age = record[176:178]
        sex = record[186:187]
        bmi = record[697:702]
        fincome = record[1446:1452]
        income = record[1464:1470]

        demoi = demos(age = age, sex = sex, bmi = bmi, income = income, fincome = fincome)       

        if thisDupersID in myDict14.keys():
            myDict14[thisDupersID].append(demoi)



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
# sex = record[186:187]    ##1 = Male, 2 = Female
# bmi = record[698:703]
# fincome = record[1424:1431]
# income = record[1443:1449]
##########################################################################################################################
##########################################################################################################################


## Files used for year 2015
medCond2015 = './Meps_Data/h180.dat'
FY2015 = './Meps_Data/h181.dat'


demos = namedtuple('data', 'age sex bmi income fincome') #Declaring namedtuple
icd9List = []
valueList = []
myDict15 = {}    #dupersid is the key with demos as the values


with open(medCond2015, 'r', encoding='latin-1') as f:
    for record in f:
        dupersID = record[8:16]
        icd9 = record[48:51]
        if dupersID == tempDuper or tempDuper == 0:
            icd9List.append(icd9)
            tempDuper = dupersID
        elif dupersID != tempDuper:
            valueList.append(icd9List)
            myDict15[tempDuper] = valueList
            valueList = []
            icd9List = []
            icd9List.append(icd9)
            tempDuper = dupersID

    

with open(FY2015, 'r', encoding = 'latin-1') as f:
    for record in f:
        thisDupersID = record[8:16]
        age = record[176:178]
        sex = record[186:187]
        bmi = record[698:703]
        fincome = record[1424:1431]
        income = record[1443:1449]

        demoi = demos(age = age, sex = sex, bmi = bmi, income = income, fincome = fincome) 


        if thisDupersID in myDict15.keys():
            myDict15[thisDupersID].append(demoi)
