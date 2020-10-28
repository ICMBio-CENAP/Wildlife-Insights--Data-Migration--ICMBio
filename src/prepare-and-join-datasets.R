# Code to create the files needed for Wildlife Insights bulk upload
# Read exports from various sources, join them and create the four required files

##----- 1 - Load libraries-----
library(tidyverse)
library(stringr)
library(here)


##----- 2 - read datasets-----
gurupi <- read.csv(here("data", "Wild_ID_RBG_2016to2019.csv"))
gurupiRoads <- read.csv(here("data", "Wild_ID_RBG_ROADS_2015to2017_processed.csv"))
juruena <- read.csv(here("data", "Wild_ID_PNJU_2016to2019.csv"))
maraca <- read.csv(here("data", "Wild_ID_maraca_2018.csv"))
tdm <- read.csv(here("data", "Wild_ID_TDM_2016to2018.csv"))
#jamari <- read.csv(here("data", "Wild_ID_FNJ_2016to2019.csv")
silvania <- read.csv(here("data", "Wild_ID_Silvania_2019.csv"))
sbr <- read.csv(here("data", "Wild_ID_SBR_2017.csv"))


##----- 3 - join datasets-----
gurupi <- gurupi[,c("Camera.Trap.Name", "Project.Name", "Sampling.Event", "Longitude", "Latitude", "Camera.Start.Date", "Camera.End.Date", "Raw.Name", "Photo.Type",
                    "Person.Identifying.the.Photo", "Genus", "Species", "Photo.Date", "Photo.time", "Number.of.Animals",
                    "Camera.Manufacturer", "Camera.Model", "Camera.Serial.Number", "Person.setting.up.the.Camera",
                    "Person.picking.up.the.Camera", "Person.Identifying.the.Photo", "Organization.Name")]



dim(gurupi)
dim(gurupiRoads)
dim(juruena)
dim(maraca)
dim(tdm)
#dim(jamari)
dim(silvania)
dim(sbr)


##----- 4 - Get the csv file into the format required for WI-----
attach(gurupi)


# create "Image" file from csv
Image <- tibble("Project ID" = "RBG", "Deployment ID" = paste(Camera.Trap.Name, Camera.Start.Date), 
                "Image ID" = paste(Camera.Trap.Name, Raw.Name, sep="_"),
                "Location" =  paste(Camera.Trap.Name, Raw.Name, sep="/"), 
                "Photo Type" =  Photo.Type, "Photo Type Identified by" =  Person.Identifying.the.Photo,
                "Genus Species" = paste(Genus, Species, sep=" "), "Uncertainty" = NA,
                "IUCN Identification Number" = NA, "Date_Time Captured" = paste(Photo.Date, Photo.time, sep=" "),
                "Age" = NA,  "Sex" = NA, "Individual ID" = NA,  "Count" =  Number.of.Animals,
                "Animal recognizable (Y/N)" = NA, "Individual Animal Notes" = NA) 
write.csv(Image, here("Datasets", "Gurupi_2016", "Image.csv"), row.names = FALSE)


# create "Deployment" file from csv
Deployment <- tibble("Deployment ID" = paste(Camera.Trap.Name, Camera.Start.Date), "Event Name" = 2016,
                     "Array Name (Optional)" = substr(Camera.Trap.Name, 1, stop = 8),"Deployment Location ID" = Camera.Trap.Name,
                     "Longitude Resolution" = Longitude, "Latitude Resolution" = Latitude, 
                     "Camera Deployment Begin Date" = Camera.Start.Date, "Camera Deployment End Date" = Camera.End.Date,
                     "Bait Type" = "No Bait", "Bait Description" = NA, "Feature Type" = NA,
                     "Feature Type Methodology" = NA, "Camera ID" =  Camera.Serial.Number,"Quiet Period Setting" = NA,
                     "Restriction on Access" = NA, "Camera Failure Details" = NA,  "Camera Hardware Failure" = NA)
write.csv(Deployment, here("Datasets", "Gurupi_2016", "Deployment.csv"), row.names = FALSE)


# create "Cameras" file from csv
Cameras <- tibble("Project ID" = "RBG", "Camera ID" = Camera.Serial.Number, 
                  "Make" = Camera.Manufacturer, "Model" = Camera.Model, 
                  "Serial Number" = Camera.Serial.Number, "Year Purchased" = 2016)

Cameras <- Cameras %>% distinct(`Camera ID`, .keep_all = TRUE)
write.csv(Cameras, here("Datasets", "Gurupi_2016", "Cameras.csv"), row.names = FALSE)


# Create "Project" file from csv 
Project <- tibble("Project ID" = "RBG", "Publish Date" = "2020-06-07", "Project Name" = Project.Name,
                  "Project Objectives" = "Long-term wildlife monitoring", "Project Owner (Organization or Individual)" = "ICMBio/CENAP",
                  "Project Owner Email (if applicable)" = "elildojr@gmail.com",  "Principal Investigator" = "Elildo Carvalho Jr",
                  "Principal Investigator Email" = "elildojr@gmail.com", "Project Contact" = "Elildo Carvalho Jr",  "Project Contact Email" = "elildojr@gmail.com",
                  "Country Code" = "BRA",  "Project Data Use and Constraints" = NA)
write.csv(Project, here("Datasets", "Gurupi_2016", "Project.csv"), row.names = FALSE)

