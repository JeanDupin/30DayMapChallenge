# Packages ----

library(tidyverse)
library(data.table)

library(sf)


# Données ----

aoc <-
  fread(here::here("2022",
                   "15-FoodDrink",
                   "aocaop.csv"))

aoc |> 
  filter(str_sub(CI,1,2) == "21")


aop <-
  st_read(here::here("2022",
                     "15-FoodDrink",
                     "2022-05-20_delim_parcellaire_aoc_shp.shp"))


test = aop |> 
  mutate(grp_name2 = factor(grp_name2))


france <-
  st_read("//pd_as_ge_d1_50/ge_data_pd/creacartes_pd/fichiers-ihm/2020/francemetro/francemetro_2020.shp")

ggplot() +
  geom_sf(data = france) +
  geom_sf(data = test,
          aes(fill = grp_name2),
          size = 0)
