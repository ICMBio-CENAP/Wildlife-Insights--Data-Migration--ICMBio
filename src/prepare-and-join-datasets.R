# Code to create the files needed for Wildlife Insights bulk upload
# Read exports from various sources, join them and create the four required files

##----- 1 - Load libraries-----
library(tidyverse)
library(stringr)
library(here)
source(here("bin", 'wi_functions.R'))


##----- 2 - read datasets-----
gurupi <- read.csv(here("data", "Wild_ID_RBG_2016to2019.csv"))
gurupiRoads <- read.csv(here("data", "Wild_ID_RBG_ROADS_2015to2017_processed.csv"))
juruena <- read.csv(here("data", "Wild_ID_PNJU_2016to2019.csv"))
maraca <- read.csv(here("data", "Wild_ID_maraca_2018.csv"))
tdm <- read.csv(here("data", "Wild_ID_TDM_2016to2018.csv"))
#jamari <- read.csv(here("data", "Wild_ID_FNJ_2016to2019.csv")
sbr <- read.csv(here("data", "Wild_ID_SBR_2017.csv"))
# silvania: was already exported in WI format. Read it in the end and rbind with the rest


##----- 3 - standardize columns etc in the datasets-----

# Gurupi
gurupi$Photo.time <- substr(gurupi$td.photo, 12, nchar(gurupi$td.photo))
gurupi <- gurupi[,c("Camera.Trap.Name", "Project.Name", "Sampling.Event", "Longitude", "Latitude", "Camera.Start.Date", "Camera.End.Date", "Raw.Name", "Photo.Type",
                    "Person.Identifying.the.Photo", "Genus", "Species", "Photo.Date", "Photo.time", "Number.of.Animals",
                    "Camera.Manufacturer", "Camera.Model", "Camera.Serial.Number", "Person.setting.up.the.Camera",
                    "Person.picking.up.the.Camera", "Person.Identifying.the.Photo", "Organization.Name", "location")]

gurupi$Project.ID <- "RBG"
gurupi$Owner.Email <- "elildojr@gmail.com"
gurupi$Principal.Investigator <- "Elildo Carvalho Jr"
gurupi$Principal.Investigator.Email <- "elildojr@gmail.com"
gurupi$Project.Contact <- "Elildo Carvalho Jr"
gurupi$Project.Contact.Email = "elildojr@gmail.com"
gurupi$Array.Name <- substr(gurupi$Camera.Trap.Name, 1, stop = 8)

#GurupiRoads
gurupiRoads$Photo.time <- substr(gurupiRoads$td.photo, 12, nchar(gurupiRoads$td.photo))
gurupiRoads <- gurupiRoads[,c("Camera.Trap.Name", "Project.Name", "Sampling.Event", "Longitude", "Latitude", "Camera.Start.Date", "Camera.End.Date", "Raw.Name", "Photo.Type",
                    "Person.Identifying.the.Photo", "Genus", "Species", "Photo.Date", "Photo.time", "Number.of.Animals",
                    "Camera.Manufacturer", "Camera.Model", "Camera.Serial.Number", "Person.setting.up.the.Camera",
                    "Person.picking.up.the.Camera", "Person.Identifying.the.Photo", "Organization.Name", "location")]

gurupiRoads$Project.ID <- "RBG"
gurupiRoads$Owner.Email <- "elildojr@gmail.com"
gurupiRoads$Principal.Investigator <- "Elildo Carvalho Jr"
gurupiRoads$Principal.Investigator.Email <- "elildojr@gmail.com"
gurupiRoads$Project.Contact <- "Elildo Carvalho Jr"
gurupiRoads$Project.Contact.Email = "elildojr@gmail.com"
gurupiRoads$Array.Name <- substr(gurupiRoads$Camera.Trap.Name, 1, stop = 8)


