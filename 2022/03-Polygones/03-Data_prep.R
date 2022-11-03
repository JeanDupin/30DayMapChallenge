# Packages ----


library(tidyverse)
library(data.table)
library(sf)


# Données ----

gares <- 
  fread(here::here("2022",
                   "03-Polygones",
                   "gares.csv"),
        encoding = "UTF-8") |>
  janitor::clean_names() |> 
  filter(typequ == "E107") |> 
  select(x = lambert_x,
         y = lambert_y)


france <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "Regions_France_Metro.gpkg")) |> 
  filter(code != "94") |> 
  st_union() |> 
  st_as_sf() |> 
  smoothr::smooth("ksmooth", smoothness = 5)


gares.shp <-
  gares |> 
  mutate(id = 1:114,
         .before = 1) |> 
  st_as_sf(coords = c("x","y"),
           crs = 2154) |> 
  st_combine() |> 
  st_voronoi() |> 
  st_cast() |> 
  st_intersection(x = france)


# Export ----

st_write(gares.shp,
         here::here("2022",
                    "03-Polygones",
                    "gares.gpkg"))

