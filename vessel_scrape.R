scrape <- function(boat){
  # require(RSelenium)
  pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
  Sys.sleep(5)
  eCap <- list(phantomjs.page.settings.loadImages = FALSE)
  remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
  Sys.sleep(2)
  remDr$open()
  Sys.sleep(2)
  #remDr$navigate("https://www.vesselfinder.com/vessels/HYUNDAI-PREMIUM-IMO-9625530-MMSI-636015876")
  #remDr$navigate("https://www.vesselfinder.com/vessels/MALLECO-IMO-9395525-MMSI-255805776")
  remDr$navigate("https://www.vesselfinder.com/vessels?t=4")
  # remDr$navigate("https://www.vesselfinder.com/vessels/RHL-CONCORDIA-IMO-9539688-MMSI-636092424")
  Sys.sleep(10)
  
  webElem <- remDr$findElement(using = "css", "#ship-search-adv")
  Sys.sleep(10)
  webElem$sendKeysToElement(list(boat))
 # remDr$screenshot(useView  = TRUE, display = FALSE)
  webElem2 <- remDr$findElement(using = "css", ".button.success")
  webElem2$clickElement()
  Sys.sleep(10)
  
  webElem3 <- remDr$findElement(using = "css", "a.th")
  webElem3$clickElement()
  Sys.sleep(10)
  #webElem3$screenshot(useView  = TRUE, display = TRUE)
  my_source <- remDr$getPageSource()
  # my_source <- remDr$getPageSource()
  
  # f_lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude...',my_source))+ 10, stop = as.numeric(gregexpr(pattern ='latitude...',my_source)) +10 + 10)
  lat <- substr(my_source, as.numeric(gregexpr(pattern ='latitude',my_source)) + 10, stop = as.numeric(gregexpr(pattern ='latitude',my_source)) + 20)
  
  lon <- substr(my_source, as.numeric(gregexpr(pattern ='longitude',my_source)) + 11, stop = as.numeric(gregexpr(pattern ='longitude',my_source)) + 21)

  course <- substr(my_source, as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 95, stop = as.numeric(gregexpr(pattern ='Course/Speed',my_source)) + 102)
  
  
  remDr$close()
  pJS$stop()
  Sys.sleep(5)
  return(c(boat, lat, lon, course))
}

