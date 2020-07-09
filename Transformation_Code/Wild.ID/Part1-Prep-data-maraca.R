# code to get csv export from wild.ID into Wildlife insights format
# written by Elildo Carvalho Jr, 2020-06-06

# load libraries
library(tidyverse)
library(here)

# source files
source(here("Transformation_Code", "Generic_Functions", "generate-spatial-distributions.R"))
source(here("Transformation_Code", "Generic_Functions", "time-lag.R"))

# read file
maraca <- read.csv(here("Datasets", "maraca", "esecmaraca_team_2018_raw data_final.csv"))

# check if lat long are OK
check.coord(maraca)

# attach for next steps
attach(maraca)

# create "Image" file from csv
Image <- tibble("Project ID" = "EEM", "Deployment ID" = substr(cts.id, start=9, stop = 20), 
                "Image ID" = image.id,
                "Location" =  paste(cts.id, Raw.Name, sep="/"), 
                "Photo Type" =  Photo.Type, "Photo Type Identified by" =  Person.Identifying.the.Photo,
                "Genus Species" = paste(Genus, Species, sep=" "), "Uncertainty" = NA,
                "IUCN Identification Number" = NA, "Date_Time Captured" = paste(Photo.Date, Photo.time, sep=" "),
                "Age" = NA,  "Sex" = NA, "Individual ID" = NA,  "Count" =  Number.of.Animals,
                "Animal recognizable (Y/N)" = NA, "Individual Animal Notes" = NA) 
write.csv(Image, here("Datasets", "maraca", "Image.csv"), row.names = FALSE)


# create "Deployment" file from csv
Deployment <- tibble("Deployment ID" = paste("maraca", Camera.Trap.Name, sep="_"), "Event Name" = 2017,
                    "Array Name (Optional)" = substr(Camera.Trap.Name, 1, stop = 8),"Deployment Location ID" = Camera.Trap.Name,
                    "Longitude Resolution" = Longitude, "Latitude Resolution" = Latitude, 
                    "Camera Deployment Begin Date" = Camera.Start.Date, "Camera Deployment End Date" = Camera.End.Date,
                    "Bait Type" = "No Bait", "Bait Description" = NA, "Feature Type" = NA,
                    "Feature Type Methodology" = NA, "Camera ID" =  Camera.Serial.Number,"Quiet Period Setting" = NA,
                    "Restriction on Access" = NA, "Camera Failure Details" = NA,  "Camera Hardware Failure" = NA)
write.csv(Deployment, here("Datasets", "maraca", "Deployment.csv"), row.names = FALSE)


# create "Cameras" file from csv
Cameras <- tibble("Project ID" = Project.Name, "Camera ID" = Camera.Serial.Number, 
                  "Make" = Camera.Manufacturer, "Model" = Camera.Model, 
                  "Serial Number" = Camera.Serial.Number, "Year Purchased" = 2016)

Cameras <- Cameras %>% distinct(`Camera ID`, .keep_all = TRUE)
write.csv(Cameras, here("Datasets", "maraca", "Cameras.csv"), row.names = FALSE)


# Create "Project" file from csv 
Project <- tibble("Project ID" = "maraca", "Publish Date" = "2020-06-07", "Project Name" = Project.Name,
                  "Project Objectives" = "Wildlife survey", "Project Owner (Organization or Individual)" = "ICMBio/CENAP",
                  "Project Owner Email (if applicable)" = "elildojr@gmail.com",  "Principal Investigator" = "Elildo Carvalho Jr",
                   "Principal Investigator Email" = "elildojr@gmail.com", "Project Contact" = "Elildo Carvalho Jr",  "Project Contact Email" = "elildojr@gmail.com",
                  "Country Code" = "BRA",  "Project Data Use and Constraints" = NA)
write.csv(Project, here("Datasets", "maraca", "Project.csv"), row.names = FALSE)

