library(httr)
library(jsonlite)
library(forstringr)
library(chron)


#devuelve dataframe del json de intervals
getIntervals <- function(session){
  response <- GET(paste0('https://api.openf1.org/v1/intervals?session_key=',session))
  parsed_data <- fromJSON(content(response, 'text'))
  
  df <- data.frame(parsed_data)
  
  return(df)
}

dfIntervals <- getIntervals("latest")


plot(x=dfIntervals$date)



ttt <- xts(as.ts(dfIntervals$date), order.by=as.ts(dfIntervals$date))
coredata(timeseries)



plot(x=ttt, y=1)



a <- str_right(dfIntervals$date,15) #recorte de la hora
x <- chron(times=a)
typeof(x)

plot(x)

plot(x[which(dfIntervals$driver_number==14)])

