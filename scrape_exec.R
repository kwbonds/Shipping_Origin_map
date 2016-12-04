library(plyr)
library(dplyr)
library(tidyr)
require(RSelenium)
# pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
Sys.sleep(5)
# eCap <- list(phantomjs.page.settings.loadImages = FALSE)
# remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
# remDr$open()
vessels <- c("CONCORDIA", "HYUNDAI PREMIUM", "MALLECO", "Not a ship")
source("vessel_scrape2.R")
vessel_table <- ldply(vessel_list2$Vessel, function(x) scrape(x), .progress = "text", .inform = TRUE)
names(vessel_table) <- c("Requested Vessel", "Returned", "lon", "lon_Hemi", "lat", "lat_Hemi", "Heading")

vessel_table_plot <- subset(vessel_table, Returned!="" & lat_Hemi== "N" & lon_Hemi=="E")


# vessel_table2 <- ldply(vessels, function(x) scrape(x), .progress = "text", .inform = TRUE)
# 
# vessel_table <- ldply("HYUNDAI PREMIUM", function(x) scrape(x), .progress = "text", .inform = TRUE)
vessel_table2 <- ldply("CONCORDIA", function(x) scrape(x), .progress = "text", .inform = TRUE)
# vessel_table3 <- ldply("MALLECO", function(x) scrape(x), .progress = "text", .inform = TRUE)
# 
# scrape("Zim Rotterdam")
# remDr$getCurrentURL()
# scrape("CONCORDIA")

remDr$navigate("https://www.google.com")

pJS$stop()
