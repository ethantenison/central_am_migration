library(ggplot2)
library(dplyr)
library(janitor)
library(tidyverse)
library(viridis)
library(raster)
library(maptools)

df <- read.csv("Human Development Index (HDI).csv", stringsAsFactors = FALSE)
names(df) <- as.matrix(df[1,])
df <- df[-1,]
df <- clean_names(df)
df$country[df$country == "United States"] <- "United States of America"



# Central America Map--------------------------
install.packages(c("cowplot", "googleway", "ggplot2", "ggrepel", 
                   "ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata"))
library("ggplot2")
theme_set(theme_bw())
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")
world <- ne_countries(scale='medium',returnclass = 'sf')
class(world)

world <- left_join(world, df, by = c("sovereignt"="country"))
world[is.na(world)] <- 0
world$x2018[world$x2018 == ".."] <- "0"
world<-world[!(world$x2018 <.5),]
world$x2018 <- as.numeric(world$x2018)

(ggulf <- ggplot(data = world) +
      geom_sf(aes(fill = x2018)) +
      annotate(geom = "text", x = -90, y = 26, label = "Gulf of Mexico", 
               fontface = "italic", color = "grey22", size = 6) +
      coord_sf(xlim = c(-102.15, -74.12), ylim = c(7.65, 33.97), expand = FALSE) +
      scale_fill_viridis(option = "plasma") +
      theme( axis.title.x = element_blank(), 
            axis.title.y = element_blank(), panel.background = element_rect(fill = "azure"), 
            panel.border = element_rect(fill = NA)))
