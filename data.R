library(tidyverse)

library(RColorBrewer)




power_plants <- read_csv("global_power_plant_database_v_1_3/global_power_plant_database.csv")

# If we want the maps on ggplot, we need below data manipulation

# cols <- power_plants %>% 
#   miss_var_summary() %>% 
#   filter(pct_miss < 40) %>% 
#   select(variable) %>% 
#   as.vector()
# 
# names(cols) <- NULL
# 
# data_1 <- power_plants %>% 
#   select(cols %>% unlist(), -(estimated_generation_note_2013:estimated_generation_note_2017)) %>% 
#   mutate(country_long = case_when(country_long == "Brunei Darussalam" ~ "Brunei",
#                                   country_long == "Congo" ~ "Democratic Republic of the Congo",
#                                   country_long == "Cote DIvoire" ~ "Ivory Coast",
#                                   country_long == "Macedonia" ~ "North Macedonia",
#                                   country_long == "Syrian Arab Republic" ~ "Syria",
#                                   country_long == "Trinidad and Tobago" ~ "Trinidad",
#                                   country_long == "United Kingdom" ~ "UK",
#                                   country_long == "United States of America" ~ "USA",
#                                   TRUE ~ country_long))
# 
# world_map <- map_data("world") 
# 
# 
# groups <- world_map %>% 
#   group_by(region) %>% 
#   summarise(group = min(group)) 
# 
# data_2 <- data_1 %>% 
#   left_join(groups, by = c("country_long" = "region") ) 
# 
# 
# data_2 %>% 
#   summarise(min = min(capacity_mw), max = max(capacity_mw))
# 
# set.seed(123)
# cluster <- kmeans(data_2 %>% select(capacity_mw),centers = 3,iter.max = 20,nstart = 3)
# 
# cluster$cluster
# 
# data_2$cluster <- cluster$cluster
# 
# 
# data_3 <- data_2 %>% 
#   mutate(cluster = case_when(cluster == 1 ~ "High", 
#                              cluster == 2 ~ "Low", TRUE ~ "Medium")) %>% 
#   mutate_if(is.character, factor) %>% 
#   mutate(cluster = fct_relevel(cluster, "Low", after = 2 ))
# 
# 
# 
# 
# 
# data_4 <- data_3 %>% 
#   left_join(codelist %>% select(iso3c, region), by = c("country" = "iso3c")) %>% 
#   mutate(region = case_when(country_long == "Antarctica" ~ "Antarctica",
#                             country_long == "Kosovo" ~ "Europe & Central Asia",
#                             country_long == "Western Sahara" ~ "Sub-Saharan Africa",
#                             TRUE ~ region))
# 
# 
# 
# world_map_1 <- world_map %>% 
#   left_join(codelist %>% 
#               select(country.name.en, region), by = c("region" = "country.name.en")) 
# 
# 
# world_map_1 %>% 
#   filter(is.na(region.y)) %>% 
#   select(region) %>% unique()
# 
# world_map_2 <- world_map_1 %>% 
#   mutate(region.y = case_when(region== "Antarctica" ~ "Antarctica",
#                               region == "French Southern and Antarctic Lands" ~ "Antarctica",
#                               region == "Antigua" ~ "Latin America & Caribbean",
#                               region == "Barbuda" ~ "Latin America & Caribbean",
#                               region == "Bosnia and Herzegovina" ~ "Europe & Central Asia",
#                               region == "Saint Barthelemy" ~ "Europe & Central Asia",
#                               region == "Ivory Coast" ~ "Sub-Saharan Africa",
#                               region == "Democratic Republic of the Congo" ~ "Sub-Saharan Africa",
#                               region == "Republic of Congo" ~ "Sub-Saharan Africa",
#                               region == "Curacao" ~ "Latin America & Caribbean",
#                               region == "Czech Republic" ~ "Europe & Central Asia",
#                               region == "Canary Islands" ~ "Latin America & Caribbean",
#                               region == "Reunion" ~ "Sub-Saharan Africa",
#                               region == "Mayotte" ~ "East Asia & Pacific",
#                               region == "Micronesia" ~ "East Asia & Pacific",
#                               region == "UK" ~ "Europe & Central Asia",
#                               region == "Heard Island" ~ "Antarctica",
#                               region == "Cocos Islands" ~ "East Asia & Pacific",
#                               region == "Chagos Archipelago" ~ "Sub-Saharan Africa",
#                               region == "Siachen Glacier" ~ "South Asia",
#                               region == "Nevis" ~ "Latin America & Caribbean",
#                               region == "Saint Kitts" ~ "Latin America & Caribbean",
#                               region == "Saint Lucia" ~ "Latin America & Caribbean",
#                               region == "Saint Martin" ~ "Latin America & Caribbean",
#                               region == "Myanmar" ~ "South Asia",
#                               region == "Bonaire" ~ "Latin America & Caribbean",
#                               region == "Sint Eustatius" ~ "Latin America & Caribbean",
#                               region == "Saba" ~ "Latin America & Caribbean",
#                               region == "Madeira Islands" ~ "Sub-Saharan Africa",
#                               region == "Azores" ~ "Sub-Saharan Africa",
#                               region == "Palestine" ~ "Middle East & North Africa",
#                               region == "Western Sahara" ~ "Sub-Saharan Africa",
#                               region == "South Sandwich Islands" ~ "Latin America & Caribbean",
#                               region == "South Georgia" ~ "Latin America & Caribbean",
#                               region == "Saint Helena" ~ "Sub-Saharan Africa",
#                               region == "Ascension Island" ~ "Sub-Saharan Africa",
#                               region == "Saint Pierre and Miquelon" ~ "North America",
#                               region == "Sao Tome and Principe" ~ "Sub-Saharan Africa",
#                               region == "Swaziland" ~ "Sub-Saharan Africa",
#                               region == "Turks and Caicos Islands" ~ "Latin America & Caribbean",
#                               region == "Trinidad" ~ "Latin America & Caribbean",
#                               region == "Tobago" ~ "Latin America & Caribbean",
#                               region == "USA" ~ "North America",
#                               region == "Vatican" ~ "Europe & Central Asia",
#                               region == "Grenadines" ~ "Latin America & Caribbean",
#                               region == "Saint Vincent" ~ "Latin America & Caribbean",
#                               region == "Virgin Islands" ~ "Latin America & Caribbean",
#                               region == "Wallis and Futuna" ~ "East Asia & Pacific",
#                               TRUE ~ region.y))
# 
# 
# 
# 
# 
# # Data ----
# 
# 
# 
# 
# map <- world_map_2%>% 
#   rename(country = "region",
#          region = "region.y")


