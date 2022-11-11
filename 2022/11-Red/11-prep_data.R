# Packages ----

library(tidyverse)
library(data.table)

library(sf)


# Données ----


croix <-
  fread(here::here("2022",
                   "11-Red",
                   "structures.csv"),
        encoding = "Latin-1") |> 
  filter(!is.na(lng) & !is.na(lat)) |>
  filter(lng > -30 & lat > 0) |> 
  select(1,lng,lat) |> 
  st_as_sf(coords = c("lng","lat"),
           crs = "WGS84") |> 
  st_transform(crs = 2154) |> 
  st_write(here::here("2022",
                      "11-Red",
                      "croix_rouge.shp"))





france <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "Regions_France_Metro.gpkg"))


ggplot(croix) +
  geom_sf(data = france) +
  geom_sf()

