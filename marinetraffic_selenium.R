require(RSelenium)
pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
Sys.sleep(5)
eCap <- list(phantomjs.page.settings.loadImages = FALSE)
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
remDr$open()
 #remDr$navigate("https://www.vesselfinder.com/vessels/HYUNDAI-PREMIUM-IMO-9625530-MMSI-636015876")
 #remDr$navigate("https://www.vesselfinder.com/vessels/MALLECO-IMO-9395525-MMSI-255805776")
 remDr$navigate("https://www.vesselfinder.com/vessels")
# remDr$navigate("https://www.vesselfinder.com/vessels/RHL-CONCORDIA-IMO-9539688-MMSI-636092424")
Sys.sleep(5)

webElem <- remDr$findElement(using = "css", "#search-holder .selectize-input.items.not-full")
webElem$clickElement()
webElem <- remDr$findElement(using = "css", "#search-holder .selectize-input.items.not-full.focus.input-active input")
# webElem <- remDr$findElement(using = "css", "#search-holder .input-active")
webElem$sendKeysToElement(list("HYUNDAI PREMIUM"))
Sys.sleep(3)
webElem$sendKeysToElement(list(key= "enter"))
Sys.sleep(5)
remDr$screenshot(useView  = TRUE, display = TRUE)

webElem2 <- remDr$findElement(using = "css", ".button.success")
webElem2$clickElement()
Sys.sleep(10)

webElem3 <- remDr$findElement(using = "css", "a.th")
webElem3$clickElement()
webElem3$screenshot(useView  = TRUE, display = TRUE)
my_source <- remDr$getPageSource()
# my_source <- remDr$getPageSource()

f_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude...',my_source))+ 10, stop = as.numeric(gregexpr(pattern ='latitude...',my_source)) +10 + 10)
f_lat
a_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude">',my_source))+10, stop = as.numeric(gregexpr(pattern ='latitude">',my_source)) + 20)
a_lat <- substr(a_lat, 1, regexpr('<', a_lat)-1)

a_lon <- substr(my_source, as.numeric(gregexpr(pattern ='longitude',my_source)) + 11, stop = as.numeric(gregexpr(pattern ='longitude',my_source)) + 21)
a_lon

course <- substr(my_source, as.numeric(gregexpr(pattern =' °&nbsp',my_source)) -5, stop = as.numeric(gregexpr(pattern =' °&nbsp',my_source))-1)
course <- trimws(course)
course
a_course <- substr(my_source, as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 95, stop = as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 102)
a_course

vessel <- substr(my_source, as.numeric(gregexpr(pattern ='og:title',my_source)) + 19, stop = as.numeric(gregexpr(pattern =' - see',my_source))-13)
vessel
remDr$close()
pJS$stop()

library(readr)
write.csv(my_source, paste("my_source_", Sys.Date(), ".txt"))
