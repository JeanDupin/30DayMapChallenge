# Packages ----

library(tidyverse)
library(sf)


# Données ----

communes <-
  st_read(here::here("2022",
                     "10-BadMap",
                     "communes_reproj.gpkg"))


regions <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "France_rapprochee.gpkg"))


# Carte ----


ggplot() +
  geom_sf(data = regions,
          fill = NA) +
  geom_sf(data = communes[communes$libelle == "Paris",],
          size = .1,
          fill = "#FFC300")
