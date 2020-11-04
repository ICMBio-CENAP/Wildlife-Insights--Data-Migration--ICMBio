# Wild.ID Migration Script
# Originally written by Eric Fegraus. October 2019
# Adapted for ICMBio by Elildo Carvalho Jr

# Purpose: The goal of this script is to load the Wild.ID export and convert it 
# into the Batch Upload Templates needed to ingest into Wildlife Insights.
# Note that within Wild.ID there are several options for exporting metadata.
# Selecting the .csv or .xls option in Export-->Export Data and Image --> CSV Format 
# or Export --> Export Data and Image --> Excel Format will result in a different file structure. 
# The format expected here comes from selecting Export --> Export Data and Image --> Wildlife Insights Format
# This code uses a real dataset collected in Peru. You will need to slightly modify
# this code to meet the needs and objectives of your camera trapping project.
# Key Steps:
# 1. Read in your data
# 2. Starting filling out the Batch Upload Template dataframes
# 3. Do the taxonomic mapping between your data and Wildlife Insights.  See the
#      wi_taxonomy.R code to download a dataframe of all WI taxonomy and the unique identifiers.
# 4. Validate your batch upload files by contacting info@wildlifeinsights.org.


# Clear all variables
rm(list = ls())
# Load libraries
library(dplyr)
library(readxl)
library(googlesheets)
library(lubridate)
library(here)

# source files
source(here("bin", 'wi_functions.R'))

# Set the directory path. This is relative to this Github repo. If you have cloned or 
# downloaded the repo it should work. If used outside of the repo you will need to modify this.

dir_path <- paste(here("data"), "/", sep="")

# Load Wild.ID export
images <- read.csv(here("data", "Image.csv"))
deployments <- read.csv(here("data", "Deployment.csv"))
cameras <- read.csv(here("data", "Cameras.csv"))
projects <- read.csv(here("data", "Project.csv"))

# fix colnames (use spaces instead of periods)
colnames(images) <- gsub("\\.", " ", colnames(images))
colnames(deployments) <- gsub("\\.", " ", colnames(deployments))
colnames(cameras) <- gsub("\\.", " ", colnames(cameras))
colnames(projects) <- gsub("\\.", " ", colnames(projects))


####
# Handle any data irregularities
#
# Adjust datetime stamp format
deployments$new_begin <- ymd(deployments$`Camera Deployment Begin Date`)
deployments$new_end <- ymd(deployments$`Camera Deployment End Date`)

# fix image names that have no unique identifier (needed for the taxonomy mapping)
  #images[images[, "Genus Species"] == "Canis lupus familiaris"] <- "Canis lupus"
  #images[images$join_taxa == "Puma yagouaroundi",] <- "Herpailurus yagouaroundi"
  # commands above failed, fix in original excel file and read again 


######
# Project Batch Upload Template: Load in the project batch upload template and fill it out.
dep_length <-1
prj_bu <- wi_batch_function("Project",dep_length)

# Many of the project variables may not be found in your dataset. If you can get them from your
# data great! Otherwise type them in here. 
prj_bu[nrow(prj_bu)+nrow(projects)-1,] <- NA # add empty rows otherwise following lines do not work
prj_bu$project_id <- projects$`Project ID`
prj_bu$project_name <- projects$`Project Name`
prj_bu$project_objectives <- projects$`Project Objectives`
prj_bu$project_species <- "Multiple" # Multiple or Single Species
prj_bu$project_species_individual  <- NA # If single list out the species (Genus species and comma separated)
prj_bu$project_sensor_layout <- "Systematic" # Options:Systematic, Randomized, Convenience,  Targeted 
prj_bu$project_sensor_layout_targeted_type <-  NA
prj_bu$project_bait_use <- "No"  #Was bait used? Options: Yes,Some,No
prj_bu$project_bait_type <- NA
prj_bu$project_stratification <- "No" #Options: Yes, No
prj_bu$project_stratification_type <- NA
prj_bu$project_sensor_method <- "Sensor detection"
prj_bu$project_individual_animals <- "No" #Options: Yes, No
prj_bu$project_blank_images <- "No" # Were blanks removed? Options: Yes, No
prj_bu$project_sensor_cluster <- "No"
prj_bu$project_admin <- projects$`Principal Investigator` #projects$`Principal Investigator`
prj_bu$project_admin_email <- projects$`Principal Investigator Email` #projects$`Principal Investigator Email`
prj_bu$project_admin_organization <- "ICMBio/CENAP" #projects$`Project Owner (Organization or Individual)`
prj_bu$country_code <- "BRA" # projects$`Country Code`
prj_bu$embargo <- 12 # 0-24 months
prj_bu$metadata_license <- "CC-BY" # Two options: CC0,CC-BY
prj_bu$image_license <- "CC-BY-NC" # Three options: CC0,CC-BY,CC-BY-NC


