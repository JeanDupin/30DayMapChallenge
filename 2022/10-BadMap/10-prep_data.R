# Packages ----

library(tidyverse)
library(sf)


# Données ----

communes <- st_read(here::here("2022",
                               "00-Fonds_de_carte",
                               "communes_rapprochees.gpkg")) |> 
  arrange(code)



# Table des translations

tranformation <- cbind(
  communes |> 
    arrange(code) |> 
    st_centroid() |> 
    st_coordinates() |> 
    data.frame() |> 
    rename(x1 = X,
           y1 = Y),
  communes |> 
    arrange(libelle) |> 
    st_centroid() |> 
    st_coordinates() |> 
    data.frame() |> 
    rename(x2 = X,
           y2 = Y)
) |> 
  mutate(x = x2 - x1,
         y = y2 - y1,
         .keep = "unused")



# Reprojection ----


reproj <- function(id){
  
  communes |>
    slice(id) |>
    mutate(geom = geom + c(tranformation[id, 1],
                           tranformation[id, 2])) |> 
    st_set_crs(2154)
  
}


communes_nouvelles <-
  map_dfr(1:nrow(communes), reproj)


# Export ----

st_write(communes_nouvelles,
         here::here("2022",
                    "10-BadMap",
                    "communes_reproj.gpkg"))
