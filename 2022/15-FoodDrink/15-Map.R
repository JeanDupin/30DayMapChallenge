# Packages ----

library(tidyverse)

library(sf)


# Données ----


vins <-
  st_read(here::here("2022",
                     "15-FoodDrink",
                     "communes_vin.shp"))


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

camcorder::gg_record(width = 21,
                     height = 21,
                     units = "cm")

ggplot() +
  # Fond de carte
  geom_sf(data = eau,
          size = 0,
          fill = "#8DB0E1") +
  geom_sf(data = europe,
          fill = "#C6C6C6",
          size = .2,
          color = "#868686") +
  # Contour France
  geom_sf(data = france,
          size = .2,
          fill = NA,
          color = "#868686") +
  # Gares
  geom_sf(data = vins,
             aes(fill = grp_name2,
                 color = grp_name2)) +
  scale_fill_manual(values = MetBrewer::met.brewer("Paquin", n=17)) +
  scale_color_manual(values = MetBrewer::met.brewer("Paquin", n=17)) +
  # Theme
  theme_void() +
  theme(legend.direction = "horizontal",
        legend.text = element_blank(),
        # legend.position = c(.815,.06),
        legend.position = "none",
        legend.title.align = .5,
        legend.key.width = unit(1.3,"cm"),
        legend.key.height = unit(.4,"cm"),
        plot.background = element_rect(fill = "#fdf9fb",
                                       color = "#fdf9fb"),
        panel.background = element_rect(fill = "#fdf9fb",
                                        color = "#fdf9fb")) +
  coord_sf(st_bbox(france)[c(1,3)],
           st_bbox(france)[c(2,4)]) +
  labs(fill = "")


ggsave(here::here("2022",
                  "15-FoodDrink",
                  "carte_vins.png"),
       width = 21, height = 21, units = "cm",
       dpi = 300)
