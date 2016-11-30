install.packages("leaflet")
library(leaflet)
library(dplyr)

m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = 114.33002, lat = 22.55963, popup= "Hyundai Premium Cargo Ship") %>% 
  addMarkers(lng = 102.33348, lat = 1.88812, popup = "New Position")
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