# dt <- data_4 %>% 
#   select(country_long,name,capacity_mw,latitude,longitude,primary_fuel,cluster)


# I prefer kmeans to cluster the data, we could do it manually as well. 
set.seed(123)
cluster <- kmeans(power_plants %>% select(capacity_mw),centers = 3,iter.max = 20,nstart = 3)

power_plants$cluster <- cluster$cluster

power_plants <- power_plants %>% 
  mutate(cluster = case_when(cluster == 1 ~ "High", 
                             cluster == 2 ~ "Low", TRUE ~ "Medium")) %>% 
  mutate_if(is.character, factor) %>% 
  mutate(cluster = fct_relevel(cluster, "Low", after = 2 ))


dt <- power_plants %>% 
  select(country_long,name,capacity_mw,latitude,longitude,primary_fuel,cluster)

unique_primary_fuel<-  dt %>% 
  mutate(total = sum(capacity_mw)) %>% 
  group_by(primary_fuel) %>% 
  summarise(perc = sum(capacity_mw/ total)) %>% 
  arrange(desc(perc)) %>% pull(primary_fuel) %>% as.character()

unique_country_names<- dt %>% 
  distinct(country_long) %>% 
  arrange(country_long) %>% 
  pull(country_long) %>% as.character()
  
unique_levels <- dt %>% 
  distinct(cluster) %>% 
  pull(cluster) %>% as.character()



# remove unnecessary data

rm(list=ls()[! ls() %in% c("map","dt","unique_primary_fuel","unique_country_names","unique_levels")])