# Juruena
juruena <- juruena[,c("Camera.Trap.Name", "Project.Name", "Sampling.Event", "Longitude", "Latitude", "Camera.Start.Date", "Camera.End.Date", "Raw.Name", "Photo.Type",
                      "Person.Identifying.the.Photo", "Genus", "Species", "Photo.Date", "Photo.time", "Number.of.Animals",
                      "Camera.Manufacturer", "Camera.Model", "Camera.Serial.Number", "Person.setting.up.the.Camera",
                      "Person.picking.up.the.Camera", "Person.Identifying.the.Photo", "Organization.Name", "location")]

juruena$Project.ID <- "PNJU"
juruena$Owner.Email <- "elildojr@gmail.com"
juruena$Principal.Investigator <- "Elildo Carvalho Jr"
juruena$Principal.Investigator.Email <- "elildojr@gmail.com"
juruena$Project.Contact <- "Elildo Carvalho Jr"
juruena$Project.Contact.Email = "elildojr@gmail.com"
juruena$Array.Name <- substr(juruena$Camera.Trap.Name, 1, stop = 9)


# maraca
maraca$Photo.time <- substr(maraca$td.photo, 12, nchar(maraca$td.photo))
maraca <- maraca[,c("Camera.Trap.Name", "Project.Name", "Sampling.Event", "Longitude", "Latitude", "Camera.Start.Date", "Camera.End.Date", "Raw.Name", "Photo.Type",
                    "Person.Identifying.the.Photo", "Genus", "Species", "Photo.Date", "Photo.time", "Number.of.Animals",
                    "Camera.Manufacturer", "Camera.Model", "Camera.Serial.Number", "Person.setting.up.the.Camera",
                    "Person.picking.up.the.Camera", "Person.Identifying.the.Photo", "Organization.Name", "location")]

maraca$Project.Name <- "Maraca"
maraca$Project.ID <- "EEM"
maraca$Owner.Email <- "elildojr@gmail.com"
maraca$Principal.Investigator <- "Whaldener Endo"
maraca$Principal.Investigator.Email <- "neotropical@gmail.com"
maraca$Project.Contact <- "Bruno Campos Souza"
maraca$Project.Contact.Email = "bruno-campos.souza@icmbio.gov.br"
maraca$Array.Name <- substr(maraca$Camera.Trap.Name, 1, stop = 8)


# tdm
tdm <- tdm[,c("Camera.Trap.Name", "Project.Name", "Sampling.Event", "Longitude", "Latitude", "Camera.Start.Date", "Camera.End.Date", "Raw.Name", "Photo.Type",
                    "Person.Identifying.the.Photo", "Genus", "Species", "Photo.Date", "Photo.time", "Number.of.Animals",
                    "Camera.Manufacturer", "Camera.Model", "Camera.Serial.Number", "Person.setting.up.the.Camera",
                    "Person.picking.up.the.Camera", "Person.Identifying.the.Photo", "Organization.Name", "location")]

tdm$Project.Name <- "Terra-do-Meio"
tdm$Project.ID <- "TDM"
tdm$Owner.Email <- "elildojr@gmail.com"
tdm$Principal.Investigator <- "Elildo Carvalho Jr"
tdm$Principal.Investigator.Email <- "elildojr@gmail.com"
tdm$Project.Contact <- "Elildo Carvalho Jr"
tdm$Project.Contact.Email = "elildojr@gmail.com"
tdm$Array.Name <- substr(tdm$Camera.Trap.Name, 1, stop = 8)


# sbr
sbr$Photo.time <- substr(sbr$td.photo, 12, nchar(sbr$td.photo))
sbr <- sbr[,c("Camera.Trap.Name", "Project.Name", "Sampling.Event", "Longitude", "Latitude", "Camera.Start.Date", "Camera.End.Date", "Raw.Name", "Photo.Type",
              "Person.Identifying.the.Photo", "Genus", "Species", "Photo.Date", "Photo.time", "Number.of.Animals",
              "Camera.Manufacturer", "Camera.Model", "Camera.Serial.Number", "Person.setting.up.the.Camera",
              "Person.picking.up.the.Camera", "Person.Identifying.the.Photo", "Organization.Name", "location")]

