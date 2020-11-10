# Wild.ID Migration Script
# Split projects into separate folders
# as requested by N. Flores


# Clear all variables
rm(list = ls())

# load libraries
library(here)

# load bu Rdata
load(here("data", "icmbio_bu.Rdata"))

# split prj_bu
for(i in 1:nrow(prj_bu)) {
  df1 <- prj_bu[i,]
  write.csv(df1, file=paste(as.character(here()), "wildlife_insights_bulk_uploads", prj_bu[i,2], "projects.csv", sep="/"), row.names = FALSE)
}

# split dep_bu
for(i in 1:length(unique(dep_bu$project_id)) ) {
  df2 <- subset(dep_bu, dep_bu$project_id == unique(dep_bu$project_id)[i])
  write.csv(df2, file=paste(as.character(here()), "wildlife_insights_bulk_uploads", unique(dep_bu$project_id)[i], "deployments.csv", sep="/"), row.names = FALSE)
}

# split cam_bu
for(i in 1:length(unique(cam_bu$project_id)) ) {
  df3 <- subset(cam_bu, cam_bu$project_id == unique(cam_bu$project_id)[i])
  write.csv(df3, file=paste(as.character(here()), "wildlife_insights_bulk_uploads", unique(cam_bu$project_id)[i], "cameras.csv", sep="/"), row.names = FALSE)
}


# split image_bu
for(i in 1:length(unique(image_bu$project_id)) ) {
  df4 <- subset(image_bu, image_bu$project_id == unique(image_bu$project_id)[i])
  write.csv(df4, file=paste(as.character(here()), "wildlife_insights_bulk_uploads", unique(image_bu$project_id)[i], "images.csv", sep="/"), row.names = FALSE)
}

