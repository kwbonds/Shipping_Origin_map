require(RSelenium)
# Old ----
# pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
# Sys.sleep(5)
# eCap <- list(phantomjs.page.settings.loadImages = FALSE)
# remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
# remDr$open()
#  #remDr$navigate("https://www.vesselfinder.com/vessels/HYUNDAI-PREMIUM-IMO-9625530-MMSI-636015876")
#  #remDr$navigate("https://www.vesselfinder.com/vessels/MALLECO-IMO-9395525-MMSI-255805776")
#  remDr$navigate("https://www.vesselfinder.com/vessels")
# # remDr$navigate("https://www.vesselfinder.com/vessels/RHL-CONCORDIA-IMO-9539688-MMSI-636092424")
# Sys.sleep(5)
# 
# webElem <- remDr$findElement(using = "css", "#search-holder .selectize-input.items.not-full")
# webElem$clickElement()
# webElem <- remDr$findElement(using = "css", "#search-holder .selectize-input.items.not-full.focus.input-active input")
# # webElem <- remDr$findElement(using = "css", "#search-holder .input-active")
# webElem$sendKeysToElement(list("HYUNDAI PREMIUM"))
# Sys.sleep(3)
# webElem$sendKeysToElement(list(key= "enter"))
# Sys.sleep(5)
# remDr$screenshot(useView  = TRUE, display = TRUE)
# 
# webElem2 <- remDr$findElement(using = "css", ".button.success")
# webElem2$clickElement()
# Sys.sleep(10)
# 
# webElem3 <- remDr$findElement(using = "css", "a.th")
# webElem3$clickElement()
# webElem3$screenshot(useView  = TRUE, display = TRUE)
# 
# last_pos <- remDr$findElement(using = "id", "last_report_ts")
# last_pos_dt <- as.character(last_pos$getElementText())
# 
# my_source <- remDr$getPageSource()
# # my_source <- remDr$getPageSource()
# 
# f_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude...',my_source))+ 10, stop = as.numeric(gregexpr(pattern ='latitude...',my_source)) +10 + 10)
# f_lat
# a_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude">',my_source))+10, stop = as.numeric(gregexpr(pattern ='latitude">',my_source)) + 20)
# a_lat <- substr(a_lat, 1, regexpr('<', a_lat)-1)
# 
# a_lon <- substr(my_source, as.numeric(gregexpr(pattern ='longitude',my_source)) + 11, stop = as.numeric(gregexpr(pattern ='longitude',my_source)) + 21)
# a_lon
# 
# course <- substr(my_source, as.numeric(gregexpr(pattern =' °&nbsp',my_source)) -5, stop = as.numeric(gregexpr(pattern =' °&nbsp',my_source))-1)
# course <- trimws(course)
# course
# a_course <- substr(my_source, as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 95, stop = as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 102)
# a_course
# 
# vessel <- substr(my_source, as.numeric(gregexpr(pattern ='og:title',my_source)) + 19, stop = as.numeric(gregexpr(pattern =' - see',my_source))-13)
# vessel
# New ----
pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
Sys.sleep(5)
eCap <- list(phantomjs.page.settings.loadImages = FALSE)
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
Sys.sleep(2)
remDr$open()
Sys.sleep(2)
# Navigate to www.vesselfinder.com ----
remDr$navigate("https://www.vesselfinder.com/vessels")
Sys.sleep(5)
# Find input field and activate ----
webElem <- remDr$findElement(using = "css", "#search-holder .selectize-input.items.not-full")
webElem$clickElement()
webElem <- remDr$findElement(using = "css", "#search-holder .selectize-input.items.not-full.focus.input-active input")
# webElem <- remDr$findElement(using = "css", "#search-holder .input-active")
# Send a vessel ----
webElem$sendKeysToElement(list("CONCORDIA"))
Sys.sleep(3)
webElem$sendKeysToElement(list(key= "enter"))
Sys.sleep(15)
#webElem3$screenshot(useView  = TRUE, display = TRUE)
# Get last position date as text ----
last_pos <- remDr$findElement(using = "id", "last_report_ts")
last_pos_dt <- as.character(last_pos$getElementText())



# Get source ----
my_source <- remDr$getPageSource()
# my_source <- remDr$getPageSource()
last_pos_dt <- substr(my_source, as.numeric(gregexpr(pattern ='last_report_ts',my_source)) + 53, stop = as.numeric(gregexpr(pattern ='last_report_ts',my_source)) +100)
if(grepl('<',last_pos_dt)) {last_pos_dt <- substr(last_pos_dt, 1, regexpr('<', last_pos_dt)-1)}
last_pos_dt
# Search and scrape source for Lon/Lat, Course, vessel ---- 
# f_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude...',my_source))+ 10, stop = as.numeric(gregexpr(pattern ='latitude...',my_source)) +10 + 10)
a_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude">',my_source))+10, stop = as.numeric(gregexpr(pattern ='latitude">',my_source)) + 20)
if(grepl('<',a_lat)) {a_lat <- substr(a_lat, 1, regexpr('<', a_lat)-1)}
a_lat <- unlist(strsplit(a_lat, " "))
lat <- a_lat[1]
lat_hemi <-  a_lat[2]

a_lon <- substr(my_source, as.numeric(gregexpr(pattern ='longitude">',my_source)) + 11, stop = as.numeric(gregexpr(pattern ='longitude">',my_source)) + 21)
if(grepl('<', a_lon)) { a_lon <- substr(a_lon, 1, regexpr('<', a_lon)-1) }
a_lon <- unlist(strsplit(a_lon, " "))
lon <- a_lon[1]
lon_hemi <-  a_lon[2]

course <- substr(my_source, as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 95, stop = as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 102)
# course <- substr(my_source, as.numeric(gregexpr(pattern =' °&nbsp',my_source)) -5, stop = as.numeric(gregexpr(pattern =' °&nbsp',my_source))-1)
if(grepl('&', course)) { course <- substr(course, 1, regexpr('&', course)-1) }
course <- trimws(course)
vessel <- substr(my_source, as.numeric(gregexpr(pattern ='og:title',my_source)) + 19, stop = as.numeric(gregexpr(pattern =' - see',my_source))-13)


remDr$close()
pJS$stop()


library(readr)
write.csv(my_source, paste("my_source_", Sys.Date(), ".txt"))