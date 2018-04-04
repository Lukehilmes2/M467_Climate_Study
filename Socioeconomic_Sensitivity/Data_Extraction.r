#Set working directory to directory containing data files
setwd("C:/Users/luke/Desktop/M467/M467_Climate_Study/Socioeconomic_Sensitivity/ACSData16_5YR")
library(plotly)


#Declare names of all available data tables for 
SexByAge = paste("ACS_16_5YR_B01001_with_ann.csv",sep = "")
HouseholdSize = paste("ACS_16_5YR_B11016_with_ann.csv",sep = "")
Education = paste("ACS_16_5YR_B15003_with_ann.csv",sep = "")
Employment = paste("ACS_16_5YR_B23025_with_ann.csv",sep = "")
HouseholdIncome = paste("ACS_16_5YR_B19001_with_ann.csv",sep = "")
HealthInsurance = paste("ACS_16_5YR_B27010_with_ann.csv",sep = "")


#read in csv files of all available data tables for  
dfSexByAge = read.csv(SexByAge)
dfHouseholdIncome = read.csv(HouseholdIncome)
dfEducation = read.csv(Education) #1-9 1:less than 8th, 2: 9-12, 3: GED or Equiv, 4= HS diploma, 5: some college, 6-7: Assoc, 8: Bach, 9: Masters and PHD 
dfEmployment= read.csv(Employment) 
dfHouseholdSize= read.csv(HouseholdSize) #Maybe
dfHealthInsurance= read.csv(HealthInsurance) #Maybe



#Declare uniform GeoID and display name column in ACS and total population
ACS  <- cbind.data.frame(dfSexByAge$GEO.id2)
ACS$Display <- (dfSexByAge$GEO.display.label)
ACS$TotalPopulation <- (as.numeric(as.character(dfSexByAge$HD01_VD01)))

#Rename the columns in ACSto be easier to work with
colnames(ACS) <- c("GEOID2","Display","TotalPopulation")
ACS  = ACS [-1,]

################################################################################
#We want peple who are more susceptible to illness: Kids and Elderly
#List of midpoints determined by the age ranges given by the Census Bureau data
AgeList <- c(2.5,7.5,12,16,18.5,20,21,23,27.5,32,37.5,42,47.5,52,57.5,60.5,63,65.5,68,72,77.5,82,85)

#Muliply the number of individuals in each age range by the midpoint of that age range
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

#Divide the total age sums by the population of the block group
ACS$AvgAge <- ((as.numeric(as.character(ACS$AvgAge)))/as.numeric(as.character(ACS$TotalPopulation)))

#Sum of kids <= 9 years old
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

#Total number of individuals per block group <= 20 years old
ACS$NonIncomePopulation <- (as.numeric(as.character(dfSexByAge[-1,]$HD01_VD03))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD04))+ 
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD05))+ 
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD06))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD07))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD08))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD27))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD28))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD29))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD30))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD31))+
                           as.numeric(as.character(dfSexByAge[-1,]$HD01_VD32)))

#Calculate percentage of kids and elderly of each block group based on total population
ACS$PercentKids <- ((as.numeric(as.character(ACS$numKids)))/(as.numeric(as.character(ACS$TotalPopulation))))*100
ACS$PercentElderly <- ((as.numeric(as.character(ACS$numElderly)))/(as.numeric(as.character(ACS$TotalPopulation))))*100
################################################################################


################################################################################
#Household income will be calculated as an average for the block group, as per midpoint of income range

#Income Midpoint for individuals above $200,000 income taken from https://en.wikipedia.org/wiki/Household_income_in_the_United_States
#Distribution of household incomes for the United States(2014)
#($200,000 - $250,000) 2.61% @ 220,267  & ($250,000 and over) 3.02% & 402,476 (percentage of population @ mean income)

x<- 2.61/(2.61+3.02) #Determine proportions for $200,000-$250,000
y = 1-x              #Determine prportions for >$250,000
MaxIncomeMidpoint= (x*220267)+(y*402476) #sum proportions*median income for each range to determine the midpoint of individuals w/ income over $200,000

IncomeMids <- c(5000,12500,17500,22500,27500,32500,37500,42500,47500,55000,67500,87500,112500,137500,175000,MaxIncomeMidpoint)
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

#Total income for the block group divided by the total population with individuals <= 20 years old subtracted
ACS$AvgIncome <- ((as.numeric(as.character(ACS$AvgIncome)))/((as.numeric(as.character(ACS$TotalPopulation)))-(as.numeric(as.character(ACS$NonIncomePopulation)))))

################################################################################


################################################################################
#Education will be grouped 1-9: 1:less than 8th grade, 2: 9-12, 3: GED or Equiv, 4= HS diploma,
#5: some college, 6-7: Assoc, 8: Bach, 9: Masters and PHD
#to match MEPS data and determine a quantitative value for average education of a block group

#Average education computed by multiplying the amounts of individuals in each education group by the corresponding
#number associated with the MEPS data identifiers and divided by the estimate total of individuals surveyed by the Census Bureau

