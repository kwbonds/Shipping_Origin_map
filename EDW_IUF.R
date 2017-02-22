library(RODBC)
library(readr)
library(dplyr)

# Read in uname and pass ----
my_uid <- read_lines("C:\\Users\\Ke2l8b1\\Documents\\my_uid.txt")
my_pwd <- read_lines("C:\\Users\\Ke2l8b1\\Documents\\my_pwd.txt")

# ODBC connect ----
my_connect <- odbcConnect(dsn= "IP EDWP", uid= my_uid, pwd= my_pwd)
sqlQuery(my_connect, query = "SELECT  * from dbc.dbcinfo;")

EDW_IUF_YTD <- sqlQuery(my_connect, 
                     query = "select * from SRAA_SAND.EDW_IUF_YTD;")
# Save and Load ----
save(EDW_IUF_YTD, file = paste("EDW_IUF_YTD_", Sys.Date(), ".rda", sep = ""))
# load("EDW_IUF_YTD_2016-11-22.rda")
# Create EDW_IUF_YTD_clean table ----
EDW_IUF_YTD_clean <- EDW_IUF_YTD %>% 
  filter((ACTL_SHP_MODE_CD == "O" & CONTAINER_ID != "") & !(!is.na(ACTUAL_IN_DC_LCL_DATE) | !is.na(ACTUAL_STOCKED_LCL_DATE) | !is.na(ACTUAL_DEST_CONSOL_LCL_DATE) | !is.na(ACTUAL_DOM_DEPART_LCL_DATE))) 
# OLD ----
# EDW_vessels2 <- EDW_Shipped_Enrich %>% 
#   select(Vessel) %>% 
#   group_by(Vessel) %>% 
#   summarise(`count`= n())
# 
# # 
# # EDW_Table <- EDW_IUF_YTD_clean %>% 
# #   select(CONTAINER_ID, ORD_QTY, Total_FCST_ELC) %>% 
# #   group_by(CONTAINER_ID) %>% 
# #   summarise("Units" = floor(sum(ORD_QTY)), "Total Estimated ELC"= floor(sum(Total_FCST_ELC )))
# 
# Enriched_table <- left_join(EDW_Table, container_list, by = c("CONTAINER_ID"= "Container Number"))
# Enriched_table <-  Enriched_table %>% filter(Vessel != "") %>% 
#   group_by(Vessel) %>% 
#   summarise("Units" = floor(sum(Units)), "Total Estimated ELC"= floor(sum(`Total Estimated ELC`)))
