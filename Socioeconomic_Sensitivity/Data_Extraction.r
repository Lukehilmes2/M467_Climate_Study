#Declare names of all available data tables for 
SexByAge = paste("ACS_16_5YR_B01001_with_ann.csv",sep = "")
TransToWork = paste("ACS_16_5YR_B08301_with_ann.csv",sep = "")
HouseholdType = paste("ACS_16_5YR_B11001_with_ann.csv",sep = "")
PovertyStatus = paste("ACS_16_5YR_B17017_with_ann.csv",sep = "")
HouseholdIncome = paste("ACS_16_5YR_B19001_with_ann.csv",sep = "")
ContractRent = paste("ACS_16_5YR_B25056_with_ann.csv",sep = "")
Value = paste("ACS_16_5YR_B25075_with_ann.csv",sep = "")

#read in csv files of all available data tables for  
dfSexByAge = read.csv(SexByAge)
dfTransToWork = read.csv(TransToWork)
dfHouseholdType = read.csv(HouseholdType)
dfPovertyStatus = read.csv(PovertyStatus)
dfHouseholdIncome = read.csv(HouseholdIncome)
dfContractRent = read.csv(ContractRent)
dfValue = read.csv(Value)

#Declare uniform GeoID and display name column in ACS and total population
ACS  <- cbind.data.frame(dfSexByAge$GEO.id2)
ACS$Display <- (dfSexByAge$GEO.display.label)
ACS$TotalPopulation <- (dfSexByAge$HD01_VD01)
#Rename the columns in ACSto be easier to work with
colnames(ACS ) <- c("GEOID2","Display","TotalPopulation")
ACS  = ACS [-1,]
#We want peple who are more susceptible to illness: Kids and Elderly
#Sum of kids <= 9 years old
head(as.numeric(as.character(dfSexByAge[-1,]$HD01_VD03)))
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

#Means of transportation to work will be used as a pseudo predictor of income
#Own vehicle/Carpool/Motorcycle,public transportation, bike/walk/other means
ACS$numVehicles<-(as.numeric(as.character(dfTransToWork[-1,]$HD01_VD02))+
                      as.numeric(as.character(dfTransToWork[-1,]$HD01_VD17))
                      )
ACS$publicTrans<-(dfTransToWork[-1,]$HD01_VD10)

ACS$walkOrBike <- (as.numeric(as.character(dfTransToWork[-1,]$HD01_VD18))+
                       as.numeric(as.character(dfTransToWork[-1,]$HD01_VD19))+
                       as.numeric(as.character(dfTransToWork[-1,]$HD01_VD20)))
  








