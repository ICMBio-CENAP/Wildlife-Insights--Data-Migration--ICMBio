# Read and fix raw data
# Sao Benedito River, Brazilian Amazonia


##----- 1 - Load libraries-----
library(stringr)
library(here)
library(tidyverse)
library(dplyr)


## ----Source this file--------
source(here("bin", "ahumada_codes.R"))
source(here("bin", "time-lag.R"))
source(here("bin", "check-coords.R"))


##----- 2 - Read and fix raw data-----

#sbr <- f.readin.fix.data(here("data", "Wild_ID_SBR_2017.csv"))
f.readin.fix.data("/home/elildojr/Documents/r/Wildlife-Insights--Data-Migration--ICMBio/Datasets/Sao-Benedito-River/Wild_ID_SBR_2017.csv")

sbr$Sampling.Event <- 2017
sbr$Camera.Trap.Name <- as.factor(sbr$Camera.Trap.Name)
levels(sbr$Camera.Trap.Name)
colnames(sbr)
colnames(sbr)[9] <- "Photo.Time"

## add location column
# location is the path to the image file and will be needed for the Wildlife Insights batch upload
sbr$location <- paste(sbr$Camera.Trap.Name, sbr$Raw.Name, sep="/")
#View(sbr)

# check date errors
min(sbr$Camera.Start.Date); max(sbr$Camera.End.Date)
min(sbr$Photo.Date); max(sbr$Photo.Date)
sort(unique(sbr$Photo.Date))

# fix wrong end date using max photo date
for(i in 1:nrow(sbr)){ 
  if (sbr$Camera.End.Date[i] > max(sbr$Photo.Date)) {
    df1 <- subset(sbr, Camera.Trap.Name == sbr$Camera.Trap.Name[i])
    max <- max(df1$Photo.Date)
    sbr$Camera.End.Date[i] <-  max
  }
 }

sort(unique(sbr$Camera.Start.Date)) # check, OK
min(sbr$Camera.Start.Date); max(sbr$Camera.End.Date)

# check time lag between start and end and first and last photos
time.lag(sbr) # check, everything Ok

# save as csv
write.csv(sbr, here("data", "Wild_ID_SBR_2017.csv"), row.names=FALSE)

