# code to get csv export from wild.ID into Wildlife insights format
# written by Elildo Carvalho Jr, 2020-06-06

# load libraries
library(tidyverse)
library(stringr)
library(here)

# source file
source(here("Transformation_Code", "Generic_Functions", "generate-spatial-distributions.R"))


##----- 1 - Read and fix raw data-----
juruena <- read.csv(here("Datasets", "juruena", "Wild_ID_PNJU_2017.csv"))
#attach(juruena)

##----- 2 - Check spatial distribution of cameras
check.coord(juruena)


juruena$Sampling.Event <- 2017
juruena$Camera.Trap.Name <- as.factor(juruena$Camera.Trap.Name)
levels(juruena$Camera.Trap.Name) # camera-trap names differ from all other datasets. Find out why and fix

# check date errors
juruena$Camera.End.Date <- as.Date(juruena$Camera.End.Date, format="%Y-%m-%d")
juruena$Camera.Start.Date <- as.Date(juruena$Camera.Start.Date, format="%Y-%m-%d")
juruena$Photo.Date <- as.Date(juruena$Photo.Date, format="%Y-%m-%d")

min(juruena$Camera.Start.Date); max(juruena$Camera.End.Date)
min(juruena$Photo.Date); max(juruena$Photo.Date)

sort(unique(juruena$Photo.Date))
juruena <- juruena[juruena$Photo.Date > "2016-02-09",] # dropping camera with wrong dates
min(juruena$Photo.Date); max(juruena$Photo.Date) # checking again
min(juruena$Camera.Start.Date); max(juruena$Camera.End.Date) # check again Start and End dates
sort(unique(juruena$Camera.Start.Date))

# fix start dates using minimum photo date
for(i in 1:nrow(juruena)){ 
  if (juruena$Camera.Start.Date[i] < min(juruena$Photo.Date)) {
    df1 <- subset(juruena, Camera.Trap.Name == juruena$Camera.Trap.Name[i])
    min <- min(df1$Photo.Date)
    juruena$Camera.Start.Date[i] <-  min
  }
}
sort(unique(juruena$Camera.Start.Date)) # check, OK

# fix end dates using max photo date
for(i in 1:nrow(juruena)){ 
  if (juruena$Camera.End.Date[i] > max(juruena$Photo.Date)) {
    df1 <- subset(juruena, Camera.Trap.Name == juruena$Camera.Trap.Name[i])
    max <- max(df1$Photo.Date)
    juruena$Camera.End.Date[i] <-  max
  }
}
sort(unique(juruena$Camera.Start.Date)) # check, OK
min(juruena$Camera.Start.Date); max(juruena$Camera.End.Date)

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


time.lag(juruena) # check

# wrong ends for CT-PNJU-2-2 and CT-PNJU-2-9, fix using day of last photo

juruena[juruena$Camera.Trap.Name=="CT-PNJU-2-2",]$Camera.End.Date <- max(subset(juruena, Camera.Trap.Name=="CT-PNJU-2-2")$Photo.Date)
juruena[juruena$Camera.Trap.Name=="CT-PNJU-2-9",]$Camera.End.Date <- max(subset(juruena, Camera.Trap.Name=="CT-PNJU-2-9")$Photo.Date)



##----- 2 - Get the csv file into the format required for WI-----

attach(juruena)


# create "Image" file from csv
Image <- tibble("Project ID" = "PNJU", "Deployment ID" = Camera.Trap.Name, 
                "Image ID" = paste(Camera.Trap.Name, Raw.Name, sep="_"),
                "Location" =  paste(Camera.Trap.Name, Raw.Name, sep="/"), 
                "Photo Type" =  Photo.Type, "Photo Type Identified by" =  Person.Identifying.the.Photo,
                "Genus Species" = paste(Genus, Species, sep=" "), "Uncertainty" = NA,
                "IUCN Identification Number" = NA, "Date_Time Captured" = paste(Photo.Date, Photo.time, sep=" "),
                "Age" = NA,  "Sex" = NA, "Individual ID" = NA,  "Count" =  Number.of.Animals,
                "Animal recognizable (Y/N)" = NA, "Individual Animal Notes" = NA) 
write.csv(Image, here("Datasets", "juruena", "Image.csv"), row.names = FALSE)


# create "Deployment" file from csv
Deployment <- tibble("Deployment ID" = paste("juruena", Camera.Trap.Name, sep="_"), "Event Name" = 2017,
                     "Array Name (Optional)" = substr(Camera.Trap.Name, 1, stop = 9),"Deployment Location ID" = Camera.Trap.Name,
                     "Longitude Resolution" = Longitude, "Latitude Resolution" = Latitude, 
                     "Camera Deployment Begin Date" = Camera.Start.Date, "Camera Deployment End Date" = Camera.End.Date,
                     "Bait Type" = "No Bait", "Bait Description" = NA, "Feature Type" = NA,
                     "Feature Type Methodology" = NA, "Camera ID" =  Camera.Serial.Number,"Quiet Period Setting" = NA,
                     "Restriction on Access" = NA, "Camera Failure Details" = NA,  "Camera Hardware Failure" = NA)
write.csv(Deployment, here("Datasets", "juruena", "Deployment.csv"), row.names = FALSE)


# create "Cameras" file from csv
Cameras <- tibble("Project ID" = "PNJU", "Camera ID" = Camera.Serial.Number, 
                  "Make" = Camera.Manufacturer, "Model" = Camera.Model, 
                  "Serial Number" = Camera.Serial.Number, "Year Purchased" = 2016)

Cameras <- Cameras %>% distinct(`Camera ID`, .keep_all = TRUE)
write.csv(Cameras, here("Datasets", "juruena", "Cameras.csv"), row.names = FALSE)


# Create "Project" file from csv 
Project <- tibble("Project ID" = "PNJU", "Publish Date" = "2020-06-07", "Project Name" = Project.Name,
                  "Project Objectives" = "Long-term wildlife monitoring", "Project Owner (Organization or Individual)" = "ICMBio/CENAP",
                  "Project Owner Email (if applicable)" = "elildojr@gmail.com",  "Principal Investigator" = "Elildo Carvalho Jr",
                  "Principal Investigator Email" = "elildojr@gmail.com", "Project Contact" = "Elildo Carvalho Jr",  "Project Contact Email" = "elildojr@gmail.com",
                  "Country Code" = "BRA",  "Project Data Use and Constraints" = NA)
write.csv(Project, here("Datasets", "juruena", "Project.csv"), row.names = FALSE)

