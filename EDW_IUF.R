library(RODBC)

my_connect <- odbcConnect(dsn= "IP EDWP", uid= my_uid, pwd= my_pwd)
sqlQuery(my_connect, query = "SELECT  * from dbc.dbcinfo;")

EDW_IUF_YTD <- sqlQuery(my_connect, 
                     query = "select * from SRAA_SAND.EDW_IUF_YTD;")

save(EDW_IUF_YTD, file = paste("EDW_IUF_YTD_", Sys.Date(), ".rda", sep = ""))