sbr$Project.Name <- "Sao-Benedito-River"
sbr$Project.ID <- "SBR"
sbr$Owner.Email <- "elildojr@gmail.com"
sbr$Principal.Investigator <- "Elildo Carvalho Jr"
sbr$Principal.Investigator.Email <- "elildojr@gmail.com"
sbr$Project.Contact <- "Elildo Carvalho Jr"
sbr$Project.Contact.Email = "elildojr@gmail.com"
sbr$Array.Name <- substr(sbr$Camera.Trap.Name, 1, stop = 8)
sbr[sbr$Camera.Trap.Name=="CT-SBR-1-22",]$Longitude <- -56.53005
sbr[sbr$Camera.Trap.Name=="CT-SBR-1-22",]$Latitude <- -9.06317


## WARNING: Silvania and Jamari missing!!!


##----- 4 - Join datasets in a single object-----

dim(gurupi); dim(gurupiRoads); dim(juruena); dim(maraca); dim(tdm); dim(jamari); dim(silvania); dim(sbr)

#icmbio <- rbind(gurupi, gurupiRoads, juruena, maraca, tdm, jamari, sbr)
icmbio <- rbind(gurupi, gurupiRoads, juruena, maraca, tdm, sbr)
dim(icmbio)


##----- 5 - Get the object into the format required for WI-----
attach(icmbio)

# create "Image" file from csv
Image <- tibble("Project ID" = Project.ID, "Deployment ID" = paste(Camera.Trap.Name, Camera.Start.Date), 
                "Image ID" = paste(Camera.Trap.Name, Raw.Name, sep="_"),
                "Location" =  location, 
                "Photo Type" =  Photo.Type, "Photo Type Identified by" =  Person.Identifying.the.Photo,
                "Genus Species" = paste(Genus, Species, sep=" "), "Uncertainty" = NA,
                "IUCN Identification Number" = NA, "Date_Time Captured" = paste(Photo.Date, Photo.time, sep=" "),
                "Age" = NA,  "Sex" = NA, "Individual ID" = NA,  "Count" =  Number.of.Animals,
                "Animal recognizable (Y/N)" = NA, "Individual Animal Notes" = NA) 

# create "Deployment" file from csv
Deployment <- tibble("Deployment ID" = paste(Camera.Trap.Name, Camera.Start.Date), "Event Name" = Sampling.Event,
                     "Array Name (Optional)" = Array.Name, "Deployment Location ID" = Camera.Trap.Name,
                     "Longitude Resolution" = Longitude, "Latitude Resolution" = Latitude, 
                     "Camera Deployment Begin Date" = Camera.Start.Date, "Camera Deployment End Date" = Camera.End.Date,
                     "Bait Type" = "No Bait", "Bait Description" = NA, "Feature Type" = NA,
                     "Feature Type Methodology" = NA, "Camera ID" =  Camera.Serial.Number, "Quiet Period Setting" = NA,
                     "Restriction on Access" = NA, "Camera Failure Details" = NA,  "Camera Hardware Failure" = NA)
Deployment <- Deployment %>% distinct(`Deployment ID`, .keep_all = TRUE)

# create "Cameras" file from csv
Cameras <- tibble("Project ID" = Project.ID, "Camera ID" = Camera.Serial.Number, 
                  "Make" = Camera.Manufacturer, "Model" = Camera.Model, 
                  "Serial Number" = Camera.Serial.Number, "Year Purchased" = 2016)

Cameras <- Cameras %>% distinct(`Camera ID`, .keep_all = TRUE)

