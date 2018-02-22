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

ACS$numKids <-((as.numeric(as.character(dfSexByAge[-1,]$HD01_VD03)))+
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
ACS$PercentKids <- ((as.numeric(as.character(ACS$numKids)))/(as.numeric(as.character(ACS$TotalPopulation))))
ACS$PercentElderly <- ((as.numeric(as.character(ACS$numElderly)))/(as.numeric(as.character(ACS$TotalPopulation))))
################################################################################


# ################################################################################
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
# ################################################################################


################################################################################
#Houshold income will be split between people who make less than average and more than average($45,000)
ACS$TotalIncomeCollectors<-(dfHouseholdIncome[-1,]$HD01_VD01)
ACS$BelowAvgIncome<-((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD02)))+
                     (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD03)))+
                     (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD04)))+
                     (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD05)))+
                     (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD06)))+
                     (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD07)))+
                     (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD08)))+
                     (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD09))))

ACS$AboveAvgIncome<-((as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD10)))+
                       (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD11)))+
                       (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD12)))+
                       (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD13)))+
                       (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD14)))+
                       (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD15)))+
                       (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD16)))+
                       (as.numeric(as.character(dfHouseholdIncome[-1,]$HD01_VD17))))

ACS$PercentBelowAvgIncome<-((as.numeric(as.character(ACS$BelowAvgIncome)))/
                              (as.numeric(as.character(ACS$TotalIncomeCollectors))))

ACS$PercentAboveAvgIncome<-((as.numeric(as.character(ACS$AboveAvgIncome)))/
                              (as.numeric(as.character(ACS$TotalIncomeCollectors))))
################################################################################



