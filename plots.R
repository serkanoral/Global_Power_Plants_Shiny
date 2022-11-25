library(leaflet)
library(tidyverse)
library(htmltools)

primary_fuel_col <- colorFactor(topo.colors(15), dt$primary_fuel)

cluster_col <- 
  colorFactor(palette = c("#fee8c8", "#fdbb84", "#e34a33"), 
              levels = c("Low", "Medium", "High"))

leaf_global <- function(fuel_name) {
  dt %>% 
    filter(primary_fuel == fuel_name) %>% 
    leaflet(options = leafletOptions(zoomControl = FALSE,
                                     minZoom = 1, maxZoom = 4)) %>% 
    addTiles() %>% 
    addCircles(lng =~ longitude,lat =~ latitude,opacity = 0.5, 
               color =~ cluster_col(cluster),radius = 10, ) %>% 
    addProviderTiles(providers$CartoDB.Voyager) %>% 
    addLegend(pal = cluster_col, values =~ cluster,opacity = 0.8,title = NA) %>% 
    setView(lng = 28,lat = 41, zoom = 2.4)
}

total_fuel_plot <- function(){
  dt %>% 
    mutate(total = sum(capacity_mw)) %>% 
    group_by(primary_fuel) %>% 
    summarise(perc = sum(capacity_mw/ total)) %>% 
    ggplot(aes(perc,fct_reorder(primary_fuel,perc) , fill =primary_fuel)) +
    geom_col() + labs(x = NULL, y = NULL, fill = "Primary Fuel") +
    ggtitle("Worldwide Power Plants Percentage by Fuel Type ") + 
    theme(legend.position = "none") +
    scale_x_continuous(labels = scales::percent) +
    geom_text(aes(y =fct_reorder(primary_fuel,perc),label =  scales::percent(perc,2)))
}


top_15_plot <- function(fuel_name){
  dt %>% 
    group_by(country_long) %>% 
    mutate(total = sum(capacity_mw)) %>% 
    group_by(primary_fuel,.add = TRUE) %>% 
    summarise(country_long, primary_fuel,perc = round(sum(capacity_mw)/total,2),.groups = 'drop') %>% 
    ungroup() %>% 
    distinct() %>% 
    filter(primary_fuel == fuel_name) %>% 
    arrange(desc(perc)) %>% 
    slice_head(n=15) %>% 
    ggplot(aes(perc,fct_reorder(country_long,perc) , fill =country_long)) +
    geom_col() + labs(x = NULL, y = NULL, fill = "Primary Fuel") +
    ggtitle(paste0("How many percentage capacity each country has on ",fuel_name )) + 
    theme(legend.position = "none") +
    scale_x_continuous(labels = scales::percent) +
    geom_text(aes(y =fct_reorder(country_long,perc),label =  scales::percent(perc,2)))
}
  

 leaf_country <- function(country_name, fuel_type){
   
   dt %>% 
     filter(country_long == country_name & primary_fuel == fuel_type ) %>% 
     leaflet(options = leafletOptions(zoomControl = FALSE,
                                      minZoom = 1, maxZoom = 12)) %>% 
     addTiles() %>% 
     addCircles(lng =~ longitude,lat =~ latitude,opacity = 0.7, 
                color =~ primary_fuel_col(primary_fuel),
                radius =~ capacity_mw,
                label = ~htmlEscape(paste0("Name: ",name,","," Fuel: ",primary_fuel,","," Capacity(MW): ",capacity_mw))) %>% 
     addProviderTiles(providers$CartoDB.Voyager) %>% 
     addLegend(pal = primary_fuel_col, values =~ primary_fuel,opacity = 0.8,title = NA)
   
 } 








