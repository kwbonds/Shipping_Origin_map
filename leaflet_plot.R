install.packages("leaflet")
library(leaflet)
library(dplyr)

# OLD ----
# m <- leaflet() %>% 
#   addTiles() %>% 
#   addMarkers(lng = 114.33002, lat = 22.55963, popup= "Hyundai Premium Cargo Ship") %>% 
#   addMarkers(lng = 120.30818, lat = 22.56662, popup = "Zim Rotterdam") %>% 
#   
# m
# 
# leaf_plot <- left_join(vessel_table_plot, Enriched_table, by = c("Requested Vessel"="Vessel"))
# leaf_plot <- leaf_plot[complete.cases(leaf_plot),]
# 
# m <- leaflet() %>% 
#   addProviderTiles("Esri.WorldTopoMap") %>% 
#   addMarkers(lng = vessel_table_plot$lon, lat = vessel_table_plot$lat, popup= paste(vessel_table_plot$`Requested Vessel`,paste(" Heading: ", vessel_table_plot$Heading), sep = "<br/>")) %>% 
#   addWMSTiles(
#     "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
#     layers = "nexrad-n0r-900913",
#     options = WMSTileOptions(format = "image/png", transparent = TRUE),
#     attribution = "Weather data © 2012 IEM Nexrad"
#   )
# m
# leaf_plot ----
m <- leaflet() %>% 
  addProviderTiles("Esri.WorldTopoMap") %>% 
  addMarkers(lng = leaf_plot$lon, lat = leaf_plot$lat, popup= paste(leaf_plot$`Requested Vessel`,paste("Heading: ", leaf_plot$Heading), paste("Total Units: ", format(leaf_plot$Units, big.mark = ",")), paste("Estimated ELC: $", format(leaf_plot$`Total Estimated ELC`, big.mark = ",")), sep = "<br/>")) %>% 
  addWMSTiles(
    "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
    layers = "nexrad-n0r-900913",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    attribution = "Weather data © 2012 IEM Nexrad"
  )
m

# Old ----
# m <- leaflet() %>% 
#   addProviderTiles("Esri.WorldTopoMap") %>% 
#   addMarkers(lng = vessel_table_plot$lon, lat = vessel_table_plot$lat, popup= paste(vessel_table_plot$`Requested Vessel`, " Heading: ", vessel_table_plot$Heading)) %>% 
#   addWMSTiles(
#     "http://geoserver.arpa.piemonte.it/geoserver/radar_img/ows/rit_pioggia_neve_WM",
#     layers = "nexrad-n0r-900913",
#     options = WMSTileOptions(format = "image/png", transparent = TRUE),
#     attribution = "Weather data © 2012 IEM Nexrad"
#   )
# m

# Container and Vessels  form daily tracker table ----
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

  # test <- daily_tracker %>% subset(Vessel != '')
  # head(test)

# Facetted tables plot ----  
  m <- leaflet() %>% 
    addProviderTiles("Esri.WorldTopoMap") %>% 
    addMarkers(lng = plot_NE$lon, lat = plot_NE$lat, popup= paste(plot_NE$`Requested Vessel`, paste("Last Position: ", plot_NE$last_pos_dt),paste(" Heading: ", plot_NE$Heading), sep = "<br/>")) %>% 
    addMarkers(lng = -(plot_NW$lon), lat = plot_NW$lat, popup= paste(plot_NW$`Requested Vessel`, paste("Last Position: ", plot_NW$last_pos_dt),paste(" Heading: ", plot_NW$Heading), sep = "<br/>")) %>% 
    addMarkers(lng = plot_SE$lon, lat = -(plot_SE$lat), popup= paste(plot_SE$`Requested Vessel`, paste("Last Position: ", plot_SE$last_pos_dt),paste(" Heading: ", plot_SE$Heading), sep = "<br/>")) %>% 
    addMarkers(lng = -(plot_SW$lon), lat = -(plot_SW$lat), popup= paste(plot_SW$`Requested Vessel`, paste("Last Position: ", plot_SW$last_pos_dt),paste(" Heading: ", plot_SW$Heading), sep = "<br/>")) %>% 
    addWMSTiles(
      "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
      layers = "nexrad-n0r-900913",
      options = WMSTileOptions(format = "image/png", transparent = TRUE),
      attribution = "Weather data © 2012 IEM Nexrad"
    )
  m