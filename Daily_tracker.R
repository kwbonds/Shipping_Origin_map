install.packages("data.table")
library(data.table)
library(fread)
library(dplyr)

# Read daily_tracker file ----
# daily_tracker <- read_csv(file = "G:\\SF-LOGISTICS_METRICS\\daily_tracker\\daily_tracker.csv", 
#                           col_types = cols(`Purchase Order Number` = col_character(), .default = col_character()))

daily_tracker <- fread(input = "G:\\SF-LOGISTICS_METRICS\\daily_tracker\\daily_tracker.csv")
# save(daily_tracker, file = "daily_tracker.rda")
# load(file = "daily_tracker.rda")
# Save/Load daily_tracker object ----
save(daily_tracker, file = paste("daily_tracker_", Sys.Date(), ".rda", sep = ""))
# load(file = "dailey_tracker_2016-12-01.rda")
daily_tracker <- daily_tracker %>% subset(Vessel != "")

# Create container_list and vessel_list ----
container_list <- daily_tracker %>% 
  filter(Vessel!= "") %>% 
  select(`Container Number`, Vessel) %>% 
  group_by(`Container Number`, Vessel) %>% 
  summarise(`count`= n())

# vessel_list <- daily_tracker %>% 
#   select(Vessel) %>% 
#   group_by(Vessel) %>% 
#   summarise(`count`= n())

# vessel_list2 <- vessel_list[3:102,]
