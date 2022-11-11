# Packages ----


library(tidyverse)
library(data.table)

library(sf)


# Données & fond de carte ----


croix <- 
  st_read(here::here("2022",
                     "11-Red",
                     "croix_rouge.shp"))


france <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "Regions_France_Metro.gpkg")) |> 
  filter(code != "94") |> 
  st_union() |> 
  st_as_sf() |> 
  smoothr::smooth("ksmooth", smoothness = 5) 

eau <- 
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "Mer.gpkg"))

europe <- 
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "Pays_Europe.gpkg"))





# Carte ----

# camcorder::gg_record(width = 21,
#                      height = 21,
#                      units = "cm")

ggplot() +
  # Fond de carte
  geom_sf(data = eau,
          size = 0,
          fill = "#8DB0E1") +
  geom_sf(data = europe |> 
            filter(CODGEO != "RU"),
          fill = "#C6C6C6",
          size = .2,
          color = "#868686") +
  geom_sf(data = europe |> 
            filter(CODGEO == "RU"),
          fill = "#8DB0E1",
          size = .2,
          color = "#8DB0E1") +
  # Contour France
  geom_sf(data = france,
          size = .2,
          fill = "#C6C6C6",
          color = "#868686") +
  # Gares
  geom_sf(data = croix,
          color = "#E4003A",
          size = 2,
          shape = 3) +
  # Theme
  theme_void() +
  theme(legend.direction = "horizontal",
        legend.text = element_blank(),
        legend.position = c(.815,.06),
        legend.title.align = .5,
        legend.key.width = unit(1.3,"cm"),
        legend.key.height = unit(.4,"cm"),
        plot.background = element_rect(fill = "#fdf9fb",
                                       color = "#fdf9fb"),
        panel.background = element_rect(fill = "#fdf9fb",
                                        color = "#fdf9fb")) +
  guides(fill = guide_colorsteps(title.position = "top")) +
  coord_sf(st_bbox(france)[c(1,3)],
           st_bbox(france)[c(2,4)]) +
  labs(fill = "")


ggsave(here::here("2022",
                  "11-Red",
                  "red_crosses.png"),
       width = 21,
       height = 21,
       units = "cm")
