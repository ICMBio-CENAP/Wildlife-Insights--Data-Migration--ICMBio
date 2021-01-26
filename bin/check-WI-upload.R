library(here)

# jamari
jam.ima <- read.csv(here("wildlife_insights_bulk_uploads", "FNJ", "images.csv"))
jam.dep <- read.csv(here("wildlife_insights_bulk_uploads", "FNJ", "deployments.csv"))
jam.cam <- read.csv(here("wildlife_insights_bulk_uploads", "FNJ", "cameras.csv"))
jam.pro <- read.csv(here("wildlife_insights_bulk_uploads", "FNJ", "projects.csv"))

length(unique(jam.ima$species))
length(unique(jam.ima$wi_taxon_id))
nrow(jam.ima)
table(jam.ima$class)[1]+table(jam.ima$class)[2]
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
table(tdm.ima$class)[2] +table(tdm.ima$class)[3]
length(unique(tdm.dep$placename))
length(unique(tdm.dep$deployment_id))
length(unique(tdm.cam$camera_id))
min(tdm.ima$timestamp)
max(tdm.ima$timestamp)
mean(table(tdm.ima$deployment_id))

# silvania
silvania.ima <- read.csv(here("wildlife_insights_bulk_uploads", "FNS", "images.csv"))
silvania.dep <- read.csv(here("wildlife_insights_bulk_uploads", "FNS", "deployments.csv"))
silvania.cam <- read.csv(here("wildlife_insights_bulk_uploads", "FNS", "cameras.csv"))
silvania.pro <- read.csv(here("wildlife_insights_bulk_uploads", "FNS", "projects.csv"))

length(unique(silvania.ima$species))
length(unique(silvania.ima$wi_taxon_id))
nrow(silvania.ima)
table(silvania.ima$class)[2]+table(silvania.ima$class)[3]
length(unique(silvania.dep$placename))
length(unique(silvania.dep$deployment_id))
length(unique(silvania.cam$camera_id))
min(silvania.ima$timestamp)
max(silvania.ima$timestamp)
mean(table(silvania.ima$deployment_id))



# maraca
maraca.ima <- read.csv(here("wildlife_insights_bulk_uploads", "EEM", "images.csv"))
maraca.dep <- read.csv(here("wildlife_insights_bulk_uploads", "EEM", "deployments.csv"))
maraca.cam <- read.csv(here("wildlife_insights_bulk_uploads", "EEM", "cameras.csv"))
maraca.pro <- read.csv(here("wildlife_insights_bulk_uploads", "EEM", "projects.csv"))

length(unique(maraca.ima$species))
length(unique(maraca.ima$wi_taxon_id))
nrow(maraca.ima)
table(maraca.ima$class)[1]+table(maraca.ima$class)[2]
length(unique(maraca.dep$placename))
length(unique(maraca.dep$deployment_id))
length(unique(maraca.cam$camera_id))
min(maraca.ima$timestamp)
max(maraca.ima$timestamp)
mean(table(maraca.ima$deployment_id))


# compare upload with download, especially unique images
# maraca:
cloud.ima <- read.csv("/home/elildojr/Downloads/wildlife-insights_9f636f14-c22f-4be1-8de3-e18eea3fa7d7_project-2002584_data/images.csv")
cloud.dep <- read.csv("/home/elildojr/Downloads/wildlife-insights_9f636f14-c22f-4be1-8de3-e18eea3fa7d7_project-2002584_data/deployments.csv")
cloud.cam <- read.csv("/home/elildojr/Downloads/wildlife-insights_9f636f14-c22f-4be1-8de3-e18eea3fa7d7_project-2002584_data/cameras.csv")
cloud.pro <- read.csv("/home/elildojr/Downloads/wildlife-insights_9f636f14-c22f-4be1-8de3-e18eea3fa7d7_project-2002584_data/projects.csv")

# jamari:
ima <- read.csv <- read.csv("/home/elildojr/Downloads/wildlife-insights_7877352c-341c-49b2-ae10-48704349cf96_project-2002562_data/images.csv")
dep <- read.csv <- read.csv("/home/elildojr/Downloads/wildlife-insights_7877352c-341c-49b2-ae10-48704349cf96_project-2002562_data/deployments.csv")
cam <- read.csv <- read.csv("/home/elildojr/Downloads/wildlife-insights_7877352c-341c-49b2-ae10-48704349cf96_project-2002562_data/cameras.csv")
pro <- read.csv <- read.csv("/home/elildojr/Downloads/wildlife-insights_7877352c-341c-49b2-ae10-48704349cf96_project-2002562_data/projects.csv")

# edit time-lag function so it works with wi data format:
time.lag <- function(ima, dep) {
  df <- data.frame(matrix(NA, nrow = length(unique(ima$deployment_id)), ncol = 3))
  names(df) <- c("deployment_id", "diff.start", "diff.end")
  df$deployment_id <- unique(ima$deployment_id)
  
  for(i in 1:nrow(df)){
    df1 <- subset(ima, deployment_id == df[i,1])
    df2 <- subset(dep, deployment_id == df[i,1])
    start <- as.Date(min(df2$start_date))
    end <- as.Date(max(df2$end_date))
    min.photo <- as.Date(min(df1$timestamp))
    max.photo <- as.Date(max(df1$timestamp))
    df[i,2] <- min.photo-start
    df[i,3] <- end-max.photo
  }
  df_temp <<- df
  return(df)
}


# compare time-lag from upload and download
# jamari:
time.lag(jam.ima, jam.dep)
local <- df_temp

time.lag(ima, dep)
cloud <- df_temp

compare <- merge(local, cloud, "deployment_id", sort = TRUE)
compare[,2]-compare[,4]
compare[,3]-compare[,5]

# compare number of records per species
local_table <- data.frame(table(jam.ima$common_name))
cloud_table <- data.frame(table(ima$common_name))
compare_table <- merge(local_table, cloud_table, "Var1", sort = TRUE)
compare_table
sum(compare_table[,2]-compare_table[,3])
nrow(jam.ima)-nrow(ima)

# compare number of records per site
local_site <- data.frame(table(jam.ima$deployment_id))
cloud_site <- data.frame(table(ima$deployment_id))
compare_site <- merge(local_site, cloud_site, "Var1", sort = TRUE)
compare_site
compare_site$diff <- compare_site[,2]-compare_site[,3]
sum(compare_site[,2]-compare_site[,3])
nrow(jam.ima)-nrow(ima)


# compare for maraca
time.lag(maraca.ima, maraca.dep)
local <- df_temp

time.lag(cloud.ima, cloud.dep)
cloud <- df_temp

compare <- merge(local, cloud, "deployment_id", sort = TRUE)
compare[,2]-compare[,4]
compare[,3]-compare[,5]