######
# Camera Batch Upload Template: Fill in the information relatd to the cameras/sensors used in your project
# First need to get the number of cameras used in the project
cam_info <- distinct(cameras,`Camera ID`,`Serial Number`,Make,Model,`Year Purchased`)
num_sensors <- length(unique(cam_info$`Camera ID`))
# Get the empty Camera template
cam_bu <- wi_batch_function("Camera",num_sensors)
# Fill out each Camera field
#cam_bu[nrow(cam_bu)+nrow(cameras)-1,] <- NA # add empty rows otherwise following lines do not work
#cam_bu$project_id <- unique(projects$`Project ID`) # If more than one error for now
cam_bu$project_id <- cameras$`Project ID`
cam_bu$camera_id <- cam_info$`Camera ID`
cam_bu$make <- cam_info$Make
cam_bu$model <- cam_info$Model
# If serial number and year purchased are available add them in as well.
cam_bu$serial_number <- cam_info$`Serial Number`
cam_bu$year_purchased <- cam_info$`Year Purchased`
# Notes: We will also try to get information from image EXIF data upon data ingestion into WI. 


######
# Deployment Batch Upload Template: Fill in the information related to each deployment. A deployment is a sensor 
# observing wildlife for some amount of time in a specific location. 
# 
# 1. Establish unique deployments - Should be Site.Name + pair(SessionStart.Date--> Session.End.Date)
#ct_data_taxa$deployments <- paste(ct_data_taxa$Site.Name,ct_data_taxa$Session.Start.Date,ct_data_taxa$Session.End.Date,sep="-")
# 2. Create a distinct dataframe based on deployments
dep_temp<-distinct(deployments,`Deployment ID`,.keep_all = TRUE )

# 3. Get the empty deployement dataframe
dep_bu <- wi_batch_function("Deployment",nrow(dep_temp))
# 4. Fill in the deployment batch upload template
#dep_bu$project_id <- unique(prj_bu$project_id) # If more than one error for now
# last line of this chunk has a solution for project_id
dep_bu$deployment_id <- dep_temp$`Deployment ID`
dep_bu$placename <- dep_temp$`Deployment Location ID`
dep_bu$longitude <- dep_temp$`Longitude Resolution`
dep_bu$latitude <- dep_temp$`Latitude Resolution`
dep_bu$start_date <- dep_temp$new_begin
dep_bu$end_date <- dep_temp$new_end
dep_bu$event <- dep_temp$`Event Name`
dep_bu$array_name <- dep_temp$`Array Name (Optional)`
dep_bu$bait_type <- "None" # Note that if bait was ussed but it was not consistent across all deployments, this is where you enter it. 
# Logic may be needed to figure out which deployments had bait and which didn't. Similar thing if "bait type" was vaired in deployments.
# Options: Yes, some, No.  We may need a way to assign this if answer = "some".
dep_bu$bait_description <- NA
dep_bu$feature_type <- dep_temp$`Feature Type` # Road paved, Road dirt, Trail hiking, Trail game, Road underpass, Road overpass, Road bridge, Culvert, Burrow, Nest site, Carcass, Water source, Fruiting tree, Other 
dep_bu$feature_type[which(is.na(dep_temp$`Feature Type`))] <- "None"
dep_bu$feature_type_methodology <- NA
dep_bu$camera_id <- dep_temp$`Camera ID`
dep_bu$quiet_period  <- dep_temp$`Quiet Period Setting`
dep_bu$camera_functioning[which(dep_temp$`Camera Hardware Failure` == "Functioning")] <- "Camera Functioning"  # Required: Camera Functioning,Unknown Failure,Vandalism,Theft,Memory Card,Film Failure,Camera Hardware Failure,Wildlife Damage
dep_bu$camera_functioning[which(is.na(dep_temp$`Camera Hardware Failure`))] <- "Camera Functioning"
dep_bu$sensor_height  <- "Knee height"
dep_bu$height_other  <- NA
dep_bu$sensor_orientation  <- "Parallel"
dep_bu$orientation_other  <- NA
dep_bu$recorded_by <- NA
dep_bu$project_id <- substr(dep_bu$deployment_id, 4, 6)
dep_bu$project_id[which(dep_bu$project_id != "RBG" & dep_bu$project_id != "PNJ" & dep_bu$project_id != "EEM" & dep_bu$project_id != "TDM" & dep_bu$project_id != "SBR" & dep_bu$project_id != "FNS")] <- "FNJ"


######
# Image Batch Upload Template: Fill in the information related to each image
# 
# 1. Import clean taxonomy and join with the images worksheet.
# Taxonomy

