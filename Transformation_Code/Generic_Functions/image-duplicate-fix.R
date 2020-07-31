
# find duplicated entries in image_bu
# step 1. create a list of photo files with date time extracted from exif
# setp 2. left_join it with image_bu
# step 3. identify which image_bu rows do not match the image_files in "Date_Time Captured" column 

# load libraries
library(here)
library(tidyverse)
library(devtools)
#devtools::install_github("cmartin/EXIFr")
library(EXIFr)

# Step 1:

# extract EXIF DateTime from all photos
image_files <- tibble(path = list.files("E:/team gurupi 2016", full.names=TRUE, recursive=TRUE))
image_files$DateTime <- NA

for(i in 1:nrow(image_files)){
  temp1 <- image_files$path[i]
  read_exif_tags(temp1)
  image_files$DateTime <- temp$DateTime
}

image_files

# do some adjustments in image_files
image_files$path <- as.character(image_files$path)
image_files$DateTime <- as.POSIXct(image_files$DateTime, format='%Y:%m:%d %H:%M:%S')
image_files$placename <- substr(image_files$path, 21, nchar(image_files$path))
image_files$placename <- substr(image_files$placename,1,nchar(image_files$placename)-13)
image_files$placename <- gsub("/100EK113", "", image_files$placename)
image_files$placename <- gsub("/101EK113", "", image_files$placename)
image_files$placename <- gsub("/102EK113", "", image_files$placename)
image_files$placename <- gsub("/103EK113", "", image_files$placename)
image_files$placename <- gsub("/104EK113", "", image_files$placename)
image_files$placename <- gsub("/105EK113", "", image_files$placename)
image_files$placename <- gsub("CTRBG1", "CT-RBG-1", image_files$placename)
image_files$placename <- gsub("CTRBG2", "CT-RBG-2", image_files$placename)

sort(unique(image_files$placename))

  tempData1 <- substr(image_files$path, 1, nchar(image_files$path)-12)
  for(i in 1:nrow(image_files)) {
    image_files$image_id[i] <- paste(image_files$placename[i], gsub(as.character(tempData1[i]), "", image_files$path[i]), sep="_")
  }

#View(image_files)

# save to use later if needed
write.csv(image_files, here("Datasets", "gurupi_2016", "image_files.csv"), row.names = FALSE)
#image_files <- read.csv(here("Datasets", "gurupi_2016", "image_files.csv"))


## Step 2:

# Read Gurupi data
gurupi <- read.csv(here("batch-upload", "gurupi_wi_batch_upload", "images.csv"))

# create placename column to be used in left_join
gurupi$placename <- substr(as.character(gurupi$deployment_id),1,nchar(as.character(gurupi$deployment_id))-11)
gurupi$image_id <- as.character(gurupi$image_id)

# left_join
teste <- left_join(gurupi, image_files, by=c("placename", "image_id"))

View(teste)


## Step 3:

# check which rows do not match (this means )
which( outer(teste$DateTime, teste$timestamp, "=="),arr.ind=TRUE)

nrow(gurupi)

gurupi2 <- distinct(gurupi, deployment_id, image_id, .keep_all=TRUE)
nrow(gurupi2)

nrow(gurupi)-nrow(gurupi2)
#View(gurupi2)
