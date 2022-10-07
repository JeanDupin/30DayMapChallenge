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


france <- st_read(here::here("2022",
                             "00-Fonds_de_carte",
                             "France_rapprochee.gpkg")) |> 
  st_union() |> 
  st_as_sf()



ggplot() +
  geom_sf(data = france,
          size = .1,
          fill = "#E8E8E8") +
  geom_point(data = gares,
             aes(x,y,
                 color = indicatrice),
             size = .1) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#B0AEAE",
                                       color = "#B0AEAE"),
        panel.background = element_rect(fill = "#B0AEAE",
                                        color = "#B0AEAE"))


ggsave(here::here("2022",
                   "01-Points",
                   "gares.svg"),
       width = 21,
       height = 21,
       units = "cm")

