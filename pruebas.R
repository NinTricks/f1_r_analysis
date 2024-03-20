library(httr)
library(jsonlite)

response <- GET('https://api.openf1.org/v1/laps?driver_number=14&meeting_key=latest&session_key=latest')
parsed_data <- fromJSON(content(response, 'text'))
print(parsed_data)

plot(x=parsed_data$lap_number, y=parsed_data$lap_duration)
