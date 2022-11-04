# Packages ----

library(tidyverse)
library(sf)

scale_fill_fermenter_custom <- function(pal, na.value = "#C6C6C6", guide = "coloursteps", aesthetics = "fill", ...) {
  binned_scale("fill", "fermenter", ggplot2:::binned_pal(scales::manual_pal(unname(pal))), na.value = na.value, guide = guide, ...)  
}


# Donnees ----

africa <- 
  rnaturalearth::ne_countries(scale = "small",
                              continent = "Africa",
                              returnclass = "sf") |> 
  left_join(readxl::read_xlsx(here::here("2022",
                                         "04-Green",
                                         "Pays_afrique.xlsx")) |> 
              data.table::setnames(new = c("name","part_vert")),
            by = "name") |> 
  select(name, part_vert)

asia <- 
  rnaturalearth::ne_countries(scale = "small",
                              continent = "Asia",
                              returnclass = "sf") |> 
  left_join(readxl::read_xlsx(here::here("2022",
                                         "04-Green",
                                         "Pays_asie.xlsx")),
            by = "name") |> 
  filter(!is.na(part_vert)) |> 
  select(name, part_vert)


europe <- 
  rnaturalearth::ne_countries(scale = "small",
                              continent = "Europe",
                              returnclass = "sf") |> 
  left_join(readxl::read_xlsx(here::here("2022",
                                         "04-Green",
                                         "Pays_europe.xlsx")),
            by = "name") |> 
  filter(!is.na(part_vert)) |> 
  select(name, part_vert)


world <-
  rbind(africa, asia, europe) |> 
  mutate(part_vert = part_vert * 100)


# Carte ----

camcorder::gg_record(width = 21, height = 21,
                     units = "cm")


ggplot(world) +
  geom_sf(aes(fill = part_vert),
          size = .1,
          color = "#646363") +
  scale_fill_fermenter_custom(c("#8BC84A","#4BB375","#1CA459","#068043","#036237"),
                              breaks = seq(0,100,20)) +
  theme_void() +
  theme(legend.direction = "horizontal",
        legend.text = element_blank(),
        legend.position = c(.2,.2),
        legend.title.align = .5,
        legend.key.width = unit(1.3,"cm"),
        legend.key.height = unit(.4,"cm"),
        plot.background = element_rect(fill = "#8DB0E1",
                                       color = "#8DB0E1"),
        panel.background = element_rect(fill = "#8DB0E1",
                                        color = "#8DB0E1")) +
  coord_sf(st_bbox(africa)[c(1,3)],
           st_bbox(africa)[c(2,4)]) +
  labs(fill = "")


ggsave(here::here("2022",
                  "04-Green",
                  "carte.png"),
       width = 21,
       height = 21,
       units = "cm")
