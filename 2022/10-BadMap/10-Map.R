# Packages ----

library(tidyverse)
library(sf)


# Données ----

communes <-
  st_read(here::here("2022",
                     "10-BadMap",
                     "communes_reproj.gpkg"))


france <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "France_rapprochee.gpkg")) |>
  st_union() |> 
  smoothr::smooth(method = "ksmooth",
                  smoothness = 5) 


# Carte ----


ggplot() +
  geom_sf(data = france,
          size = .1,
          fill = "#fdf9fb",
          color = "#212E52") +
  geom_sf(data = communes,
          size = 0,
          fill = "#ecc0b9") +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#fdf9fb",
                                       color = "#fdf9fb"),
        panel.background = element_rect(fill = "#fdf9fb",
                                        color = "#fdf9fb")) +
  coord_sf(st_bbox(france)[c(1,3)],
           st_bbox(france)[c(2,4)])


# END
