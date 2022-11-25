library(leaflet)
primary_fuel_col <- colorFactor(topo.colors(15), dt$primary_fuel)

cluster_col <- 
  colorFactor(palette = c("#fee8c8", "#fdbb84", "#e34a33"), 
              levels = c("Low", "Medium", "High"))

leaf_global <- function() {
  dt %>% 
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


dt %>% 
  group_by(country_long) %>% 
  mutate(total = sum(capacity_mw)) %>% 
  group_by(primary_fuel,.add = TRUE) %>% 
  mutate(perc = round(capacity_mw/total,2)) %>% view()
  
dt %>% 
  group_by(country_long) %>% 
  mutate(total = sum(capacity_mw)) %>% 
  group_by(primary_fuel,.add = TRUE) %>% 
  mutate(perc = round(capacity_mw/total,2)) %>% view()






