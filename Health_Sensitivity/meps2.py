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
# Diabdx = record[364:366]     ##1 = Yes,  2 = No
# income = record[1389:1394]
###############################################################################################
###############################################################################################

## Files used for year 2013
medCond2013 = './Meps_Data/h162.dat'
FY2013 = './Meps_Data/h163.dat'

demos = namedtuple('data', 'age sex bmi diabx income fincome')
icd9List = []   #This is the list for the ICD9 codes
valueList = []  #This is the list for the [icd9List and the named tuple]

dupersIDList = []

dupersID = 0
tempDuper = 0

myDict13 = {}    #dupersid is the key with demos as the values

with open(medCond2013, 'r', encoding='latin-1') as f:
    for record in f:
        dupersID = record[8:16]
        dupersIDList.append(dupersID)
        icd9 = record[48:51]                        # This is all the Logic for inserting 
        if dupersID == tempDuper or tempDuper == 0: # icd9 codes for each unique dupersID
            icd9List.append(icd9)
            tempDuper = dupersID
        elif dupersID != tempDuper:
            valueList.append(icd9List)
            myDict13[tempDuper] = valueList
            valueList = []
            icd9List = []
            icd9List.append(icd9)
            tempDuper = dupersID

with open(FY2013, 'r', encoding = 'latin-1') as f:
    for record in f:
        thisDupersID = record[8:16]                 # This is the records of age, bmi, etc
        age = record[176:178]                       # diabx may be a faulty variable
        sex = record[186:187]
        diabx = record[364:366]
        bmi = record[715:719]
        fincome = record[1424:1431]
        income = record[1443:1449]

        demoi = demos(age = age, sex = sex, bmi = bmi, diabx = diabx, income = income, fincome = fincome)

        if thisDupersID in myDict13.keys():         # This matches up and inserts the demo1
            myDict13[thisDupersID].append(demoi)    # with the appropriate DupersID


thisicd9List = []
keyList = []
patientList = []

for k, v in myDict13.items():
	icd9 = v[0]
	patient = v[1]
	key = k
	thisicd9List.append(icd9)
	patientList.append(patient)
	keyList.append(key)   


histList = [0] * 50
histList[0] = 8365

bins = [x for x in range(len(histList))]

for i in range(len(thisicd9List)):
    histList[len(thisicd9List[i])] += 1
    

histList2 = [x*.8 for x in histList]
bins2 = bins

plt.bar(bins, histList)
plt.bar(bins2, histList2)

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
# Diabdx = record[362:364]    ##1 = Yes,  2 = No
# income = record[1464:1470]
################################################################################################
################################################################################################


## Files used for year 2014
medCond2014 = './Meps_Data/h170.dat'
FY2014 = './Meps_Data/h171.dat'


demos = namedtuple('data', 'age sex bmi diabx income') #Declaring namedtuple
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
        diabx = record[362:364]
        income = record[1464:1470]

        demoi = demos(age = age, sex = sex, bmi = bmi, diabx = diabx, income = income)       

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
# Diabdx = record[364:366]   ##1 = Yes,  2 = No
# income = record[1443:1449]
##########################################################################################################################
##########################################################################################################################


## Files used for year 2015
medCond2015 = './Meps_Data/h180.dat'
FY2015 = './Meps_Data/h181.dat'


demos = namedtuple('data', 'age sex bmi diabx income') #Declaring namedtuple
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
        diabx = record[364:366]
        bmi = record[698:703]
        income = record[1443:1449]

        demoi = demos(age = age, sex = sex, bmi = bmi, diabx = diabx, income = income) 


        if thisDupersID in myDict15.keys():
            myDict15[thisDupersID].append(demoi)
