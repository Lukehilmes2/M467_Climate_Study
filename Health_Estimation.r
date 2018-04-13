install.packages("Hmisc")
library(Hmisc)

setwd("C:/Users/luke/Desktop/M467/M467_Climate_Study")
ACS = read.csv("ACS_Trimmed.csv")
MEPS = read.csv("MEPS_AllYears.csv")
summary(MEPS)
summary(ACS)

#Percentiles
p=c(.1,.2,.3,.4,.5,.6,.7,.8,.9)


kAge=rcspline.eval(MEPS$Age,knots = quantile(MEPS$Age,p),nk=9)
kIncome=rcspline.eval(MEPS$Income,knots = quantile(MEPS$Age,p),nk=9)
kEducation=rcspline.eval(MEPS$Education,knots = quantile(MEPS$Age,p),nk=4)

ACSkAge = rcspline.eval(ACS$AvgAge,knots = quantile(ACS$AvgAge,p),nk=9)
ACSkIncome = rcspline.eval(ACS$AvgIncome,knots = quantile(ACS$AvgIncome,p),nk=9)
ACSkEducation = rcspline.eval(ACS$AvgEducation,knots = quantile(ACS$AvgEducation,p),nk=9)
ACSData<- as.data.frame(cbind(as.data.frame(ACSkAge),as.data.frame(ACSkIncome),as.data.frame(ACSkEducation)))
ACSData$Intercept<- rep(1,nrow(ACSData))
ACSData<-ACSData[c(22,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)]
colnames(ACSData) = colnames(testdata)

lm.objTotal = lm(Total.ICD9 ~ kAge+kIncome+kEducation + Employment ,data = MEPS)
lm.objChronic = lm(Chronic.ICD9 ~ kAge+kIncome+kEducation + Employment ,data = MEPS)


testdata = as.data.frame(model.matrix(lm.objTotal))
colnames(ACSData) = colnames(testdata)
testdata[1:76,] = ACSData

x = as.data.frame(predict.lm(lm.objTotal,newdata = testdata))

testdata = as.data.frame(model.matrix(lm.objChronic))
testdata[1:76,] = ACSData
y = as.data.frame(predict(lm.objChronic,newdata = testdata))
x = as.data.frame(x[1:76,])
y = as.data.frame(y[1:76,])
hist(x)
hist(y)


#Linear Regression
######################################################################################################
TotalLinReg<- lm(Total.ICD9 ~ Age + Age**2 + Income + Income**2+ Education + Employment,data = MEPS)
summary(TotalLinReg)

ChronicLinReg<- lm(Chronic.ICD9 ~ Age + Age**2 + Income+ Income**2+ Education + Employment,data = MEPS)
summary(ChronicLinReg)
######################################################################################################




