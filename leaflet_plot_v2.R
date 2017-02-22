library(plyr)
library(dplyr)
library(tidyr)
library(leaflet)
require(RSelenium)
library(rChoiceDialogs)
library(flexdashboard)

# Choose file directory ----
choose_file_directory <- function()
{
  v <- jchoose.dir()
  return(v)
}
# setup environment ----
prompt_for_week <- function()
{ 
  n <- readline(prompt="Enter Week number: ")
  return(as.integer(n))
}


SOT_OTS_directory <- choose_file_directory()

EOW <- prompt_for_week()

# EDW_IUF_YTD_clean <- EDW_IUF_YTD %>% 
#   filter((ACTL_SHP_MODE_CD == "O" & CONTAINER_ID != "") & !(is.na(ACTUAL_IN_DC_LCL_DATE) | is.na(ACTUAL_STOCKED_LCL_DATE) | is.na(ACTUAL_DEST_CONSOL_LCL_DATE) | is.na(ACTUAL_DOM_DEPART_LCL_DATE))) 


# Create EDW_IUF_YTD_clean table ----
source("EDW_IUF.R")
# Create container_list table ----
source("Daily_tracker.R")
# Build Enriched EDW table ----

EDW_Shipped_Enrich <- left_join(EDW_IUF_YTD_clean, container_list, by = c("CONTAINER_ID"="Container Number"))
EDW_Shipped_Enrich <- EDW_Shipped_Enrich %>%  subset(Shp_Cxl_WK >= EOW - 2 & Shp_Cxl_WK <= EOW +2 & Vessel != "")

EDW_vessels <- EDW_Shipped_Enrich %>% 
  select(Vessel) %>% 
  group_by(Vessel) %>% 
  dplyr::summarise(`count`= n())
# Scrape vessels ----
source("vessel_scrape2.R")
vessel_table <- ldply(EDW_vessels$Vessel, function(x) scrape(x), .progress = "text", .inform = TRUE)
# vessel_table <- ddply(vessel_list2, "Vessel", function(x) scrape(x), .progress = "text", .inform = TRUE)
names(vessel_table) <- c("Requested Vessel", "Returned", "lon", "lon_Hemi", "lat", "lat_Hemi", "Heading", "Last Position DT")
# Join EDW_Shipped_Enrich with vessel_table ----
vessel_table_plot <- subset(vessel_table, Returned!="")

vessel_table_plot <- left_join(EDW_Shipped_Enrich, vessel_table, by= c("Vessel"="Returned"))
vessel_table_plot <- vessel_table_plot %>%  
  group_by(Vessel, lon, lat, lon_Hemi, lat_Hemi, Heading, `Last Position DT`) %>% 
  summarise("Units" = floor(sum(ORD_QTY)), 
            "Total Estimated ELC"= floor(sum(`Total_FCST_ELC`)),
            "Max Planned InDC" = max(PLANNED_IN_DC_DATE),
            "Destination country" = first(DEST_COUNTRY_CODE))


# Process table for plotting ----
leaf_plot <- vessel_table_plot

plot_NE <- subset(leaf_plot, lat_Hemi== "N" & lon_Hemi=="E")
plot_NW <- subset(leaf_plot, lat_Hemi== "N" & lon_Hemi=="W")
plot_SE <- subset(leaf_plot, lat_Hemi== "S" & lon_Hemi=="E")
plot_SW <- subset(leaf_plot, lat_Hemi== "S" & lon_Hemi=="W")

plot_NW$lon <- paste("-", plot_NW$lon, sep = "")
plot_SE$lat <- paste("-", plot_SE$lat, sep = "")
plot_SW$lat <- paste("-", plot_SW$lat, sep = "")
plot_SW$lon <- paste("-", plot_SW$lon, sep = "")

plot_all <- rbind(plot_NW, plot_NE, plot_SE, plot_SW) %>% 
  subset(`Total Estimated ELC` > 10000)

oceanIcons <- iconList(
  ship = makeIcon("blue.png", iconWidth = 30, iconHeight = 30))

# Plot ----
m <- leaflet() %>% 
  addProviderTiles("Esri.WorldTopoMap") %>% 
  addMarkers(lng = plot_all$lon, lat = plot_all$lat, 
             # icon = oceanIcons$ship,
             options = markerOptions(riseOnHover = TRUE),
             clusterOptions = markerClusterOptions(zoomToBoundsOnClick = FALSE)
             ,popup= paste(plot_all$`Vessel`,
                          paste("Last Report: ", plot_all$`Last Position DT`),
                          paste("Heading: ", plot_all$Heading),
                          paste("Total Units: ", format(plot_all$Units, big.mark = ",")),
                          paste("Estimated ELC: $", format(plot_all$`Total Estimated ELC`, big.mark = ",")),
                          paste("Max Planned InDC: ", plot_all$`Max Planned InDC`),
                          paste("Sample Destination: ", plot_all$`Destination country`),
                          sep = "<br/>")
             )

save(m, file = "Map1.rda")
save(vessel_table, file = "vessel_table.rda")


# Plot2 ----
m2 <- leaflet() %>% 
  addProviderTiles("Esri.WorldTopoMap") %>% 
  addMarkers(lng = plot_all$lon, lat = plot_all$lat, 
             # icon = oceanIcons$ship,
            options = markerOptions(draggable = TRUE),
             # clusterOptions = markerClusterOptions(zoomToBoundsOnClick = TRUE),
             popup= paste(plot_all$`Vessel`, 
                          paste("Last Report: ", plot_all$`Last Position DT`),
                          paste("Heading: ", plot_all$Heading), 
                          paste("Total Units: ", format(plot_all$Units, big.mark = ",")), 
                          paste("Estimated ELC: $", format(plot_all$`Total Estimated ELC`, big.mark = ",")), 
                          paste("Max Planned InDC: ", plot_all$`Max Planned InDC`),
                          paste("Sample Destination: ", plot_all$`Destination country`),
                          sep = "<br/>")) %>% 
  # addMarkers(lng = plot_all$lon, lat = plot_all$lat, 
  #            # icon = oceanIcons$ship,
  #            options = markerOptions(riseOnHover = TRUE),
  #            clusterOptions = markerClusterOptions(zoomToBoundsOnClick = FALSE)
  #            # ,popup= paste(plot_all$`Vessel`, 
  #            #              paste("Last Report: ", plot_all$`Last Position DT`),
  #            #              paste("Heading: ", plot_all$Heading), 
  #            #              paste("Total Units: ", format(plot_all$Units, big.mark = ",")), 
  #            #              paste("Estimated ELC: $", format(plot_all$`Total Estimated ELC`, big.mark = ",")), 
  #            #              paste("Max Planned InDC: ", plot_all$`Max Planned InDC`),
  #            #              paste("Sample Destination: ", plot_all$`Destination country`),
  #            #              sep = "<br/>")
  #            ) %>% 
  # addMarkers(lng = plot_all$lon, lat = plot_all$lat, icon = oceanIcons$ship)
  addWMSTiles(
    "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
    layers = "nexrad-n0r-900913",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    attribution = "Weather data © 2012 IEM Nexrad"
  )
  save(m2, file = "Map2.rda")
m
