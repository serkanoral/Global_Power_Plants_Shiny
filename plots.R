library(leaflet)
library(tidyverse)
library(htmltools)
library(randomcoloR)
library(RColorBrewer)

#Creating palettes
set.seed(123)
primary_fuel_col <- colorFactor(distinctColorPalette(15), dt$primary_fuel)

cluster_col <- 
  colorFactor(palette = c("#fee8c8", "#fdbb84", "#e34a33"), 
              levels = c("Low", "Medium", "High"))


# Global - Map - Funtion
leaf_global <- function(fuel_name, level) {
  
  dt %>% 
    filter(primary_fuel == fuel_name, cluster %in% level) %>% 
    leaflet(options = leafletOptions(zoomControl = FALSE,
                                     minZoom = 1, maxZoom = 5)) %>% 
   # addTiles() %>% 
    addCircles(lng =~ longitude,lat =~ latitude,opacity = 0.5, 
               color =~ cluster_col(cluster),radius =~ capacity_mw ) %>% 
    addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
    addLegend(pal = cluster_col, values =~ cluster,opacity = 0.8,title = NA) %>% 
    setView(lng = 28,lat = 41, zoom = 2.4)
  
}


# Power plant capacity by fuel type - Global and Country
set.seed(123)
total_fuel_plot <- function(country_names = unique_country_names){
  dt %>% 
    filter(country_long %in% country_names) %>% 
    mutate(total = sum(capacity_mw)) %>% 
    group_by(primary_fuel) %>% 
    summarise(perc = sum(capacity_mw/ total)) %>% 
    ggplot(aes(perc,fct_reorder(primary_fuel,perc) , fill =primary_fuel)) +
    geom_col() + labs(x = NULL, y = NULL, fill = "Primary Fuel") +
    ggtitle("Power Plants Percentage by Fuel Type ") + 
    theme(legend.position = "none",panel.background = element_rect(fill = "#efefef")) +
    scale_x_continuous(labels = scales::percent) +
    geom_text(aes(y =fct_reorder(primary_fuel,perc),label =  scales::percent(perc,2))) 
}

# Global - top 15 country with top percentage of certain fuel type

top_15_plot <- function(fuel_name){
  dt %>% 
    group_by(country_long) %>% 
    mutate(total = sum(capacity_mw)) %>% 
    group_by(primary_fuel,.add = TRUE) %>% 
    summarise(country_long, primary_fuel,perc = sum(capacity_mw)/total,.groups = 'drop') %>% 
    ungroup() %>% 
    distinct() %>% 
    filter(primary_fuel == fuel_name) %>% 
    arrange(desc(perc)) %>% 
    slice_head(n=15) %>% 
    ggplot(aes(perc,fct_reorder(country_long,perc) , fill =country_long)) +
    geom_col() + labs(x = NULL, y = NULL, fill = "Primary Fuel") +
    ggtitle(paste0("How many percentage capacity each country has on ",fuel_name,"?" )) + 
    theme(legend.position = "none",panel.background = element_rect(fill = "#efefef")) +
    scale_x_continuous(labels = scales::percent) +
    geom_text(aes(y =fct_reorder(country_long,perc),label =  scales::percent(perc,2)))
}
  

# Country - Second page map - by country
 leaf_country <- function(country_name, fuel_type){
   
   dt %>% 
     filter(country_long == country_name & primary_fuel %in% fuel_type ) %>% 
     leaflet(options = leafletOptions(zoomControl = FALSE,
                                      minZoom = 1, maxZoom = 12)) %>% 
     #addTiles() %>% 
     addCircles(lng =~ longitude,lat =~ latitude,opacity = 0.7, 
                color =~ primary_fuel_col(primary_fuel),
                radius =~ capacity_mw,
                label = ~htmlEscape(paste0("Name: ",name,","," Fuel: ",primary_fuel,","," Capacity(MW): ",capacity_mw))) %>% 
     addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
     addLegend(pal = primary_fuel_col, values =~ primary_fuel,opacity = 0.8,title = NA)
   
 } 

 # Country - fuel type percentage by country
 set.seed(123)
 country_fuel_plot <- function(fuel_type, country_name) {
   dt %>% 
     filter(primary_fuel %in% fuel_type & country_long == country_name) %>% 
     ggplot(aes(fct_rev(fct_reorder(name,capacity_mw)) , capacity_mw, fill = primary_fuel) )+ 
     geom_col() +theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
                       panel.background = element_rect(fill = "#efefef")) +
     labs(x = NULL, y = NULL, fill = "Fuel Type") + ggtitle("Power Plants")
   }

 # Country - to show the available fuel type power plants
 country_fuel_select <- function(country_name){
   dt %>% 
     filter(country_long == country_name) %>% 
     distinct(primary_fuel) %>% 
     pull(primary_fuel) %>% as.character()
 }
  






