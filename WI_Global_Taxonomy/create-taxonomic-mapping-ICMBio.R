library(tidyverse)

# create vector of unique species 
original_gs <- data.frame(unique(images[7]))

# remove unknown and NA
original_gs$Genus.Species <- gsub("unknown", "", original_gs$Genus.Species)
original_gs <- original_gs[-c(which(is.na(original_gs))),]

# remove trailing empty spaces
#trimws(original_gs$Genus.Species)

# convert to factor
original_gs <- as.factor(original_gs)
levels(original_gs)

# remove empty rows
original_gs <- droplevels(original_gs[!original_gs == " "])
original_gs <- droplevels(original_gs[!original_gs == "  "])
original_gs <- droplevels(original_gs[!original_gs == "   "])
original_gs <- droplevels(original_gs[!original_gs == "Rhinella marina"])
levels(original_gs)

# Fix some names so they are compatible with the WI global taxonomy
levels(original_gs)[levels(original_gs)=="Bos indicus"] <- "Bos taurus"
levels(original_gs)[levels(original_gs)=="Canis lupus familiaris"] <- "Canis lupus"
levels(original_gs)[levels(original_gs)=="Strix virgata"] <- "Ciccaba virgata"
levels(original_gs)[levels(original_gs)=="Cebus apella"] <- "Sapajus apella"
levels(original_gs)[levels(original_gs)=="Cebus olivaceus"] <- "Cebus"
levels(original_gs)[levels(original_gs)=="Crypturellus sp" ] <- "Crypturellus"
levels(original_gs)[levels(original_gs)=="Dasypus sp" ] <- "Dasypus"
levels(original_gs)[levels(original_gs)=="Equus" ] <- "Equus caballus"
levels(original_gs)[levels(original_gs)=="Puma yagouaroundi"] <- "Herpailurus yagouaroundi"
levels(original_gs)[levels(original_gs)=="Pauxi tuberosa"] <- "Mitu tuberosum"
levels(original_gs)[levels(original_gs)=="staff "] <- "Homo sapiens"
levels(original_gs)[levels(original_gs)=="vehicle "] <- "Homo sapiens"
levels(original_gs)[levels(original_gs)=="Tachyphonus luctuosus"] <- "Sakesphorus luctuosus"

#original_gs <- original_gs[-1]
original_gs <- factor(original_gs) # to reset levels

names(original_gs) <- NULL


# separate genus from species
df <- data.frame(str_split(original_gs, " ", simplify = T))
names(df) <- c('genus', 'species')
df <- df[,c(1:2)]
df

# create empty dataframe to become taxonomic mapping template
m <- matrix(NA, ncol = 11, nrow = length(original_gs))
m <- data.frame(m)
names(m) <- c("original_gs","Your_genus","Your_species","Your_nonspecies","class","order","family","genus","species","commonNameEnglish","uniqueIdentifier")

m$original_gs <- original_gs
m$Your_genus <- df$genus
m$Your_species <- df$species

for(i in 1:nrow(m)){
#for(i in 1:225){
  df1 <- filter(wi_taxa_data, genus == as.character(m[i,2]) & species == as.character(m[i,3]))
  m[i,1] <- original_gs[i]
  m[i,5] <- as.character(unique(df1$class))
  m[i,6] <- as.character(unique(df1$order))
  m[i,7] <- as.character(unique(df1$family))
  m[i,8] <- as.character(unique(df1$genus))
  m[i,9] <- as.character(unique(df1$species))
  m[i,10] <- as.character(df1$commonNameEnglish[1])
  m[i,11] <- as.character(df1$uniqueIdentifier[1])
}
colnames(m) <- c("original_gs","Your_genus","Your_species","Your_nonspecies","class","order","family","genus","species","commonNameEnglish","uniqueIdentifier")
#View(m) # check and use m as the taxonomic_mapping object

# add non-species
non.spp <- read.csv(here("WI_Global_Taxonomy", "non-spp.csv"), sep=";")
mapping.template <- rbind(m, non.spp)
rownames(mapping.template) <- 1:nrow(mapping.template)
#View(mapping.template)

names(m)
names(non.spp)
names(mapping.template)

# write template as csv
write.csv(m, here("WI_Global_Taxonomy", "taxonomic_mapping_ICMBio.csv"))
