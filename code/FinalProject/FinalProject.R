install.packages("devtools")
install.packages("mgcv")
install.packages("MuMIn")
library(devtools)
library(mgcv)
library(MuMIn)
install_github("USGS-R/dataRetrieval")

library(dataRetrieval)
?readNWISuv
#turbidity data code 63680

#Gathering the data needed
setwd("C:/GitHub/Sherinskynl/code/FinalProject")
macroinvert <- read.csv("EighteenmileCreek.csv")
eighteenturb <- readNWISuv("04219768","63680","2021-08-03","2021-08-04")
head(eighteenturb)
oakorc <- readNWISuv("0422016550","63680", "2021-08-04","2021-08-05")
head(oakorc)

#Formatting the data tables to make mean gathering more direct
eighteenturb2 <- eighteenturb[,-1]
eighteenturb3 <- eighteenturb2[,-4:-5]
head(eighteenturb3)
colnames(eighteenturb3) <- c("Water.Body","dateTime","turbidity")
head(eighteenturb3)

oakorc2 <- oakorc[,-1]
oakorc3 <- oakorc2[,-4:-5]
colnames(oakorc3) <- c("Water.Body","dateTime","turbidity")
head(oakorc3)

head(macroinvert)
macroinvert2 <-macroinvert[,-2]
head(macroinvert2)
macroinvert3 <-macroinvert2[,-3:-10]
head(macroinvert3)
macroinvert4 <- macroinvert3[,-4:-6]
head(macroinvert4)

#Renaming values for ease of merging
eighteenturb3$Date <- format(as.POSIXct(eighteenturb3$dateTime,format='%Y-%m-%d %H:%M:%S'),format='%m/%d/%Y')
head(eighteenturb3)    

oakorc3$Date <- format(as.POSIXct(oakorc3$dateTime,format='%Y-%m-%d %H:%M:%S'),format='%m/%d/%Y')
head(oakorc3)

install.packages("stringr")
library(stringr)

eighteenturb3$Water.Body <- str_replace(eighteenturb3$Water.Body, "04219768", "Eighteenmile Creek")
head(eighteenturb3)

oakorc3$Water.Body <- str_replace(oakorc3$Water.Body, "0422016550", "Oak Orchard Creek")
head(oakorc3)

#means to have the same number of columns - Why did you do this step? 
#Analysis could have worked without taking means first and put the variability to use.
macro.mean <- aggregate(macroinvert4$Diversity.Score ~ macroinvert4$Water.Body + macroinvert4$Date.Sampled, FUN = "mean")
head(macro.mean)

eight.mean <- aggregate(eighteenturb3$turbidity ~eighteenturb3$Date + eighteenturb3$Water.Body, FUN = "mean")
head(eight.mean)

oak.mean <- aggregate(oakorc3$turbidity ~oakorc3$Date + oakorc3$Water.Body, FUN = "mean")
head(oak.mean)

#merging the three data sets
?merge
colnames(oak.mean) <- c("Date","Water.Body","turbidity")

colnames(eight.mean) <- c("Date","Water.Body","turbidity")
 
colnames(macro.mean) <- c("Water.Body","Date","Diversity.score")

macro.mean$Date <- format(as.POSIXct(macro.mean$Date,format='%m/%d/%Y'),format='%m/%d/%Y')

Creeks <- rbind(oak.mean,eight.mean)


macro.creeks <- merge(macro.mean,Creeks, by = c("Date","Water.Body"))

#data analysis
library(mgcv)
?mgcv
?gam

gam.mod1 <- gam(Diversity.score~ Water.Body, family = Gamma, random = list(ID=~1), data = macro.creeks)
AIC(gam.mod1)
gam.mod2 <- gam(Diversity.score~ turbidity, family = Gamma, random = list(ID=~1), data = macro.creeks)
AIC(gam.mod2)
gam.diverse <- gam(Diversity.score~ turbidity + Water.Body, family = Gamma, random = list(ID=~1), data = macro.creeks)
summary(gam.diverse)
  #Where is the summary for the other two GAM's?
summary(gam.mod1)
summary(gam.mod2)


plot(gam.diverse$residuals, ylim = c(-.1,.1), ylab = "GAM Residuals", main = "Residuals for Generalized Additive Model")
#Why are we looking at the residuals and a cleaned up plot? This makes it look like the GAM is a poor fit as well.

vis.gam(gam.diverse, view=c("turbidity","Water.Body"), theta = 45, color = "heat")
AIC(gam.diverse)
AIC(gam.mod1,gam.mod2,gam.diverse)


#Plotting the data
macro.creeks$Labels <- c("EighteenMile8.3.21","EighteenMile8.4.21","OakOrchard8.4.21","OakOrchard8.5.21")
plot(macro.creeks$Diversity.score, macro.creeks$turbidity, xlim = c(0,10),xlab = "Diversity Score",ylab = "Turbidity", main = "Comparing Diversity and Turbidity in Creeks in New York")
text(macro.creeks$Diversity.score, macro.creeks$turbidity, labels = macro.creeks$Labels)

boxplot(Diversity.score*turbidity ~ Water.Body, data = macro.creeks, ylim = c(0,35), xlab = "Water Body", ylab = "Diversity Score and Turbidity", main = "Divsersity combinded with Trubidity")
#This is an interesting idea/approach. would be good to see what each looks like individually too and stats to match the figure!


