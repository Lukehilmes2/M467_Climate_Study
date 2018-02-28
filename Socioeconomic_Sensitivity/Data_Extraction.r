setwd("C:/Users/luke/Desktop/M467/M467_Climate_Study/Socioeconomic_Sensitivity/ACSData16_5YR")



#Declare names of all available data tables for 
#commented out data that does not align with MEPS

SexByAge = paste("ACS_16_5YR_B01001_with_ann.csv",sep = "")
HouseholdSize = paste("ACS_16_5YR_B11016_with_ann.csv",sep = "")
Education = paste("ACS_16_5YR_B15003_with_ann.csv",sep = "")
Employment = paste("ACS_16_5YR_B23025_with_ann.csv",sep = "")
HouseholdIncome = paste("ACS_16_5YR_B19001_with_ann.csv",sep = "")
HealthInsurance = paste("ACS_16_5YR_B27010_with_ann.csv",sep = "")

#HousingUnits = paste("ACS_16_5YR_B25001_with_ann.csv",sep = "")
#YearBuilt = paste("ACS_16_5YR_B25034_with_ann.csv",sep = "")
#ContractRent = paste("ACS_16_5YR_B25056_with_ann.csv",sep = "")
#Value = paste("ACS_16_5YR_B25075_with_ann.csv",sep = "")
#PovertyStatus = paste("ACS_16_5YR_B17017_with_ann.csv",sep = "")
#TransToWork = paste("ACS_16_5YR_B08301_with_ann.csv",sep = "")
#HouseholdType = paste("ACS_16_5YR_B11001_with_ann.csv",sep = "")

#read in csv files of all available data tables for  
dfSexByAge = read.csv(SexByAge)
dfHouseholdIncome = read.csv(HouseholdIncome)
dfEducation = read.csv(Education)
dfEmployment= read.csv(Employment)
dfHouseholdSize= read.csv(HouseholdSize)
dfHealthInsurance= read.csv(HealthInsurance)

#dfTransToWork = read.csv(TransToWork)
#dfHouseholdType = read.csv(HouseholdType)
#dfPovertyStatus = read.csv(PovertyStatus)
#dfHousingUnits = read.csv(HousingUnits)
#dfYearBuilt = read.csv(YearBuilt)
#dfContractRent = read.csv(ContractRent)
#dfValue = read.csv(Value)


#Declare uniform GeoID and display name column in ACS and total population

ACS  <- cbind.data.frame(dfSexByAge$GEO.id2)
ACS$Display <- (dfSexByAge$GEO.display.label)
ACS$TotalPopulation <- (dfSexByAge$HD01_VD01)

#Rename the columns in ACSto be easier to work with

colnames(ACS ) <- c("GEOID2","Display","TotalPopulation")
ACS  = ACS [-1,]


################################################################################
#We want peple who are more susceptible to illness: Kids and Elderly
#Sum of kids <= 9 years old
AgeList <- c(2.5,7.5,12,16,18.5,20,21,23,27.5,32,37.5,42,47.5,52,57.5,60.5,63,65.5,68,72,77.5,82,85)
ACS$AvgAge <- ((as.numeric(as.character(dfSexByAge[-1,]$HD01_VD03)))*AgeList[1] +
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD04)))*AgeList[2]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD05)))*AgeList[3]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD06)))*AgeList[4]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD07)))*AgeList[5]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD08)))*AgeList[6]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD09)))*AgeList[7]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD10)))*AgeList[8]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD11)))*AgeList[9]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD12)))*AgeList[10]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD13)))*AgeList[11]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD14)))*AgeList[12]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD15)))*AgeList[13]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD16)))*AgeList[14]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD17)))*AgeList[15]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD18)))*AgeList[16]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD19)))*AgeList[17]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD20)))*AgeList[18]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD21)))*AgeList[19]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD22)))*AgeList[20]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD23)))*AgeList[21]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD24)))*AgeList[22]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD25)))*AgeList[23]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD27)))*AgeList[1]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD28)))*AgeList[2]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD29)))*AgeList[3]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD30)))*AgeList[4]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD31)))*AgeList[5]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD32)))*AgeList[6]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD33)))*AgeList[7]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD34)))*AgeList[8]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD35)))*AgeList[9]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD36)))*AgeList[10]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD37)))*AgeList[11]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD38)))*AgeList[12]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD39)))*AgeList[13]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD40)))*AgeList[14]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD41)))*AgeList[15]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD42)))*AgeList[16]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD43)))*AgeList[17]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD44)))*AgeList[18]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD45)))*AgeList[19]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD46)))*AgeList[20]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD47)))*AgeList[21]+ 
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD48)))*AgeList[22]+
                 as.numeric(as.character((dfSexByAge[-1,]$HD01_VD49)))*AgeList[23])
