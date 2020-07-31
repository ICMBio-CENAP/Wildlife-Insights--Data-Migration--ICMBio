# remove duplicated entries
# upload them later 

library(dplyr)
library(here)

## ---------------- Gurupi
gurupi <- read.csv(here("batch-upload", "gurupi_wi_batch_upload", "images.csv"))
nrow(gurupi)

gurupi2 <- distinct(gurupi, deployment_id, image_id, .keep_all=TRUE)
nrow(gurupi2)

nrow(gurupi)-nrow(gurupi2)
#View(gurupi2)


## ---------------- Juruena
juruena <- read.csv(here("batch-upload", "Juruena_wi_batch_upload", "images.csv"))
nrow(juruena)

jur2 <- distinct(juruena, deployment_id, image_id, .keep_all=TRUE)
nrow(jur2)

nrow(juruena)-nrow(jur2)
#View(jur2)

# ----------------  Jamari
jamari <- read.csv(here("batch-upload", "Jamari_wi_batch_upload", "images.csv"))
nrow(jamari)

jam22 <- distinct(jamari, deployment_id, image_id, .keep_all=TRUE)
nrow(jam22)

nrow(jamari)-nrow(jam22)
#View(jam22)

# ----------------  Terra do Meio
tdm <- read.csv(here("batch-upload", "Terra_do_Meio_wi_batch_upload", "images.csv"))
nrow(tdm)

tdm2 <- distinct(tdm, deployment_id, image_id, .keep_all=TRUE)
nrow(tdm2)

nrow(tdm)-nrow(tdm2)

# ----------------  Maraca
maraca <- read.csv(here("batch-upload", "Maraca_wi_batch_upload", "images.csv"))
nrow(maraca)

maraca2 <- distinct(maraca, deployment_id, image_id, .keep_all=TRUE)
nrow(maraca2)

nrow(maraca)-nrow(maraca2)



# ----------------  Silvania
silvania <- read.csv(here("batch-upload", "Silvania_wi_batch_upload", "images.csv"))
nrow(silvania)

sbr2 <- distinct(silvania, deployment_id, image_id, .keep_all=TRUE)
nrow(sbr2)

nrow(silvania)-nrow(sbr2)


# ----------------  SBR
sbr <- read.csv(here("batch-upload", "Sao_Benedito_River_wi_batch_upload", "images.csv"))
nrow(sbr)

sbr2 <- distinct(sbr, deployment_id, image_id, .keep_all=TRUE)
nrow(sbr2)

nrow(sbr)-nrow(sbr2)
#View(sbr2)


