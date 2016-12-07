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

load("EDW_IUF_YTD_2016-11-22.rda")
# Create Enriched_table ----
EDW_IUF_YTD_clean <- EDW_IUF_YTD %>% 
  filter((ACTL_SHP_MODE_CD == "O" & CONTAINER_ID != "") & (is.na(ACTUAL_IN_DC_LCL_DATE) | is.na(ACTUAL_STOCKED_LCL_DATE))) 


EDW_Table <- EDW_IUF_YTD_clean %>% 
  select(CONTAINER_ID, ORD_QTY, Total_FCST_ELC) %>% 
  group_by(CONTAINER_ID) %>% 
  summarise("Units" = floor(sum(ORD_QTY)), "Total Estimated ELC"= floor(sum(Total_FCST_ELC )))

Enriched_table <- left_join(EDW_Table, container_list, by = c("CONTAINER_ID"= "Container Number"))
Enriched_table <-  Enriched_table %>% filter(Vessel != "") %>% 
  group_by(Vessel) %>% 
  summarise("Units" = floor(sum(Units)), "Total Estimated ELC"= floor(sum(`Total Estimated ELC`)))
# Create vessel_table_plot ----
 vessel_table_plot <- subset(vessel_table, Returned!="")
 # vessel_table_plot <- vessel_table
# Create table for leafplot ----
 leaf_plot <- left_join(vessel_table_plot, Enriched_table, by = c("Requested Vessel"="Vessel"))
 leaf_plot <- leaf_plot %>% filter(Returned != "")
# OLD ----
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
# leaf_plot with rbind ----
m <- leaflet() %>% 
  addProviderTiles("Esri.WorldTopoMap") %>% 
  addMarkers(lng = plot_all$lon, lat = plot_all$lat, 
             popup= paste(plot_all$`Requested Vessel`, 
                          paste("Last Report: ", plot_all$`Last Position DT`),
                          paste("Heading: ", plot_all$Heading), 
                          paste("Total Units: ", format(plot_all$Units, big.mark = ",")), 
                          paste("Estimated ELC: $", format(plot_all$`Total Estimated ELC`, big.mark = ",")), 
                          sep = "<br/>")) %>% 
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
    addMarkers(lng = plot_NE$lon, lat = plot_NE$lat, 
               popup= paste(plot_NE$`Requested Vessel`, 
                            paste("Last Position: ", plot_NE$`Last Position DT`), 
                            paste(" Heading: ", plot_NE$Heading), 
                            paste("Total Units: ", format(plot_NE$Units, big.mark = ",")), 
                            paste("Estimated ELC: $", format(plot_NE$`Total Estimated ELC`, big.mark = ",")), sep = "<br/>")) %>% 
    addMarkers(lng = (plot_NW$lon), lat = plot_NW$lat, 
               popup= paste(plot_NW$`Requested Vessel`, paste("Last Position: ", plot_NW$`Last Position DT`), 
                            paste(" Heading: ", plot_NW$Heading), 
                            paste("Total Units: ", format(plot_NW$Units, big.mark = ",")), 
                            paste("Estimated ELC: $", format(plot_NW$`Total Estimated ELC`, big.mark = ",")), sep = "<br/>")) %>% 
    # addMarkers(lng = plot_SE$lon, lat = (plot_SE$lat), 
    #            popup= paste(plot_SE$`Requested Vessel`, paste("Last Position: ", plot_SE$`Last Position DT`),
    #                         paste(" Heading: ", plot_SE$Heading), 
    #                         paste("Total Units: ", format(plot_SE$Units, big.mark = ",")), 
    #                         paste("Estimated ELC: $", format(plot_SE$`Total Estimated ELC`, big.mark = ",")),sep = "<br/>")) %>% 
    # addMarkers(lng = (plot_SW$lon), lat = (plot_SW$lat), 
    #            popup= paste(plot_SW$`Requested Vessel`, paste("Last Position: ", plot_SW$`Last Position DT`), 
    #                         paste(" Heading: ", plot_SW$Heading), 
    #                         paste("Total Units: ", format(plot_SW$Units, big.mark = ",")), 
    #                         paste("Estimated ELC: $", format(plot_SW$`Total Estimated ELC`, big.mark = ",")),sep = "<br/>")) %>% 
    addWMSTiles(
      "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
      layers = "nexrad-n0r-900913",
      options = WMSTileOptions(format = "image/png", transparent = TRUE),
      attribution = "Weather data © 2012 IEM Nexrad"
    )
  m
  