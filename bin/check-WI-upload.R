
# jamari
jam.ima <- read.csv(here("wildlife_insights_bulk_uploads", "FNJ", "images.csv"))
jam.dep <- read.csv(here("wildlife_insights_bulk_uploads", "FNJ", "deployments.csv"))
jam.cam <- read.csv(here("wildlife_insights_bulk_uploads", "FNJ", "cameras.csv"))
jam.pro <- read.csv(here("wildlife_insights_bulk_uploads", "FNJ", "projects.csv"))

length(unique(jam.ima$species))
length(unique(jam.ima$wi_taxon_id))
nrow(jam.ima)
table(jam.ima$class)
length(unique(jam.dep$placename))
length(unique(jam.dep$deployment_id))
length(unique(jam.cam$camera_id))
min(jam.ima$timestamp)
max(jam.ima$timestamp)
mean(table(jam.ima$deployment_id))

# tdm
tdm.ima <- read.csv(here("wildlife_insights_bulk_uploads", "TDM", "images.csv"))
tdm.dep <- read.csv(here("wildlife_insights_bulk_uploads", "TDM", "deployments.csv"))
tdm.cam <- read.csv(here("wildlife_insights_bulk_uploads", "TDM", "cameras.csv"))
tdm.pro <- read.csv(here("wildlife_insights_bulk_uploads", "TDM", "projects.csv"))

length(unique(tdm.ima$species))
length(unique(tdm.ima$wi_taxon_id))
nrow(tdm.ima)
table(tdm.ima$class)
length(unique(tdm.dep$placename))
length(unique(tdm.dep$deployment_id))
length(unique(tdm.cam$camera_id))
min(tdm.ima$timestamp)
max(tdm.ima$timestamp)
mean(table(tdm.ima$deployment_id))