ACS$AvgAge <- ((as.numeric(as.character(ACS$AvgAge)))/as.numeric(as.character(ACS$TotalPopulation)))


ACS$numKids <-((as.numeric(as.character(dfSexByAge[-1,]$HD01_VD03))) +
  as.numeric(as.character((dfSexByAge[-1,]$HD01_VD04)))+ 
  as.numeric(as.character((dfSexByAge[-1,]$HD01_VD27)))+ 
  as.numeric(as.character((dfSexByAge[-1,]$HD01_VD28))))

#sum of adults >= 65 years old
ACS$numElderly <-(as.numeric(as.character(dfSexByAge[-1,]$HD01_VD20))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD21))+ 
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD22))+ 
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD23))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD24))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD25))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD44))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD45))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD46))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD47))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD48))+
                        as.numeric(as.character(dfSexByAge[-1,]$HD01_VD49)))



#Calculate percentage of kids and elderly of each block group based on total population
ACS$PercentKids <- ((as.numeric(as.character(ACS$numKids)))/(as.numeric(as.character(ACS$TotalPopulation))))*100
ACS$PercentElderly <- ((as.numeric(as.character(ACS$numElderly)))/(as.numeric(as.character(ACS$TotalPopulation))))*100
################################################################################


#################################################################################
# #Means of transportation to work will be used as a pseudo predictor of income
# #Own vehicle/Carpool/Motorcycle,public transportation, bike/walk/other means
# ACS$numVehicles<-(as.numeric(as.character(dfTransToWork[-1,]$HD01_VD02))+
#                       as.numeric(as.character(dfTransToWork[-1,]$HD01_VD17))
#                       )
# ACS$publicTrans<-(dfTransToWork[-1,]$HD01_VD10)
# 
# ACS$walkOrBike <- (as.numeric(as.character(dfTransToWork[-1,]$HD01_VD18))+
#                        as.numeric(as.character(dfTransToWork[-1,]$HD01_VD19))+
#                        as.numeric(as.character(dfTransToWork[-1,]$HD01_VD20)))
#################################################################################



################################################################################
#Household income will be calculated as an average for the block group, as per midpoint of income range
IncomeMids <- c(5000,12500,17500,22500,27500,32500,37500,42500,47500,55000,67500,87500,112500,137500,175000,250000)
ACS$AvgIncome<-((((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD02)))*IncomeMids[1])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD03)))*IncomeMids[2])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD04)))*IncomeMids[3])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD05)))*IncomeMids[4])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD06)))*IncomeMids[5])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD07)))*IncomeMids[6])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD08)))*IncomeMids[7])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD09)))*IncomeMids[8])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD10)))*IncomeMids[9])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD11)))*IncomeMids[10])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD12)))*IncomeMids[11])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD13)))*IncomeMids[12])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD14)))*IncomeMids[13])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD15)))*IncomeMids[14])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD16)))*IncomeMids[15])+
                   ((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD17)))*IncomeMids[16])))
ACS$AvgIncome <- ((as.numeric(as.character(ACS$AvgIncome)))/(as.numeric(as.character(ACS$TotalPopulation))))
################################################################################



