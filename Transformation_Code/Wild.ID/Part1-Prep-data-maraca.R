# code to get csv export from wild.ID into Wildlife insights format
# written by Elildo Carvalho Jr, 2020-06-06

# load libraries
library(tidyverse)
library(here)

# source files
source(here("Transformation_Code", "Generic_Functions", "generate-spatial-distributions.R"))
source(here("Transformation_Code", "Generic_Functions", "time-lag.R"))

# read file
maraca <- read.csv(here("Datasets", "maraca", "esecmaraca_team_2018_raw data_final_expanded version.csv"))

# check if lat long are OK
#check.coord(maraca)

# attach for next steps
attach(maraca)

cts.id <- as.character(cts.id)
image.id <- as.character(image.id)
n_last <- 12 # Specify number of characters to extract (for image ID)

# create "Image" file from csv
Image <- tibble("Project ID" = "EEM", "Deployment ID" = substr(cts.id, 9, nchar(cts.id)), 
                "Image ID" = substr(image.id, nchar(image.id) - n_last + 1, nchar(image.id)),
                "Location" =  paste(substr(cts.id, 9, nchar(cts.id)), substr(image.id, nchar(image.id) - n_last + 1, nchar(image.id)), sep="/"), 
                "Photo Type" =  photo.type, "Photo Type Identified by" =  identification,
                "Genus Species" = species, "Uncertainty" = uncertainty,
                "IUCN Identification Number" = NA, "Date_Time Captured" = date.time,
                "Age" = NA,  "Sex" = NA, "Individual ID" = NA,  "Count" =  count,
                "Animal recognizable (Y/N)" = NA, "Individual Animal Notes" = NA) 
write.csv(Image, here("Datasets", "maraca", "Image.csv"), row.names = FALSE)


# create "Deployment" file from csv
Deployment <- tibble("Deployment ID" = paste("Maraca", substr(cts.id, 9, nchar(cts.id)), sep="_"), "Event Name" = 2018,
                    "Array Name (Optional)" = substr(cts.id, 9, 16),"Deployment Location ID" = substr(cts.id, 9, nchar(cts.id)),
                    "Longitude Resolution" = lon, "Latitude Resolution" = lat, 
                    "Camera Deployment Begin Date" = start.date, "Camera Deployment End Date" = end.date,
                    "Bait Type" = "No Bait", "Bait Description" = NA, "Feature Type" = NA,
                    "Feature Type Methodology" = NA, "Camera ID" =  camtrap.serial, "Quiet Period Setting" = NA,
                    "Restriction on Access" = NA, "Camera Failure Details" = NA,  "Camera Hardware Failure" = NA)
write.csv(Deployment, here("Datasets", "maraca", "Deployment.csv"), row.names = FALSE)


# create "Cameras" file from csv
Cameras <- tibble("Project ID" = "Maraca", "Camera ID" = camtrap.serial, 
                  "Make" = "Bushnell", "Model" = "Trophy Cam HD", 
                  "Serial Number" = camtrap.serial, "Year Purchased" = 2017)

Cameras <- Cameras %>% distinct(`Camera ID`, .keep_all = TRUE)
write.csv(Cameras, here("Datasets", "maraca", "Cameras.csv"), row.names = FALSE)


# Create "Project" file from csv 
Project <- tibble("Project ID" = "EEM", "Publish Date" = "2020-06-07", "Project Name" = "Maraca",
                  "Project Objectives" = "Long-term wildlife monitoring", "Project Owner (Organization or Individual)" = "ICMBio/CENAP",
                  "Project Owner Email (if applicable)" = "elildojr@gmail.com",  "Principal Investigator" = "Whaldener Endo",
                   "Principal Investigator Email" = "neotropical@gmail.com", "Project Contact" = "Elildo Carvalho Jr",  "Project Contact Email" = "elildojr@gmail.com",
                  "Country Code" = "BRA",  "Project Data Use and Constraints" = NA)
write.csv(Project, here("Datasets", "maraca", "Project.csv"), row.names = FALSE)

