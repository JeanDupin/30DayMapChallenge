# Packages ----

library(tidyverse)
library(data.table)

library(sf)

`%notin%` <- Negate(`%in%`)

# Données ----

radars <-
  fread(here::here("2022",
                   "14-Hexagones",
                   "radars.csv"),
        encoding = "UTF-8") |> 
  janitor::clean_names() |> 
  select(lon = longitude,
         lat = latitude,
         type,
         dep = departement)


france <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "France_rapprochee.gpkg"))

france <-
  france |> 
  filter(code %notin% c("94", "01", "02", "03", "04", "05", "06")) |>
  st_union() |>
  st_as_sf() |>
  rename(geom = x) |>
  mutate(code = "27",
         libelle = "metro",
         .before = 1) |>
  bind_rows(filter(france,
                   code %in% c("94", "01", "02", "03", "04", "05", "06")))



# Projection Kro ----

radars.shp <-
  radars |> 
  st_as_sf(coords = c("lon","lat"),
           crs = "WGS84") |> 
  st_transform(2154)

# Métropole
metropole <-
  radars.shp |> 
  filter(str_sub(dep,1,2) != "97" & dep %notin% c("2A","2B"))

# Corse
corse <- 
  radars.shp %>% 
  filter(dep %in% c("2A","2B")) %>%
  mutate(geometry = geometry + c(-166400,0)) %>%
  sf::st_set_crs(2154)

# Guadeloupe
guadeloupe <-
  radars.shp %>% 
  filter(dep == "971") %>%
  st_transform(5490) %>%
  mutate(geometry = geometry * 1.32+ c(-699983,4269050)) %>%
  st_set_crs(2154)

# Martinique
martinique <-
  radars.shp %>% 
  filter(dep == "972") %>%
  st_transform(5490) %>%
  mutate(geometry = geometry * 1.85 + c(-1134525,3517169)) %>%
  st_set_crs(2154)

# Guyane
guyane <-
  radars.shp %>% 
  filter(dep == "973") %>%
  st_transform(2972) %>%
  mutate(geometry = geometry * 0.25 + c(118687,6286270)) %>%
  st_set_crs(2154)

# Réunion
reunion <-
  radars.shp %>% 
  filter(dep == "974") %>%
  st_transform(2975) %>%
  mutate(geometry = geometry * 1.75 + c(-422169,-7132230)) %>%
  st_set_crs(2154)

# Fusion


radars.shp <-
  metropole %>%
  bind_rows(corse) %>%
  bind_rows(guadeloupe) %>%
  bind_rows(martinique) %>%
  bind_rows(guyane) %>%
  bind_rows(reunion); rm(corse, guadeloupe, martinique,
                         guyane, reunion, radars)



# Grille hexagonale & densité ----


grille <-
  st_make_grid(france, cellsize = 50000,square = F) |> 
  st_intersection(france) |> 
  st_as_sf()



grille$densite <-
  unlist(
    lapply(
      st_intersects(grille,
                    radars.shp),
        length)
  )



# Export ----

st_write(grille,
         here::here("2022",
                    "14-Hexagones",
                    "radars.shp"),
         append = F)


