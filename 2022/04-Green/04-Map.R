# Packages ----

library(tidyverse)
library(sf)


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

# camcorder::gg_record(width = 21, height = 21,
#                      units = "cm")


ggplot(world) +
  geom_sf(aes(fill = part_vert)) +
  coord_sf(xlim = c(st_bbox(africa)[1],st_bbox(africa)[3]),
           ylim = c(st_bbox(africa)[2],st_bbox(africa)[4]))
