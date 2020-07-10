
# Fix coordinates or Camera.Trap.Names
# using left_join function

# read table with correct coordinates
coords <- read.csv(here("Datasets", "jamari", "jamari_tabela_coordenadas_conservacao.csv"))
names(coords) <- c("latGMS", "longGMS", "Latitude", "Longitude", "Camera.Trap.Name", "Camera.Trap.Name.2016", "Camera.Trap.Name.2017")
coords$Camera.Trap.Name <- paste("CT", coords$Camera.Trap.Name, sep="-")
coords$Camera.Trap.Name.2016 <- paste("CT", coords$Camera.Trap.Name.2016, sep="-")
#attach(coords)

# join the two datasets using Camera.Trap.Name as matching column
jamari <- left_join(jamari, coords, by = "Camera.Trap.Name")


# rename Lat/Long columns
jamari$Latitude <- jamari$Latitude.y
jamari$Longitude <- jamari$Longitude.y
