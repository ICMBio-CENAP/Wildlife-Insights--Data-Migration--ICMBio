# line 164

# create vector of unique species 
original_gs <- data.frame(unique(images[7]))
# Fix some names so they are compatible with the WI global taxonomy
#original_gs[original_gs == "Canis lupus familiaris"] <- "Canis lupus"
#original_gs <- original_gs[-1] # remove empty entry
original_gs<-original_gs[!(original_gs==""),]
#original_gs<-original_gs[!(original_gs==" "),]


# Fix some names so they are compatible with the WI global taxonomy
levels(original_gs)[levels(original_gs)=="Puma yagouaroundi"] <- "Herpailurus yagouaroundi"
levels(original_gs)[levels(original_gs)=="Cebus olivaceus"] <- "Cebus"
levels(original_gs)[levels(original_gs)=="Cebus apella"] <- "Sapajus apella"
levels(original_gs)[levels(original_gs)=="Homo sapiens - Researcher"] <- "Homo sapiens"
original_gs <- original_gs[-78]
original_gs <- factor(original_gs)

names(original_gs) <- NULL

# separate genus from species
library(tidyverse)
#df <- data.frame(str_split(original_gs[,1], " ", simplify = T))
df <- data.frame(str_split(original_gs, " ", simplify = T))
names(df) <- c('genus', 'species')


#transform unknown species into NA
df$species <- as.character(df$species)
#df$species[df$species=="unknown"] <- NA
df$species[df$species=="unknown"] <- ""


# create empty dataframe to become taxonomic mapping template
#m <- matrix(NA, ncol = 11, nrow = nrow(original_gs))
m <- matrix(NA, ncol = 11, nrow = length(original_gs))
m <- data.frame(m)
names(m) <- c("original_gs","Your_genus","Your_species","Your_nonspecies","class","order","family","genus","species","commonNameEnglish","uniqueIdentifier")

m$original_gs <- original_gs
m$Your_genus <- df$genus
m$Your_species <- df$species

#View(m)

for(i in 1:nrow(m)){
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
#write.csv(mapping.template, here("WI_Global_Taxonomy", "mapping-template-SBR.csv"), row.names = FALSE)
