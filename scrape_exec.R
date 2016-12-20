library(plyr)
library(dplyr)
library(tidyr)
require(RSelenium)
# pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
Sys.sleep(5)
# eCap <- list(phantomjs.page.settings.loadImages = FALSE)
# remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
# remDr$open()
# vessels <- c("CONCORDIA", "HYUNDAI PREMIUM", "MALLECO", "Not a ship")

source("vessel_scrape2.R")
vessel_table <- ldply(EDW_vessels$Vessel, function(x) scrape(x), .progress = "text", .inform = TRUE)
# vessel_table <- ddply(vessel_list2, "Vessel", function(x) scrape(x), .progress = "text", .inform = TRUE)
names(vessel_table) <- c("Requested Vessel", "Returned", "lon", "lon_Hemi", "lat", "lat_Hemi", "Heading", "Last Position DT")

# save(vessel_table, file = "vessel_table.rtf")
# load("vessel_table.rtf")

leaf_plot <- leaf_plot %>% filter(Returned != "")

plot_NE <- subset(leaf_plot, Returned!="" & lat_Hemi== "N" & lon_Hemi=="E")
plot_NW <- subset(leaf_plot, Returned!="" & lat_Hemi== "N" & lon_Hemi=="W")
plot_SE <- subset(leaf_plot, Returned!="" & lat_Hemi== "S" & lon_Hemi=="E")
plot_SW <- subset(leaf_plot, Returned!="" & lat_Hemi== "S" & lon_Hemi=="W")

plot_NW$lon <- paste("-", plot_NW$lon, sep = "")
plot_SE$lat <- paste("-", plot_SE$lat, sep = "")
plot_SW$lat <- paste("-", plot_SW$lat, sep = "")
plot_SW$lon <- paste("-", plot_SW$lon, sep = "")

plot_all <- rbind(plot_NW, plot_NE, plot_SE, plot_SW)

# vessel_table2 <- ldply(vessels, function(x) scrape(x), .progress = "text", .inform = TRUE)
# 
# vessel_table <- ldply("HYUNDAI PREMIUM", function(x) scrape(x), .progress = "text", .inform = TRUE)
vessel_table2 <- ldply("CONCORDIA", function(x) scrape(x), .progress = "text", .inform = TRUE)
names(vessel_table2) <- c("Requested Vessel", "Returned", "lon", "lon_Hemi", "lat", "lat_Hemi", "Heading", "Last Position DT")
# vessel_table3 <- ldply("MALLECO", function(x) scrape(x), .progress = "text", .inform = TRUE)
# 
# scrape("Zim Rotterdam")
# remDr$getCurrentURL()
# scrape("CONCORDIA")

remDr$navigate("https://www.google.com")

pJS$stop()


