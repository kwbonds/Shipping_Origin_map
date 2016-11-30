library(plyr)
library(dplyr)
require(RSelenium)
pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
Sys.sleep(5)
# eCap <- list(phantomjs.page.settings.loadImages = FALSE)
# remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
# remDr$open()
vessels <- c("CONCORDIA", "HYUNDAI PREMIUM", "MALLECO")
source("vessel_scrape.R")
vessel_table <- ldply(vessels, function(x) scrape(x), .progress = "text", .inform = TRUE)

vessel_table <- ldply("HYUNDAI PREMIUM", function(x) scrape(x), .progress = "text")

scrape("HYUNDAI PREMIUM")
remDr$getCurrentURL()
scrape("CONCORDIA")

remDr$navigate("https://www.google.com")

pJS$stop()
