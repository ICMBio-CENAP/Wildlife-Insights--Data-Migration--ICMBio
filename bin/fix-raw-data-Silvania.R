# Read and fix raw data
# Flona de Silvania


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

silvania <- f.readin.fix.data("/home/elildojr/Documents/r/REST-REM/silvania-temporario/Wild_ID_silvania.csv")

silvania$Sampling.Event <- 2017
silvania$Camera.Trap.Name <- as.factor(silvania$Camera.Trap.Name)
levels(silvania$Camera.Trap.Name)
colnames(silvania)
colnames(silvania)[9] <- "Photo.Time"

## add location column
# location is the path to the image file and will be needed for the Wildlife Insights batch upload
silvania$location <- paste(paste("FNS_2019_", silvania$Camera.Trap.Name, sep=""), silvania$Raw.Name, sep="/")
#View(silvania)

# check date errors
min(silvania$Camera.Start.Date); max(silvania$Camera.End.Date)
min(silvania$Photo.Date); max(silvania$Photo.Date)
sort(unique(silvania$Photo.Date))

# fix wrong end date using max photo date
for(i in 1:nrow(silvania)){ 
  if (silvania$Camera.End.Date[i] > max(silvania$Photo.Date)) {
    df1 <- subset(silvania, Camera.Trap.Name == silvania$Camera.Trap.Name[i])
    max <- max(df1$Photo.Date)
    silvania$Camera.End.Date[i] <-  max + 1
  }
}

sort(unique(silvania$Camera.Start.Date)) # check, OK
min(silvania$Camera.Start.Date); max(silvania$Camera.End.Date)

# check time lag between start and end and first and last photos
time.lag(silvania) # check, everything Ok

# save as csv
write.csv(sbr, here("data", "Wild_ID_Silvania_2019.csv"), row.names=FALSE)

