# For some camera traps, images are split in several sub-directories
# this script identifies them and fix the Location path
# this will be needed for the WI batch upload image_bu file


##----- 1 - Load libraries-----
library(here)
library(tidyverse)
#library(devtools)
#library(stringr)
#library(EXIFr)
library(exiftoolr)
library(magick)

##----- 2 - create a dataframe with path to individual images-----

#-------------------------------------------------------
# 2016
# extract path from all photos
imagePaths <- tibble(path = list.files("G:/Gurupi/2016", full.names=TRUE, recursive=TRUE))
imagePaths


# remove non-jpeg stuff from imagePaths
imagePaths <- imagePaths[!grepl("Thumbs", imagePaths$path),]
imagePaths <- imagePaths[!grepl(".AVI", imagePaths$path),]

# create DateTime column
imagePaths$DateTime <- NA
imagePaths$DateTime <- exif_read(imagePaths$path)[["CreateDate"]]
#View(imagePaths)


# do some adjustments in imagePaths
imagePaths$path <- as.character(imagePaths$path)
imagePaths$DateTime <- as.POSIXct(imagePaths$DateTime, format='%Y:%m:%d %H:%M:%S')
imagePaths$location <-  substr(imagePaths$path, 16, nchar(imagePaths$path))
temp4 <- substr(imagePaths$path, 16, nchar(imagePaths$path))
temp5 <- gsub('/Desktop/team gurupi 2016/', '', temp4)
imagePaths$Camera.Trap.Name <- sub('\\/.*', '', temp5)
imagePaths$Raw.Name <- sub('.*\\/', '', imagePaths$path)

#check it
sort(unique(imagePaths$Camera.Trap.Name))
View(imagePaths)

write.csv(imagePaths, here("data", "imagePaths2016.csv"), row.names = FALSE)

#-------------------------------------------------------
# 2017
# extract path from all photos
imagePaths <- tibble(path = list.files("E:/Gurupi/2017", full.names=TRUE, recursive=TRUE))
imagePaths


# remove non-jpeg stuff from imagePaths
imagePaths <- imagePaths[!grepl("Thumbs", imagePaths$path),]
imagePaths <- imagePaths[!grepl(".AVI", imagePaths$path),]

# create DateTime column
imagePaths$DateTime <- NA
imagePaths$DateTime <- exif_read(imagePaths$path)[["CreateDate"]]
View(imagePaths)


# do some adjustments in imagePaths
imagePaths$path <- as.character(imagePaths$path)
imagePaths$DateTime <- as.POSIXct(imagePaths$DateTime, format='%Y:%m:%d %H:%M:%S')
imagePaths$location <-  substr(imagePaths$path, 16, nchar(imagePaths$path))
temp4 <- substr(imagePaths$path, 16, nchar(imagePaths$path))
imagePaths$Camera.Trap.Name <- sub('\\/.*', '', temp4)
imagePaths$Raw.Name <- sub('.*\\/', '', imagePaths$path)

#check it
sort(unique(imagePaths$Camera.Trap.Name))
View(imagePaths)

write.csv(imagePaths, here("data", "imagePaths2017.csv"), row.names = FALSE)


#-------------------------------------------------------
# 2018
# extract path from all photos
imagePaths <- tibble(path = list.files("E:/Gurupi/2018", full.names=TRUE, recursive=TRUE))
imagePaths


# remove non-jpeg stuff from imagePaths
imagePaths <- imagePaths[!grepl("Thumbs", imagePaths$path),]
imagePaths <- imagePaths[!grepl(".AVI", imagePaths$path),]

# create DateTime column
imagePaths$DateTime <- NA
imagePaths$DateTime <- exif_read(imagePaths$path)[["CreateDate"]]
View(imagePaths)


# do some adjustments in imagePaths
imagePaths$path <- as.character(imagePaths$path)
imagePaths$DateTime <- as.POSIXct(imagePaths$DateTime, format='%Y:%m:%d %H:%M:%S')
imagePaths$location <-  substr(imagePaths$path, 16, nchar(imagePaths$path))
temp4 <- substr(imagePaths$path, 16, nchar(imagePaths$path))
imagePaths$Camera.Trap.Name <- sub('\\/.*', '', temp4)
imagePaths$Raw.Name <- sub('.*\\/', '', imagePaths$path)

#check it
sort(unique(imagePaths$Camera.Trap.Name))
View(imagePaths)

write.csv(imagePaths, here("data", "imagePaths2018.csv"), row.names = FALSE)

#-------------------------------------------------------
# 2019
# extract path from all photos
imagePaths <- tibble(path = list.files("F:/Gurupi/2019", full.names=TRUE, recursive=TRUE))
imagePaths


# remove non-jpeg stuff from imagePaths
imagePaths <- imagePaths[!grepl("Thumbs", imagePaths$path),]
imagePaths <- imagePaths[!grepl(".AVI", imagePaths$path),]

# imagePaths is too large and using ExifTool in vector will exceed memory limit
# divide to conquest
dim(imagePaths)
imagePaths_A <- imagePaths[1:25332,]
imagePaths_B <- imagePaths[25333:50664,]
dim(imagePaths_A)
dim(imagePaths_B)

# create DateTime column
imagePaths_A$DateTime <- NA
imagePaths_A$DateTime <- exif_read(imagePaths_A$path)[["CreateDate"]]

# create DateTime column
imagePaths_B$DateTime <- NA
imagePaths_B$DateTime <- exif_read(imagePaths_B$path)[["CreateDate"]]

# join them again
imagePaths <- rbind(imagePaths_A, imagePaths_B)

# create DateTime column
#imagePaths$DateTime <- NA
#imagePaths$DateTime <- exif_read(imagePaths$path)[["CreateDate"]]
#View(imagePaths)


# do some adjustments in imagePaths
imagePaths$path <- as.character(imagePaths$path)
imagePaths$DateTime <- as.POSIXct(imagePaths$DateTime, format='%Y:%m:%d %H:%M:%S')
imagePaths$location <-  substr(imagePaths$path, 16, nchar(imagePaths$path))
temp4 <- substr(imagePaths$path, 16, nchar(imagePaths$path))
imagePaths$Camera.Trap.Name <- sub('\\/.*', '', temp4)
imagePaths$Raw.Name <- sub('.*\\/', '', imagePaths$path)

#check it
sort(unique(imagePaths$Camera.Trap.Name))
View(imagePaths)

write.csv(imagePaths, here("data", "imagePaths2019.csv"), row.names = FALSE)

