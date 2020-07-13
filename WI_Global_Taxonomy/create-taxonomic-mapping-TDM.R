# create vector of unique species 
original_gs <- data.frame(unique(images[7]))
original_gs <- na.omit(original_gs) # remove an NA
# Fix some names so they are compatible with the WI global taxonomy
original_gs[original_gs == "Campephilus unknown"] <- "Campephilus"
original_gs[original_gs == "Cathartes unknown"] <- "Cathartes"
original_gs[original_gs == "Chamaeza unknown"] <- "Chamaeza"
original_gs[original_gs == "Crypturellus unknown"] <- "Crypturellus"
#Dasycercus unknown
original_gs[original_gs == "Dactylomys unknown"] <- "Dactylomys"
original_gs[original_gs == "Dasyprocta unknown"] <- "Dasyprocta ruatanica"
original_gs[original_gs == "Dasypus unknown"] <- "Dasypus"
original_gs[original_gs == "Geotrygon unknown"] <- "Geotrygon"
original_gs[original_gs == "Formicarius unknown"] <- "Formicarius"
original_gs[original_gs == "Leopardus unknown"] <- "Leopardus"
original_gs[original_gs == "Leptotila unknown"] <- "Leptotila"
original_gs[original_gs == "Mazama unknown"] <- "Mazama"
original_gs[original_gs == "Mitu tomentosum"] <- "Mitu tuberosum"
original_gs[original_gs == "Mitu unknown"] <- "Mitu tuberosum"
original_gs[original_gs == "Monasa unknown"] <- "Monasa"
original_gs[original_gs == "Myrmoborus unknown"] <- "Myrmoborus" 
original_gs[original_gs == "Neopmorphus unknown"] <- "Neopmorphus" 
original_gs[original_gs == "Pauxi unknown"] <- "Mitu tuberosum"
original_gs[original_gs == "Penelope unknown"] <- "Penelope"
original_gs[original_gs == "Proechimys unknown"] <- "Proechimys"
#Proedromys unknown
original_gs[original_gs == "Psophia unknown"] <- "Psophia viridis"
original_gs[original_gs == "Puma unknown"] <- "Puma"
original_gs[original_gs == "Rhegmatorhina unknown"] <- "Rhegmatorhina"
original_gs[original_gs == "Saimiri unknown"] <- "Saimiri"
original_gs[original_gs == "Cebus apella"] <- "Sapajus apella"
original_gs[original_gs == "Sciurus unknown"] <- "Sciurus aestuans"
original_gs[original_gs == "Tigrisoma unknown"] <- "Tigrisoma"
original_gs[original_gs == "Tinamus unknown"] <- "Tinamus"



names(original_gs) <- NULL

# separate genus from species
library(tidyverse)
df <- data.frame(str_split(original_gs[,1], " ", simplify = T))
names(df) <- c('genus', 'species')

# add lupus familiaris. first, convert to character
#df$species <- as.character(df$species)
#df[df$species == "lupus", "species"] <- "lupus familiaris"
#df$species <- factor(df$species)

# transform species from factor to character
df$species <- as.character(df$species)

#transform unknown species into NA
#df$species[df$species=="unknown"] <- NA
df$species[df$species=="unknown"] <- ""

# create empty dataframe to become taxonomic mapping template
m <- matrix(NA, ncol = 11, nrow = nrow(original_gs))
m <- data.frame(m)
names(m) <- c("original_gs","Your_genus","Your_species","Your_nonspecies","class","order","family","genus","species","commonNameEnglish","uniqueIdentifier")

#m$original_gs <- original_gs
m$Your_genus <- df$genus
m$Your_species <- df$species
#m <- m[-1,]
#View(m)

for(i in 1:nrow(m)){
  df1 <- filter(wi_taxa_data, genus == as.character(m[i,2]) & species == as.character(m[i,3]))
  m[i,1] <- original_gs[i,1]
  m[i,5] <- df1$class
  m[i,6] <- df1$order
  m[i,7] <- df1$family
  m[i,8] <- df1$genus
  m[i,9] <- df1$species
  m[i,10] <- df1$commonNameEnglish
  m[i,11] <- df1$uniqueIdentifier
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
#write.csv(m, "taxonomic_mapping_TDM_2016.csv")
