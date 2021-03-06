# code to get csv export from wild.ID into Wildlife insights format
# written by Elildo CArvalho Jr, 2020-06-06

# load libraries
library(tidyverse)
library(here)

# read file
sbr <- read.csv(here("Datasets", "Sao-Benedito-River", "Wild_ID_SBR_2017.csv"))
attach(sbr)

# create "Image" file from csv
Image <- tibble("Project ID" = Project.Name, "Deployment ID" = Camera.Trap.Name, 
                "Image ID" = paste(Camera.Trap.Name, Raw.Name, sep="_"),
                "Location" =  paste(Camera.Trap.Name, Raw.Name, sep="/"), 
                "Photo Type" =  Photo.Type, "Photo Type Identified by" =  Person.Identifying.the.Photo,
                "Genus Species" = paste(Genus, Species, sep=" "), "Uncertainty" = NA,
                "IUCN Identification Number" = NA, "Date_Time Captured" = paste(Photo.Date, Photo.time, sep=" "),
                "Age" = NA,  "Sex" = NA, "Individual ID" = NA,  "Count" =  Number.of.Animals,
                "Animal recognizable (Y/N)" = NA, "Individual Animal Notes" = NA) 
write.csv(Image, here("Datasets", "Sao-Benedito-River", "Image.csv"))


# create "Deployment" file from csv
Deployment <- tibble("Deployment ID" = paste("Sao-Benedito-River", Camera.Trap.Name, sep="_"), "Event Name" = 2017,
                    "Array Name (Optional)" = substr(Camera.Trap.Name, 1, stop = 8),"Depolyment Location ID" = Camera.Trap.Name,
                    "Longitude Resolution" = Longitude, "Latitude Resolution" = Latitude, 
                    "Camera Deployment Begin Date" = Camera.Start.Date, "Camera Deployment End Date" = Camera.End.Date,
                    "Bait Type" = "No Bait", "Bait Description" = NA, "Feature Type" = NA,
                    "Feature Type Methodology" = NA, "Camera ID" =  Camera.Serial.Number,"Quiet Period Setting" = NA,
                    "Restriction on Access" = NA, "Camera Failure Details" = NA,  "Camera Hardware Failure" = NA)
write.csv(Deployment, here("Datasets", "Sao-Benedito-River", "Deployment.csv"))


# create "Cameras" file from csv
Cameras <- tibble("Project ID" = Project.Name, "Camera ID" = Camera.Serial.Number, 
                  "Make" = Camera.Manufacturer, "Model" = Camera.Model, 
                  "Serial Number" = Camera.Serial.Number, "Year Purchased" = 2016)

Cameras <- Cameras %>% distinct(`Camera ID`, .keep_all = TRUE)
write.csv(Cameras, here("Datasets", "Sao-Benedito-River", "Cameras.csv"))


# Create "Project" file from csv 
Project <- tibble("Project ID" = "SBR", "Publish Date" = "2020-06-07", "Project Name" = Project.Name,
                  "Project Objectives" = "Wildlife survey", "Project Owner (Organization or Individual)" = "ICMBio/CENAP",
                  "Project Owner Email (if applicable)" = "elildojr@gmail.com",  "Principal Investigator" = "Elildo Carvalho Jr",
                   "Principal Investigator Email" = "elildojr@gmail.com", "Project Contact" = "Elildo Carvalho Jr",  "Project Contact Email" = "elildojr@gmail.com",
                  "Country Code" = "BRA",  "Project Data Use and Constraints" = NA)
write.csv(Project, here("Datasets", "Sao-Benedito-River", "Project.csv"))

