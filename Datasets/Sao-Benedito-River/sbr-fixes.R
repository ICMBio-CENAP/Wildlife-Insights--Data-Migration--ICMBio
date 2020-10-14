
#setwd("C:/Users/Elildo/elildocarvalhojr/r/cachimbo")


## ----Load data from Serra do Cachimbo-------
datacachimbo <- read.csv("Wild_ID_POC Final.csv")

datacachimbo$Camera.Start.Date <- as.Date(datacachimbo$Camera.Start.Date, format="%Y-%m-%d")
datacachimbo$Camera.End.Date <- as.Date(datacachimbo$Camera.End.Date, format="%Y-%m-%d")
datacachimbo$Photo.Date <- as.Date(datacachimbo$Photo.Date, format="%Y-%m-%d")

datacachimbo$Project.Name <- "Sao-Benedito-River"
datacachimbo$Sampling.Event <- 2017
datacachimbo$Person.Identifying.the.Photo <- "Paula Conde"
datacachimbo$Person.setting.up.the.Camera <- "Elildo Carvalho Jr"
datacachimbo$Person.picking.up.the.Camera <- "Leonardo Sartorello"
datacachimbo$Organization.Name <- "ICMBio/CENAP"
datacachimbo$Camera.Trap.Name <- gsub("CT-POC-1", "CT-SBR-1", datacachimbo$Camera.Trap.Name)


time.lag(datacachimbo)
# fix:
datacachimbo[datacachimbo$Camera.Trap.Name=="CT-SBR-1-06",]$Camera.End.Date <- max(subset(datacachimbo, Camera.Trap.Name=="CT-SBR-1-06")$Photo.Date)
datacachimbo[datacachimbo$Camera.Trap.Name=="CT-SBR-1-08",]$Camera.End.Date <- max(subset(datacachimbo, Camera.Trap.Name=="CT-SBR-1-08")$Photo.Date)
time.lag(datacachimbo) # check

write.csv(datacachimbo, "/media/elildojr/Ubuntu 20.04 LTS amd64/Sao-Benedito-River/Wild_ID_SBR_2017.csv", row.names = FALSE)
