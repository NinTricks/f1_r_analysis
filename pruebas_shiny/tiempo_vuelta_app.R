library(shiny)
library(httr)
library(jsonlite)

current_session = "latest" #ojo que no llevo meetings, no problemo creo
LIMX = c(1,2)
LIMY = c(91.5,98)


#devuelve dataframe del json de drivers
getDrivers <- function(session){
  response <- GET(paste0('https://api.openf1.org/v1/drivers?session_key=',session))
  parsed_data <- fromJSON(content(response, 'text'))
  
  df <- data.frame(parsed_data)
  
  df[which(df["team_name"] == "Kick Sauber"),"team_colour"] <- "520000" #apaño color sauber
  
  return(df)
}


#devuelve dataframe del json de laps
getLaps <- function(session){
  response <- GET(paste0('https://api.openf1.org/v1/laps?session_key=',session))
  parsed_data <- fromJSON(content(response, 'text'))
  
  df <- data.frame(parsed_data)
  
  df["segments_sector_1"] = NULL
  df["segments_sector_2"] = NULL
  df["segments_sector_3"] = NULL
  
  return(df)
}


#dibujar la gráfica
mainPlot <- function(drivers_in){
  plot(df[which(df$driver_number==14),"lap_duration"], type='n', ylim=LIMY, col = paste0("#",dfDrivers[which(dfDrivers$driver_number==14),"team_colour"]))
  #lines(c(1.1,1.2,1.5),type='l')
  for (d in drivers_in){
    n = dfDrivers[which(dfDrivers$full_name==d), "driver_number"]
    lines(df[which(df$driver_number==n),"lap_duration"],lwd=5, type='l', ylim=LIMY, col = paste0("#",dfDrivers[which(dfDrivers$driver_number==n),"team_colour"]))
  }
}



#tomar datos
dfDrivers <- getDrivers(current_session)
dfLaps <- getLaps(current_session)


#calcular limites de y en funcion de los datos recibidos



#definir ui-------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Lap Time"),
  
  fluidRow(
    column(2,
           checkboxGroupInput("checkbox_drivers","Pilotos:",dfDrivers[ , "full_name"])
    ),
    column(10,
           plotOutput("plot"),
           textOutput("seleccionados")
    )
  )
  
)

#server logic----------------------------------------------------------
server <- function(input,output){
  
  
  output$out_sector <- renderText({
    paste0(input$botones_sector)
  })
  
  output$plot <- renderPlot({
    mainPlot(input$checkbox_drivers)
  })
  
  output$seleccionados <- renderText({
    input$checkbox_drivers
  })
  
  
}

#run the app
shinyApp(ui=ui,server=server)
