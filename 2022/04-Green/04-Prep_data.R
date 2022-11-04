# Pays d'Afrique

world <- rnaturalearth::ne_countries(scale = "small",
                                     continent = "Africa",
                                     returnclass = "sf")

library(ggplot2)


ggplot(world) +
  geom_sf()

# writexl::write_xlsx(data.frame(pays = unique(world$name)),
#                     here::here("2022",
#                                "04-Green",
#                                "Pays_afrique.xlsx"))


asia <- 
  rnaturalearth::ne_countries(scale = "small",
                              continent = "Asia",
                              returnclass = "sf")

writexl::write_xlsx(data.frame(pays = unique(asia$name)),
                    here::here("2022",
                               "04-Green",
                               "Pays_asie.xlsx"))



europe <- 
  rnaturalearth::ne_countries(scale = "small",
                              continent = "Europe",
                              returnclass = "sf")

writexl::write_xlsx(data.frame(pays = unique(europe$name)),
                    here::here("2022",
                               "04-Green",
                               "Pays_europe.xlsx"))



# Pour avoir les couleurs ----

lien = "https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg"

sortie = colorfindr::get_colors(img = lien,min_share = .01) 

sortie; colorfindr::plot_colors(sortie)
  
