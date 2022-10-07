

# Packages ----


library(tidyverse)
library(data.table)
library(sf)


# Données ----


# Gares de France & Projection Kronembourg
gares <- 
  fread(here::here("2022",
                   "01-Points",
                   "gares.csv"),
        encoding = "UTF-8") |>
  janitor::clean_names() |>
  # filter(typequ != "E109") |>
  arrange(depcom) |>
  mutate(
    qualite_xy = factor(qualite_xy),
    lambert_x = ifelse(
      str_sub(depcom, 1, 2) %in% c("2A", "2B"),
      lambert_x - 166400,
      lambert_x
    )
  ) |> 
  select(libvoie, typequ, dep, reg,
         lambert_x, lambert_y)


# Bons libellés de voie ----

clean_voie <- function(id.gare) {
  
  gares |> 
    slice(id.gare) |> 
    mutate(libvoie = janitor::make_clean_names(libvoie))
  
}

gares <-
  map_dfr(1:nrow(gares), clean_voie,
          .progress = T) |> 
  mutate(
    indicatrice = ifelse(str_detect(libvoie,"gare"),
                         "Oui",
                         "Non"),
    indicatrice = factor(indicatrice)
  )



# Export pour la carte ----

fwrite(gares,
       here::here("2022",
                  "01-Points",
                  "gares_classees.csv"),
       encoding = "UTF-8")
