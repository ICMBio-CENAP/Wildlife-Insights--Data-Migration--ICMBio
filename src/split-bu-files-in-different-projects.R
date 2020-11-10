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


cam_bu
dep_bu
image_bu

prj_bu[1,2]
