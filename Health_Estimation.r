library(Hmisc)

#Set working directory to directory with data files
setwd("C:/Users/luke/Desktop/M467/M467_Climate_Study")
#Read in ACS and MEPS data
ACS = read.csv("ACS_Trimmed.csv")
MEPS = read.csv("MEPS_AllYears.csv")

#Percentiles
p=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)

#Compute cubic splines of Age, Income, and Education from MEPS data
#Number of knots is 9
knots<-9

kAge=rcspline.eval(MEPS$Age,knots = quantile(MEPS$Age,p),nk=knots)
kIncome=rcspline.eval(MEPS$Income,knots = quantile(MEPS$Age,p),nk=knots)
kEducation=rcspline.eval(MEPS$Education,knots = quantile(MEPS$Age,p),nk=knots)

#Compute cubic splines of Age, Income, and Educations from ACS data
ACSkAge = rcspline.eval(ACS$AvgAge,knots = quantile(ACS$AvgAge,p),nk=knots)
ACSkIncome = rcspline.eval(ACS$AvgIncome,knots = quantile(ACS$AvgIncome,p),nk=knots)
ACSkEducation = rcspline.eval(ACS$AvgEducation,knots = quantile(ACS$AvgEducation,p),nk=knots)

#Create new data frame by column binding the spline output and the binary employment data
ACSData<- as.data.frame(cbind(as.data.frame(ACSkAge),as.data.frame(ACSkIncome),
                              as.data.frame(ACSkEducation),ACS$ProportionEmployed))

#Create an intercept column to match MEPS spline data
ACSData$Intercept<- rep(1,nrow(ACSData))

#Rearrange data frame to match MEPS spline data
ACSData<-ACSData[c(23,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22)]

#Create a linear model to map Total ICD9 codes and Chronic ICD9 codes to the computed
#splines corresponding to Age, Income, Education, and the binary variable, Employment
lm.objTotal = lm(Total.ICD9 ~ kAge+kIncome+kEducation + Employment ,data = MEPS)
lm.objChronic = lm(Chronic.ICD9 ~ kAge+kIncome+kEducation + Employment ,data = MEPS)

#Set test data frame to the data frame used in the linear model
TotalICD9testdata = as.data.frame(model.matrix(lm.objTotal))
ChronicICD9testdata = as.data.frame(model.matrix(lm.objChronic))

#Match the column names in the ACS data set to the test data set
colnames(ACSData) = colnames(TotalICD9testdata)

#Set the first 76 (amount of block groups in Missoula County) rows of the test data to the computed ACS data
TotalICD9testdata[1:nrow(ACSData),] = ACSData
ChronicICD9testdata[1:nrow(ACSData),] = ACSData

#Compute the estimated amount of Total and Chronic ICD9 codes based on linear model
EstimateTotalICD9 = as.data.frame(predict.lm(lm.objTotal,newdata = TotalICD9testdata))
EstimateChronicICD9 = as.data.frame(predict(lm.objChronic,newdata = ChronicICD9testdata))

#Reduce the output data set to show only the block groups of Missoula County
EstimateTotalICD9 = as.data.frame(x[1:76,])
EstimateChronicICD9 = as.data.frame(y[1:76,])

#Create columns in ACS data to store Total and Chronic ICD9 code estimates
ACS <-cbind(ACS,EstimateTotalICD9,EstimateChronicICD9)
colnames(ACS) <- c("X","GEOID2","Display","AvgAge","AvgIncome","AvgEducation","ProportionEmployed","TotalICD9Estimate","ChronicICD9Estimate")
#Plot histograms of estimated ICD9 codes
hist(EstimateTotalICD9)
hist(EstimateChronicICD9)