# Load in your clean taxonomy. Clean taxonomy is created using the WI_Taxonomy.R file.
  #your_taxa <- read.csv(paste(dir_path,"taxonomic_mapping_template_ALM.csv",sep=""),sep=";", colClasses = "character",strip.white = TRUE,na.strings="")
  #your_taxa <- read.csv(paste(dir_path,"taxonomic_mapping_FNS.csv",sep=""),sep="", colClasses = "character",strip.white = TRUE,na.strings="")
  source(here("WI_Global_Taxonomy", "WI_Taxonomy.R")) 
  source(here("WI_Global_Taxonomy", "create-taxonomic-mapping-ICMBio.R"))
  your_taxa <- mapping.template
  #your_taxa <- as_tibble(your_taxa) # not sure if this is needed, if not remove later
  

#Create a join column that accounts for both species and non-species labels from your 
your_taxa$join_taxa <- as.character(your_taxa$original_gs)
#your_taxa <- your_taxa %>% add_column(join_taxa = your_taxa$original_gs)


# Add in the non-species original names
your_taxa$join_taxa[which(!is.na(your_taxa$Your_nonspecies))] <-  your_taxa$Your_nonspecies[which(!is.na(your_taxa$Your_nonspecies))]


# Do the same with the images dataframe
  images$join_taxa <- images$`Genus Species`
  images$join_taxa <- gsub("unknown", "", images$join_taxa)
  images$join_taxa <- factor(images$join_taxa)
  # do same fixes as in creat-taxonomic-mapping
  # Fix some names so they are compatible with the WI global taxonomy
  levels(images$join_taxa)[levels(images$join_taxa)=="Bos indicus"] <- "Bos taurus"
  levels(images$join_taxa)[levels(images$join_taxa)=="Canis lupus familiaris"] <- "Canis lupus"
  levels(images$join_taxa)[levels(images$join_taxa)=="Strix virgata"] <- "Ciccaba virgata"
  levels(images$join_taxa)[levels(images$join_taxa)=="Cebus apella"] <- "Sapajus apella"
  levels(images$join_taxa)[levels(images$join_taxa)=="Cebus olivaceus"] <- "Cebus"
  levels(images$join_taxa)[levels(images$join_taxa)=="Crypturellus sp" ] <- "Crypturellus"
  levels(images$join_taxa)[levels(images$join_taxa)=="Dasypus sp" ] <- "Dasypus"
  levels(images$join_taxa)[levels(images$join_taxa)=="Equus" ] <- "Equus caballus"
  levels(images$join_taxa)[levels(images$join_taxa)=="Puma yagouaroundi"] <- "Herpailurus yagouaroundi"
  levels(images$join_taxa)[levels(images$join_taxa)=="Pauxi tuberosa"] <- "Mitu tuberosum"
  levels(images$join_taxa)[levels(images$join_taxa)=="staff "] <- "Homo sapiens"
  levels(images$join_taxa)[levels(images$join_taxa)=="vehicle "] <- "Homo sapiens"
  levels(images$join_taxa)[levels(images$join_taxa)=="Tachyphonus luctuosus"] <- "Sakesphorus luctuosus"
  images$join_taxa[images$join_taxa=="  "] <- NA
  images$join_taxa[images$join_taxa==" "] <- NA
  images$join_taxa[images$join_taxa==""] <- NA
  images$join_taxa <- factor(images$join_taxa)
  images$join_taxa <- as.character(images$join_taxa)
  images$join_taxa[which(is.na(images$join_taxa))] <- as.character(images$`Photo Type`[which(is.na(images$join_taxa))])

# Join the WI taxonomy back into the images dataframe.
  images_taxa <- left_join(images,your_taxa,by="join_taxa")

# Check the taxa
check <- distinct(images_taxa,class,order,family,genus,species,commonNameEnglish,uniqueIdentifier)
no_wi <- filter(images_taxa, is.na(uniqueIdentifier))


# Pulling out records that don't have unique identifier (this is a result of a photo.Type is NA)
# Create a check. If Photo.Type is.na there is an error with these or they have not bee identified.
images_taxa <- filter(images_taxa, !is.na(uniqueIdentifier))

# Pulling out records that don't have location
images_taxa <- filter(images_taxa, !is.na(Location))

