# code to get csv export from wild.ID into Wildlife insights format
# written by Elildo Carvalho Jr, 2020-06-06

# load libraries
library(tidyverse)
library(stringr)
library(here)

# source file
source(here("Transformation_Code", "Generic_Functions", "generate-spatial-distributions.R"))


##----- 1 - Read and fix raw data-----
TDM <- read.csv(here("Datasets", "Terra do Meio", "TdM_2016.csv"))
# (this dataset was previously fixed in wpi-terra-do-meio repo)
#attach(TDM)

TDM$Sampling.Event <- 2016
TDM$Camera.Trap.Name <- as.factor(TDM$Camera.Trap.Name)
levels(TDM$Camera.Trap.Name) # camera-trap names differ from all other datasets. Find out why and fix

# check date errors
TDM$Camera.End.Date <- as.Date(TDM$Camera.End.Date, format="%Y-%m-%d")
TDM$Camera.Start.Date <- as.Date(TDM$Camera.Start.Date, format="%Y-%m-%d")
TDM$Photo.Date <- as.Date(TDM$Photo.Date, format="%Y-%m-%d")

min(TDM$Camera.Start.Date); max(TDM$Camera.End.Date)
min(TDM$Photo.Date); max(TDM$Photo.Date)


##----- 2 - Check spatial distribution of cameras
check.coord(TDM)


##----- 3 - Get the csv file into the format required for WI-----

attach(TDM)


# create "Image" file from csv
Image <- tibble("Project ID" = "TDM", "Deployment ID" = paste(Camera.Trap.Name, Camera.Start.Date), 
                "Image ID" = paste(Camera.Trap.Name, Raw.Name, sep="_"),
                "Location" =  paste(Camera.Trap.Name, Raw.Name, sep="/"), 
                "Photo Type" =  Photo.Type, "Photo Type Identified by" =  Person.Identifying.the.Photo,
                "Genus Species" = paste(Genus, Species, sep=" "), "Uncertainty" = NA,
                "IUCN Identification Number" = NA, "Date_Time Captured" = paste(Photo.Date, Photo.Time, sep=" "),
                "Age" = NA,  "Sex" = NA, "Individual ID" = NA,  "Count" =  Number.of.Animals,
                "Animal recognizable (Y/N)" = NA, "Individual Animal Notes" = NA) 
write.csv(Image, here("Datasets", "Terra do Meio", "Image.csv"), row.names = FALSE)


# create "Deployment" file from csv
Deployment <- tibble("Deployment ID" = paste(Camera.Trap.Name, Camera.Start.Date), "Event Name" = 2016,
                     "Array Name (Optional)" = substr(Camera.Trap.Name, 1, stop = 8),"Deployment Location ID" = Camera.Trap.Name,
                     "Longitude Resolution" = Longitude, "Latitude Resolution" = Latitude, 
                     "Camera Deployment Begin Date" = Camera.Start.Date, "Camera Deployment End Date" = Camera.End.Date,
                     "Bait Type" = "No Bait", "Bait Description" = NA, "Feature Type" = NA,
                     "Feature Type Methodology" = NA, "Camera ID" =  Camera.Serial.Number,"Quiet Period Setting" = NA,
                     "Restriction on Access" = NA, "Camera Failure Details" = NA,  "Camera Hardware Failure" = NA)
write.csv(Deployment, here("Datasets", "Terra do Meio", "Deployment.csv"), row.names = FALSE)


# create "Cameras" file from csv
Cameras <- tibble("Project ID" = "TDM", "Camera ID" = Camera.Serial.Number, 
                  "Make" = Camera.Manufacturer, "Model" = Camera.Model, 
                  "Serial Number" = Camera.Serial.Number, "Year Purchased" = 2016)

Cameras <- Cameras %>% distinct(`Camera ID`, .keep_all = TRUE)
write.csv(Cameras, here("Datasets", "Terra do Meio", "Cameras.csv"), row.names = FALSE)


# Create "Project" file from csv 
Project <- tibble("Project ID" = "TDM", "Publish Date" = "2020-06-07", "Project Name" = "Terra do Meio",
                  "Project Objectives" = "Long-term wildlife monitoring", "Project Owner (Organization or Individual)" = "ICMBio/CENAP",
                  "Project Owner Email (if applicable)" = "elildojr@gmail.com",  "Principal Investigator" = "Elildo Carvalho Jr",
                  "Principal Investigator Email" = "elildojr@gmail.com", "Project Contact" = "Elildo Carvalho Jr",  "Project Contact Email" = "elildojr@gmail.com",
                  "Country Code" = "BRA",  "Project Data Use and Constraints" = NA)
write.csv(Project, here("Datasets", "Terra do Meio", "Project.csv"), row.names = FALSE)

