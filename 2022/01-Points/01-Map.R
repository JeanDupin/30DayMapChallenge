# Packages ----


library(tidyverse)
library(data.table)
library(sf)


# Données & fond de carte ----

gares <-
  fread(here::here("2022",
                   "01-Points",
                   "gares_classees.csv"),
        encoding = "UTF-8") |> 
  rename(x = lambert_x,
         y = lambert_y)


france <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "France_rapprochee.gpkg")) |>
  st_union() |>
  st_as_sf()

voies <- 
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "voies_ferrees.gpkg"))


# Carte ----

ggplot() +
  geom_sf(data = france,
          size = 0,
          fill = "#ecc0b9",
          color = "white") +
  geom_sf(data = voies,
          size = .3,
          color = "white") +
  geom_point(data = gares,
             aes(x,y,
                 color = indicatrice),
             size = .5) +
  scale_color_manual(values = c("#212E52",
                                "#D8511D")) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#fdf9fb",
                                       color = "#fdf9fb"),
        panel.background = element_rect(fill = "#fdf9fb",
                                        color = "#fdf9fb"))


ggsave(here::here("2022",
                  "01-Points",
                  "gares.svg"),
       width = 21,
       height = 21,
       units = "cm")


# Avec Zoom d'IDF ----


# Zoom sur l'IDF

idf_zoom <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "France_avec_zoom.gpkg")) |> 
  filter(reg == "11")


idf_zoom <-
  cbind(idf_zoom,
        idf_zoom |>
          st_centroid() |>
          st_coordinates() |>
          data.frame()) |>
  filter(X < 400000) |>
  select(-X, -Y) |>
  st_union() |>
  st_as_sf()



# Voies ferrées IDF
voies_zoom <- 
  voies |> 
  mutate(geometry = geometry * 2.78 + c(-1634506,-12046235)) |> 
  st_set_crs(2154) |> 
  st_intersection(idf_zoom)



# Gares d'IDF
gares_idf <- 
  gares |> 
  filter(reg == "11") |> 
  mutate(x = x * 2.78 + -1634506,
         y = y * 2.78 - 12046235) |> 
  st_as_sf(coords = c("x","y"),
           crs = 2154) |> 
  st_intersection(idf_zoom)

gares_idf <-
  cbind(gares_idf |> 
          st_drop_geometry(),
        gares_idf |> 
          st_coordinates() |> 
          data.frame() |> 
          rename(x = X,
                 y = Y))





ggplot() +
  # Fond de carte
  geom_sf(data = idf_zoom,
          size = 0,
          fill = "#ecc0b9",
          color = "white") +
  geom_sf(data = france,
          size = 0,
          fill = "#ecc0b9",
          color = "white") +
  # Voies
  geom_sf(data = voies,
          size = .3,
          color = "white") +
  geom_sf(data = voies_zoom,
          size = .3,
          color = "white") +
  # Gares
  geom_point(data = gares,
             aes(x,y,
                 color = indicatrice),
             size = 1,
             shape = 16) +
  geom_point(data = gares_idf,
             aes(x,y,
                 color = indicatrice),
             size = 1,
             shape = 16) +
  # scale_color_manual(values = c("#212E52",
  #                               "#D8511D")) +
  scale_color_manual(values = c(alpha("#212E52",.8),
                                alpha("#D8511D",.8))
                     ) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#fdf9fb",
                                       color = "#fdf9fb"),
        panel.background = element_rect(fill = "#fdf9fb",
                                        color = "#fdf9fb"))




ggsave(here::here("2022",
                   "01-Points",
                   "gares2.svg"),
       width = 21,
       height = 21,
       units = "cm")

