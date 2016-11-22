install.packages("data.table")
library(data.table)
library(fread)
library(dplyr)

daily_tracker <- read_csv(file = "G:\\SF-LOGISTICS_METRICS\\daily_tracker\\daily_tracker.csv", 
                          col_types = cols(`Purchase Order Number` = col_character(), .default = col_character()))

daily_tracker <- fread(input = "G:\\SF-LOGISTICS_METRICS\\daily_tracker\\daily_tracker.csv")
# save(daily_tracker, file = "daily_tracker.rda")
# load(file = "daily_tracker.rda")
daily_tracker <- daily_tracker %>% subset(Vessel != "")

save(daily_tracker, file = paste("dailey_tracker_", Sys.Date(), ".rda", sep = ""))
