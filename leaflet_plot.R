install.packages("leaflet")
library(leaflet)
library(dplyr)

m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = 114.33002, lat = 22.55963, popup= "Hyundai Premium Cargo Ship") %>% 
  addMarkers(lng = 120.30818, lat = 22.56662, popup = "Zim Rotterdam")
m

m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = vessel_table$lon, lat = vessel_table$lat, popup= vessel_table$`Requested Vessel`)
m

container <- daily_tracker %>%
  subset(Vessel != '') %>% 
  select(`Container Number`, Vessel, `Purchase Order Number`) %>% 
  group_by(`Container Number`, Vessel) %>% 
summarise(Num_DPOs = n_distinct(`Purchase Order Number`))
container

vessels <- daily_tracker %>%
  subset(Vessel != '') %>% 
  select(`Container Number`, Vessel ) %>% 
  group_by(Vessel) %>% 
  summarise(Num_Container = n_distinct(`Container Number`)) %>% 
  arrange(desc(Num_Container))
vessels

vessels <- daily_tracker %>%
  subset(Vessel != '') %>% 
  select(`Container Number`, Vessel , `Planned InDC Date`) %>% 
  group_by(Vessel,`Planned InDC Date`) %>% 
  summarise(Num_Container = n_distinct(`Container Number`)) %>% 
  arrange(desc(Num_Container))
View(vessels)

  test <- daily_tracker %>% subset(Vessel != '')
  head(test)
