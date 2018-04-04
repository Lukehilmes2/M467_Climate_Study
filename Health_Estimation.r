setwd("C:/Users/luke/Desktop/M467/M467_Climate_Study/Health_Sensitivity")
Meps2013 = read.csv("2013_MepsData2.csv")
Meps2014 = read.csv("2014_MepsData2.csv")
Meps2015 = read.csv("2015_MepsData2.csv")
MEPS = rbind(Meps2013,Meps2014,Meps2015)

setwd("C:/Users/luke/Desktop/M467/M467_Climate_Study/Socioeconomic_Sensitivity")
ACS = read.csv("ACS_BlockGroupData.csv")