LTEight <- (as.numeric(as.character(dfEducation[-1,]$HD01_VD02)))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD03))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD04))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD05))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD06))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD07))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD08))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD09))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD10))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD11))))+
                          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD12))))

Nine_Twelve <- (as.numeric(as.character(dfEducation[-1,]$HD01_VD13)))+
                ((as.numeric(as.character(dfEducation[-1,]$HD01_VD14))))+
                ((as.numeric(as.character(dfEducation[-1,]$HD01_VD15))))+
                ((as.numeric(as.character(dfEducation[-1,]$HD01_VD16))))*2

GED <- ((as.numeric(as.character(dfEducation[-1,]$HD01_VD18))))*3

HSDiploma<-((as.numeric(as.character(dfEducation[-1,]$HD01_VD17))))*4

SomeCollege<-((as.numeric(as.character(dfEducation[-1,]$HD01_VD19))))+
              ((as.numeric(as.character(dfEducation[-1,]$HD01_VD20))))*5

Assoc<-((as.numeric(as.character(dfEducation[-1,]$HD01_VD21))))*6.5

Bach<-((as.numeric(as.character(dfEducation[-1,]$HD01_VD22))))*8

Masters<-(as.numeric(as.character(dfEducation[-1,]$HD01_VD23)))+
          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD24))))+
          ((as.numeric(as.character(dfEducation[-1,]$HD01_VD25))))*9

ACS$AvgEducation<-(LTEight+Nine_Twelve+GED+HSDiploma+SomeCollege+Assoc+Bach+Masters)/(as.numeric(as.character(dfEducation[-1,]$HD01_VD01)))
################################################################################


################################################################################
#Employment for the block groups will be calculated as the total number 
#of unemployed individuals and the total of employed individuals
ACS$Unemployed<-(as.numeric(as.character(dfEmployment[-1,]$HD01_VD05)))+
                ((as.numeric(as.character(dfEmployment[-1,]$HD01_VD07))))
ACS$Employed<-(as.numeric(as.character(dfEmployment[-1,]$HD01_VD04)))+
              ((as.numeric(as.character(dfEmployment[-1,]$HD01_VD06))))
ACS$ProportionEmployed <- ACS$Employed/(as.numeric(as.character(dfEmployment[-1,]$HD01_VD01)))

################################################################################



################################################################################
#PLOTS
#AGE HISTOGRAM
x <- list(
  title = "Age (Years)"
)
fit<-density(ACS$AvgAge)
med <- median(ACS$AvgAge)
p<-plot_ly(x = ACS$AvgAge,type = 'histogram',nbinsx = 10,name = "Age")%>%
  layout(title = "Histogram of Average Ages in Block Groups of Missoula County",xaxis = x)%>% 
  add_trace(x = c(med,med),y = c(0,35),type = 'scatter',mode = 'lines',name = 'Median') %>% 
  add_trace(x = fit$x, y = fit$y, type = "scatter", mode = "lines", yaxis = "y2", name = "Density") %>% 
  layout(yaxis2 = list(overlaying = "y", side = "right"))
p

#INCOME HISTOGRAM
x <- list(
  title = "Income (Dollars)"
)
fit<-density(ACS$AvgIncome)
med <- median(ACS$AvgIncome)
p<-plot_ly(x = ACS$AvgIncome,type = 'histogram',name="Income")%>%
  layout(title = "Histogram of Average Income in Block Groups of Missoula County",xaxis = x)%>% 
  add_trace(x = c(med,med),y = c(0,11),type = 'scatter',mode = 'lines',name = 'Median') %>% 
  add_trace(x = fit$x, y = fit$y, type = "scatter", mode = "lines", yaxis = "y2", name = "Density") %>% 
  layout(yaxis2 = list(overlaying = "y", side = "right"))
p

#EDUCATION HISTOGRAM
x <- list(
  title = "Education"
)
fit<-density(ACS$AvgEducation)
med <- median(ACS$AvgEducation)
p<-plot_ly(x = ACS$AvgEducation,type = 'histogram',name="Education")%>%
  layout(title = "Histogram of Average Education in Block Groups of Missoula County",xaxis = x)%>% 
  add_trace(x = c(med,med),y = c(0,17),type = 'scatter',mode = 'lines',name = 'Median') %>% 
  add_trace(x = fit$x, y = fit$y, type = "scatter", mode = "lines", yaxis = "y2", name = "Density") %>% 
  layout(yaxis2 = list(overlaying = "y", side = "right"))
p
################################################################################

#set working directory to directory where the csv is wanted and output ACS data frame as csv
setwd("C:/Users/luke/Desktop/M467/M467_Climate_Study/Socioeconomic_Sensitivity")
write.csv(ACS,"ACS_BlockGroupData.csv")

TrimmedACS = cbind(as.character(ACS$GEOID2),as.character(ACS$Display),ACS$AvgAge,ACS$AvgIncome,ACS$AvgEducation,ACS$ProportionEmployed)
