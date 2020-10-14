blablabla

# code to get csv export from wild.ID into Wildlife insights format
# written by Elildo Carvalho Jr, 2020-06-06

# load libraries
library(tidyverse)
library(stringr)
library(here)

# source file
source(here("Transformation_Code", "Generic_Functions", "generate-spatial-distributions.R"))


##----- 1 - Read and fix raw data-----
gurupi <- read.csv(here("Datasets", "Gurupi_2016", "Wild_ID_RBG_2016.csv"))
#attach(gurupi)

gurupi$Sampling.Event <- 2016
gurupi$Camera.Trap.Name <- as.factor(gurupi$Camera.Trap.Name)
levels(gurupi$Camera.Trap.Name) # camera-trap names differ from all other datasets. Find out why and fix

# check date errors
gurupi$Camera.End.Date <- as.Date(gurupi$Camera.End.Date, format="%Y-%m-%d")
gurupi$Camera.Start.Date <- as.Date(gurupi$Camera.Start.Date, format="%Y-%m-%d")
gurupi$Photo.Date <- as.Date(gurupi$Photo.Date, format="%Y-%m-%d")

min(gurupi$Camera.Start.Date); max(gurupi$Camera.End.Date)
min(gurupi$Photo.Date); max(gurupi$Photo.Date)

# check the time lag between start date and 1st photo, last photo and end date
# if lag is too large there is still something wrong in dates, fix by redefining start and end dates 

time.lag <- function(data){
  df <- data.frame(matrix(NA, nrow = length(unique(data$Camera.Trap.Name)), ncol = 3))
  names(df) <- c("Camera.Trap.Name", "diff.start", "diff.end")
  df$Camera.Trap.Name <- unique(data$Camera.Trap.Name)
  
  for(i in 1:nrow(df)){
    df1 <- subset(data, Camera.Trap.Name == df[i,1])
    start <- as.Date(min(df1$Camera.Start.Date))
    end <- as.Date(max(df1$Camera.End.Date))
    min.photo <- as.Date(min(df1$Photo.Date))
    max.photo <- as.Date(max(df1$Photo.Date))
    df[i,2] <- min.photo-start
    df[i,3] <- end-max.photo
  }
  
  return(df) # check
}


time.lag(gurupi) # check

# wrong end for CT-RBG-2-73, fix using day of last photo
gurupi[gurupi$Camera.Trap.Name=="CT-RBG-2-73",]$Camera.End.Date <- max(subset(gurupi, Camera.Trap.Name=="CT-RBG-2-73")$Photo.Date)


##----- 2 - Check spatial distribution of cameras
check.coord(gurupi)


##----- 3 - Get the csv file into the format required for WI-----
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

