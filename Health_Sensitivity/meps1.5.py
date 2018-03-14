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
# income = record[1368:1375]
# education = record[228:230] ##1 = <= 8th grade, 2 = 9th-12th, 3 = GED or Equiv, 4 = HS Diploma,
                                ##5 = Some College, 6&7 = Assoc, 8 = Bach, 9 = Master's & PhD, 10 = child under 5
# employment = record[1093-1099] ##-1 = Inapplicable, 1 =  Employed, 4 = Not Employed
# insurance = record[1303-1308] ##-1 = Inapplicable, 1 = Yes, 2 = No
###############################################################################################
###############################################################################################

## Files used for year 2013
medCond2013 = './Meps_Data/h162.dat'
FY2013 = './Meps_Data/h163.dat'

demos = namedtuple('data', 'age sex bmi diabx income education employment')
icd9List = []   #This is the list for the ICD9 codes
valueList = []  #This is the list for the [icd9List and the named tuple]

dupersID = 0
tempDuper = 0

myDict13 = {dupersID : demos}    #dupersid is the key with demos as the values

with open(medCond2013, 'r', encoding='latin-1') as f:
    for record in f:
        dupersID = record[8:16]
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
        income = record[1368:1375]
        education = record[229:230]
        employment = record[1094:1099]
        insurance = record[1303:1308]

        demoi = demos(age = age, sex = sex, bmi = bmi, diabx = diabx, income = income, education = education, employment = employment, insurance = insurance)

        if thisDupersID in myDict13.keys():         # This matches up and inserts the demo1
            myDict13[thisDupersID].append(demoi)    # with the appropriate DupersID


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
# income = record[1446:1452]
# education = record[224-226] ##1 = <= 8th grade, 2 = 9th-12th, 3 = GED or Equiv, 4 = HS Diploma,
                                ##5 = Some College, 6&7 = Assoc, 8 = Bach, 9 = Master's & PhD, 10 = child under 5
# employment = record[1270-1276] ##-1 = Inapplicable, 1 =  Employed, 4 = Not Employed
# insurance = record[1252-1258] ##-1 = Inapplicable, 1 = Yes, 2 = No
################################################################################################
################################################################################################


## Files used for year 2014
medCond2014 = './Meps_Data/h170.dat'
FY2014 = './Meps_Data/h171.dat'


demos = namedtuple('data', 'age sex bmi diabx income education employment') #Declaring namedtuple
icd9List = []
valueList = []
myDict14 = {'dupersID': demos}    #dupersid is the key with demos as the values


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
        income = record[1446:1452]
        education = record[224:226]
        employment = record[1270:1276]
        insurance = record[1252:1258]

        demoi = demos(age = age, sex = sex, bmi = bmi, diabx = diabx, income = income, education = education, employment = employment, insurance = insurance)       

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
# income = record[1368:1375]
# education = record[228:230] ##1 = <= 8th grade, 2 = 9th-12th, 3 = GED or Equiv, 4 = HS Diploma,
                                ##5 = Some College, 6&7 = Assoc, 8 = Bach, 9 = Master's & PhD, 10 = child under 5
# employment = record[1093:1099] ##-1 = Inapplicable, 1 =  Employed, 4 = Not Employed
# insurance = record[1230-1236] ##-1 = Inapplicable, 1 = Yes, 2 = No
##########################################################################################################################
##########################################################################################################################


## Files used for year 2015
medCond2015 = './Meps_Data/h180.dat'
FY2015 = './Meps_Data/h181.dat'


demos = namedtuple('data', 'age sex bmi diabx income education employment') #Declaring namedtuple
icd9List = []
valueList = []
myDict15 = {'dupersID': demos}    #dupersid is the key with demos as the values


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
        income = record[1368:1375]
        education = record[228:230]
        employment = record[1093:1099]
        insurance = record[1230:1236]

        demoi = demos(age = age, sex = sex, bmi = bmi, diabx = diabx, income = income, education = education, employment = employment, insurance = insurance) 


        if thisDupersID in myDict15.keys():
            myDict15[thisDupersID].append(demoi)