# 2. Image file path adjustments
# Change the file path names for your images. Supply what your original path (original_path) with a replacement string (sub_path)
# Once your images are in GCP they will have an address like:
# gs://cameratraprepo-vcm/CafeFaunaAMPeru/Wild_ID_ALM/ALM_2018_249-1/IMG_0001.JPG
# Handle any windows directory backslashes
images_taxa$new_location <- gsub("\\\\","/",images_taxa$Location)
  # create a column with project names as they appear in bucket so we can paste it in new_location
  images_taxa$bucket_name <- images_taxa$`Project ID` 
  images_taxa$bucket_name[images_taxa$bucket_name=="RBG"] <- "Gurupi"
  images_taxa$bucket_name[images_taxa$bucket_name=="PNJU"] <- "Juruena"
  images_taxa$bucket_name[images_taxa$bucket_name=="EEM"] <- "Maraca"
  images_taxa$bucket_name[images_taxa$bucket_name=="TDM"] <- "Terra-do-Meio"
  images_taxa$bucket_name[images_taxa$bucket_name=="SBR"] <- "Sao-Benedito-River"
  images_taxa$bucket_name[images_taxa$bucket_name=="FNS"] <- "Silvania"
  images_taxa$bucket_name[images_taxa$bucket_name=="FNJ"] <- "Jamari"
  images_taxa$wi_path <- paste("gs://icmbio", images_taxa$bucket_name, images_taxa$new_location, sep="/")

# If all images were identified by one person, set this here. Otherwise comment this out.
#image_identified_by <- "Paula Conde"

# 3. Load in the Image batch upload template
image_bu <- wi_batch_function("Image",nrow(images_taxa))

######
# Image .csv template
#image_bu$project_id<- unique(prj_bu$project_id)
image_bu$project_id<- images_taxa$`Project ID`
image_bu$deployment_id <- images_taxa$`Deployment ID`
image_bu$image_id <- images_taxa$`Image ID`
image_bu$location <- images_taxa$wi_path  
image_bu$is_blank[which(images_taxa$commonNameEnglish == "Blank")] <- "Yes" # Set Blanks to Yes, 
image_bu$is_blank[which(images_taxa$commonNameEnglish != "Blank")] <- "No"
image_bu$wi_taxon_id <- images_taxa$uniqueIdentifier
image_bu$class <- images_taxa$class
image_bu$order <- images_taxa$order
image_bu$family <- images_taxa$family
image_bu$genus <- images_taxa$genus
image_bu$species <- images_taxa$species
image_bu$common_name <- images_taxa$commonNameEnglish
image_bu$uncertainty <- images_taxa$Uncertainty
image_bu$timestamp <- images_taxa$`Date_Time Captured`
image_bu$age <- images_taxa$Age
image_bu$sex <- images_taxa$Sex
image_bu$animal_recognizable <- images_taxa$`Animal recognizable (Y/N)`
image_bu$number_of_animals <- images_taxa$Count
image_bu$individual_id <- images_taxa$`Individual ID`
image_bu$individual_animal_notes <- images_taxa$`Individual Animal Notes`
image_bu$highlighted <- NA
image_bu$color <- NA
image_bu$identified_by <- images_taxa$`Photo Type Identified by`
# Get a clean site name first - no whitespaces
#site_name_clean <- gsub(" ","_",prj_bu$project_name)
#site_name_clean <- paste(site_name_clean,"_wi_batch_upload",sep="")
site_name_clean <- paste("icmbio", "_wi_batch_upload", sep="")

# Create the directory
#dir.create(path = paste(dir_path,site_name_clean, sep=""))
#dir.create(path = paste(here("batch-upload"), site_name_clean, sep="/"))

# Change any NAs to empty values
prj_bu <- prj_bu %>% replace(., is.na(.), "")
cam_bu <- cam_bu %>% replace(., is.na(.), "")
dep_bu <- dep_bu %>% replace(., is.na(.), "")
image_bu <- image_bu %>% replace(., is.na(.), "")


# Write out the 4 csv files for required for Batch Upload. 
# This directory needs to be uploaded to the Google Cloud with the filenames named exactly
# as written below. They have to be called: projects.csv, cameras.csv,deployments.csv,images.csv
#write.csv(prj_bu,file=here("batch-upload", site_name_clean, "projects.csv"), row.names = FALSE)
#write.csv(cam_bu,file=here("batch-upload", site_name_clean, "cameras.csv"),row.names = FALSE)
#write.csv(dep_bu,file=here("batch-upload", site_name_clean, "deployments.csv"),row.names = FALSE)
#write.csv(image_bu,file=here("batch-upload", site_name_clean, "images.csv"),row.names = FALSE)
write.csv(prj_bu,file=here("batch-upload", "projects.csv"), row.names = FALSE)
write.csv(cam_bu,file=here("batch-upload", "cameras.csv"),row.names = FALSE)
write.csv(dep_bu,file=here("batch-upload", "deployments.csv"),row.names = FALSE)
write.csv(image_bu,file=here("batch-upload", "images.csv"),row.names = FALSE)