# Create "Project" file from csv 
Project <- tibble("Project ID" = Project.ID, "Publish Date" = "2020-11-15", "Project Name" = Project.Name,
                  "Project Objectives" = "Long-term wildlife monitoring", "Project Owner (Organization or Individual)" = "ICMBio/CENAP",
                  "Project Owner Email (if applicable)" = Owner.Email,  "Principal Investigator" = Principal.Investigator,
                  "Principal Investigator Email" = Principal.Investigator.Email, "Project Contact" = Project.Contact,  "Project Contact Email" = Project.Contact.Email,
                  "Country Code" = "BRA",  "Project Data Use and Constraints" = NA)
Project <- Project %>% distinct(`Project ID`, .keep_all = TRUE)


##----- 5 - Add Silvania-----
dir_path <- paste(here("data"), "/", sep="")

# Load Wild.ID export Silvania
images_1 <- read_excel(paste(dir_path,"Wild_ID_FNS.xlsx",sep=""),sheet="Image")
deployments_1 <- read_excel(paste(dir_path,"Wild_ID_FNS.xlsx",sep=""),sheet="Deployment")
cameras_1 <- read_excel(paste(dir_path,"Wild_ID_FNS.xlsx",sep=""),sheet="Cameras")
projects_1 <- read_excel(paste(dir_path,"Wild_ID_FNS.xlsx",sep=""),sheet="Project")

# some edits
images_1$`Deployment ID` <- paste(gsub("FNS_2019_", "", images_1$`Deployment ID`), "2019", sep=" ")
deployments_1$`Deployment ID` <- paste(gsub("FNS_2019_", "", deployments_1$`Deployment ID`), "2019", sep=" ")
deployments_1$`Camera Deployment Begin Date` <- gsub("November", "11", deployments_1$`Camera Deployment Begin Date`)
deployments_1$`Camera Deployment Begin Date` <- gsub("th", "", deployments_1$`Camera Deployment Begin Date`)
deployments_1$`Camera Deployment Begin Date` <- gsub("11-8", "11-08", deployments_1$`Camera Deployment Begin Date`)
deployments_1$`Camera Deployment Begin Date` <- gsub("11-9", "11-09", deployments_1$`Camera Deployment Begin Date`)
deployments_1$`Camera Deployment End Date` <- gsub("November", "11", deployments_1$`Camera Deployment End Date`)
deployments_1$`Camera Deployment End Date` <- gsub("December", "12", deployments_1$`Camera Deployment End Date`)
deployments_1$`Camera Deployment End Date` <- gsub("th", "", deployments_1$`Camera Deployment End Date`)
deployments_1$`Camera Deployment End Date` <- gsub("rd", "", deployments_1$`Camera Deployment End Date`)
deployments_1$`Camera Deployment End Date` <- gsub("-7", "-07", deployments_1$`Camera Deployment End Date`)
deployments_1$`Camera Deployment End Date` <- gsub("-9", "-09", deployments_1$`Camera Deployment End Date`)
names(deployments_1)[4] <- "Deployment Location ID"
projects_1$`Project Name` <- "Silvania"
projects_1$`Project Objectives` <- "Wildlife monitoring"
projects_1$`Project Owner (Organization or Individual)` <- "ICMBio/CENAP"
projects_1$`Project Owner Email (if applicable)` <- "mariella.butti@icmbio.gov.br"

# rbind silvania to data from other sites
Image <- rbind(Image, images_1)
Project <- rbind(Project, projects_1)
Deployment <- rbind(Deployment, deployments_1)
Cameras <- rbind(Cameras, cameras_1)

##----- 5 - save full ICMBio dataset as csv-----
write.csv(Image, here("data", "Image.csv"), row.names = FALSE)
write.csv(Deployment, here("data", "Deployment.csv"), row.names = FALSE)
write.csv(Project, here("data", "Project.csv"), row.names = FALSE)
write.csv(Cameras, here("data", "Cameras.csv"), row.names = FALSE)
