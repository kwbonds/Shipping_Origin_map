# require(RSelenium)
# RSelenium::startServer()
# eCap <- list(phantomjs.binary.path = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
# remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
# remDr$open()


require(RSelenium)
pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
Sys.sleep(5)
eCap <- list(phantomjs.page.settings.loadImages = FALSE)
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
remDr$open()
 remDr$navigate("https://www.vesselfinder.com/vessels/HYUNDAI-PREMIUM-IMO-9625530-MMSI-636015876")
 remDr$navigate("https://www.vesselfinder.com/vessels/MALLECO-IMO-9395525-MMSI-255805776")
 remDr$navigate("https://www.vesselfinder.com/vessels?t=4")
remDr$navigate("https://www.vesselfinder.com/vessels/RHL-CONCORDIA-IMO-9539688-MMSI-636092424")
Sys.sleep(5)
remDr$screenshot(useView  = TRUE, display = FALSE)

my_source <- remDr$getPageSource()

f_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude...',my_source))+ 10, stop = as.numeric(gregexpr(pattern ='latitude...',my_source)) +10 + 10)
f_lat
a_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude',my_source)) + 10, stop = as.numeric(gregexpr(pattern ='latitude',my_source)) + 20)
a_lat
a_lon <- substr(my_source, as.numeric(gregexpr(pattern ='longitude',my_source)) + 11, stop = as.numeric(gregexpr(pattern ='longitude',my_source)) + 21)
a_lon
a_course <- substr(my_source, as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 95, stop = as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 102)
a_course

webElem <- remDr$findElement(using = "css", "#ship-search-adv")
webElem$sendKeysToElement(list("Hyundai Premium"))
# webElem$sendKeysToElement(list(key = "return"))
# search_button <- remDr$findElement(using = "class", "#search-holder")
# webElem$sendKeysToElement(sendKeys =  "enter")
# webElem$screenshot(useView  = TRUE, display = TRUE)
#webElem$sendKeysToElement(list(key = 'enter'))

#webElem <- remDr$findElement(using = "css", ".value")
#webElem <- remDr$findElement(using = "css", "input")
#webElem$sendKeysToElement(list("HYUNDAI PREMIUM"))

webElem2 <- remDr$findElement(using = "css", ".button.success")
webElem2$clickElement()
Sys.sleep(10)

webElem3 <- remDr$findElement(using = "css", "a.th")
webElem3$clickElement()
webElem3$screenshot(useView  = TRUE, display = TRUE)
my_source <- remDr$getPageSource()

# webElem <- remDr$findElement(using = "id", "div-gpt-ad-1372944779896-1")
# webElem <- remDr$findElements(using = "css selector", "div input")
# webElem <- remDr$getActiveElement()
# remDr$screenshot(useView  = TRUE, display = TRUE)

# elements <- remDr$findElements(using = "css selector", "div input")

#remDr$screenshot(useView  = TRUE, display = TRUE)
# webElem <- remDr$findElement(using = "xpath", "div input[@class = 'form-control']")
webElem$sendKeysToElement(list("HYUNDAI PREMIUM", "enter"))
webElem$goForward()

remDr$close()
pJS$stop()

library(readr)
write.csv(my_source, paste("my_source_", Sys.Date(), ".txt"))
