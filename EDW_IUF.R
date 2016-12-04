library(RODBC)
library(dplyr)

my_connect <- odbcConnect(dsn= "IP EDWP", uid= my_uid, pwd= my_pwd)
sqlQuery(my_connect, query = "SELECT  * from dbc.dbcinfo;")

EDW_IUF_YTD <- sqlQuery(my_connect, 
                     query = "select * from SRAA_SAND.EDW_IUF_YTD;")

save(EDW_IUF_YTD, file = paste("EDW_IUF_YTD_", Sys.Date(), ".rda", sep = ""))

load("EDW_IUF_YTD_2016-11-22.rda")

Enriched_table <- left_join(EDW_Table, container_list, by = c("CONTAINER_ID"= "Container Number"))

EDW_Table <- EDW_IUF_YTD %>% 
  select(CONTAINER_ID, ORD_QTY, Total_FCST_ELC) %>% 
  group_by(CONTAINER_ID) %>% 
  summarise("Units" = floor(sum(ORD_QTY)), "Total Estimated ELC"= floor(sum(Total_FCST_ELC )))