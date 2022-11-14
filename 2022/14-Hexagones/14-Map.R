# Package ----

library(tidyverse)

library(sf)

scale_fill_fermenter_custom <- function(pal, na.value = "#C6C6C6", guide = "coloursteps", aesthetics = "fill", ...) {
  binned_scale("fill", "fermenter", ggplot2:::binned_pal(scales::manual_pal(unname(pal))), na.value = na.value, guide = guide, ...)  
}

`%notin%` <- Negate(`%in%`)

# Données ----


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
                   code %in% c("94", "01", "02", "03", "04", "05", "06"))) |> 
  smoothr::smooth("ksmooth", smoothness = 5)

radars <-
  st_read(here::here("2022",
                     "14-Hexagones",
                     "radars.shp"))

routes <-
  st_read(here::here("2022",
                     "00-Fonds_de_carte",
                     "routes_france.gpkg")) |> 
  filter(cl_admin == "Autoroute")


# Carte ----

camcorder::gg_record(width = 21,
                     height = 21,
                     units = "cm")

ggplot() +
  geom_sf(data = radars,
          aes(fill = densite),
          size = 0) +
  geom_sf(data = routes,
          color = "#286AC7",
          size = .4) +
  geom_sf(data = france,
          fill = NA,
          color = "#868686",
          size = .2) +
  scale_fill_fermenter_custom(c("#FBDFE4","#F5B8C2","#EB617F","#E4003A","#AD1638","#5D1212"),
                              breaks = seq(0,20,4)) +
  theme_void() +
  theme(legend.direction = "horizontal",
        legend.box = "horizontal",
        legend.spacing.x = unit(.5,"cm"),
        # legend.text = element_blank(),
        legend.position = c(.65,.06),
        # legend.title.align = .5,
        legend.key.width = unit(1.3,"cm"),
        legend.key.height = unit(.4,"cm"),
        plot.background = element_rect(fill = "#8DB0E1",
                                       color = "#8DB0E1"),
        panel.background = element_rect(fill = "#8DB0E1",
                                        color = "#8DB0E1")) +
  coord_sf(st_bbox(france)[c(1,3)],
           st_bbox(france)[c(2,4)]) +
  labs(fill = "",
       color = "")



# ggsave(here::here("2022",
#                   "14-Hexagones",
#                   "radars.png"),
#        width = 21, height = 21, units = "cm")
