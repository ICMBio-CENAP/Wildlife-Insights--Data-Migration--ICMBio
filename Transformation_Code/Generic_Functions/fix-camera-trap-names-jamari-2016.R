
# Modify data with lookup table
# to fix coordinates or Camera.Trap.Names
# based on: https://nicercode.github.io/blog/2013-07-09-modifying-data-with-lookup-tables/

# source addNewData function
source(here("Transformation_Code", "Generic_Functions", "addNewData.R"))


# read wild.ID export file
jamari <- read.csv(here("Datasets", "jamari", "Wild_ID_FLONA_JAMARI_2016_updated.csv"))


# read coordinate dataset
coords <- read.csv(here("Datasets", "jamari", "jamari_tabela_coordenadas_conservacao.csv"))
names(coords) <- c("latGMS", "longGMS", "Latitude", "Longitude", "Camera.Trap.Name", "Camera.Trap.Name.2016", "Camera.Trap.Name.2017")
coords$Camera.Trap.Name <- paste("CT", coords$Camera.Trap.Name, sep="-")
coords$Camera.Trap.Name.2016 <- paste("CT", coords$Camera.Trap.Name.2016, sep="-")
attach(coords)


##---------- Lookup table for camera names --------------

## create lookup table that documents the changes we want to make to our dataframe
# lookupVariable = "Camera.Trap.Name", the name of the variable in the parent data we want to match against
# lookupValue =  Camera.Trap.Name, is the value of lookupVariable to match against
# newVariable is the variable to be changed
# newValue  = Nome.corrigido (is the value of newVariable for matched rows)
lookup <- tibble(lookupVariable="Camera.Trap.Name", lookupValue=Camera.Trap.Name.2016, newVariable="Camera.Trap.Name", newValue=Camera.Trap.Name)
print(lookup, n=Inf)
lookup <- lookup[1:45,]
write.csv(lookup, here("Datasets", "jamari", "lookup.csv"), row.names=FALSE)

allowedVars <- c("Camera.Trap.Name")
addNewData(here("Datasets", "jamari", "lookup.csv"), jamari, allowedVars)

