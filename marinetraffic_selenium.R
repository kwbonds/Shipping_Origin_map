require(RSelenium)
RSelenium::startServer()
eCap <- list(phantomjs.binary.path = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
remDr$open()


require(RSelenium)
pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
Sys.sleep(5)
eCap <- list(phantomjs.page.settings.loadImages = FALSE)
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
remDr$open()
remDr$navigate("http://www.marinetraffic.com")
Sys.sleep(5)
remDr$screenshot(useView  = TRUE, display = TRUE)


webElem <- remDr$findElement(using = "css", ".form-control")
# webElem <- remDr$findElements(using = "css selector", "div input")
webElem <- remDr$getActiveElement()
remDr$screenshot(useView  = TRUE, display = TRUE)

elements <- remDr$findElements(using = "css selector", "div input")

remDr$screenshot(useView  = TRUE, display = TRUE)
# webElem <- remDr$findElement(using = "xpath", "div input[@class = 'form-control']")
webElem$sendKeysToElement(list("HYUNDAI PREMIUM"))
remDr$close()
pJS$stop()
