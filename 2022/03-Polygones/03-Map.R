# Packages ----


library(tidyverse)
library(data.table)
library(sf)


scale_fill_fermenter_custom <- function(pal, na.value = "grey50", guide = "coloursteps", aesthetics = "fill", ...) {
  binned_scale("fill", "fermenter", ggplot2:::binned_pal(scales::manual_pal(unname(pal))), na.value = na.value, guide = guide, ...)  
}

scale_color_fermenter_custom <- function(pal, na.value = "grey50", guide = "coloursteps", aesthetics = "color", ...) {
  binned_scale("color", "fermenter", ggplot2:::binned_pal(scales::manual_pal(unname(pal))), na.value = na.value, guide = guide, ...)  
}

# Données & fond de carte ----


gares <- 
  fread(here::here("2022",
                   "03-Polygones",
                   "gares.csv"),
        encoding = "UTF-8") |>
  janitor::clean_names() |> 
  filter(typequ == "E107") |> 
  select(x = lambert_x,
         y = lambert_y)


gares.shp <-
  st_read(here::here("2022",
                     "03-Polygones",
                     "gares.gpkg")) |> 
  mutate(ha = st_area(geom) |> 
           as.numeric() / 10000,
         .before = 1)


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
  # Polygones
  geom_sf(data = gares.shp |> 
            mutate(ha = ha/100),
          size = .1,
          color = "#646363",
          aes(fill = ha)) +
  scale_fill_fermenter_custom(c("#F5B8C2","#EB617F","#E4003A",
                                "#AD1638","#5D1212")) +
  # Contour France
  geom_sf(data = france,
          size = .2,
          fill = NA,
          color = "#868686") +
  # Gares
  geom_point(data = gares,
             aes(x,y),
             size = 1.5,
             color = "#0C3A5A") +
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
                  "03-Polygones",
                  "gares.png"),
       width = 21,
       height = 21,
       units = "cm")
