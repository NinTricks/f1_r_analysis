library(shiny)
library(httr)
library(jsonlite)

current_session = "latest" #ojo que no llevo meetings, no problemo creo
LIMX = c(1,2)



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
mainPlot <- function(drivers_in,limitey){
  plot(df[which(df$driver_number==14),"lap_duration"], type='n', ylim=c(limitey[1],limitey[2]), col = paste0("#",dfDrivers[which(dfDrivers$driver_number==14),"team_colour"]))
  #lines(c(1.1,1.2,1.5),type='l')
  for (d in drivers_in){
    n = dfDrivers[which(dfDrivers$full_name==d), "driver_number"]
    lines(df[which(df$driver_number==n),"lap_duration"],lwd=3.5, type='l', ylim=c(limitey[1],limitey[2]), col = paste0("#",dfDrivers[which(dfDrivers$driver_number==n),"team_colour"]))
  }
  grid(nx=NULL,ny=NULL,
       lty = 2,
       col = "gray",
       lwd = 1)
}



#tomar datos
dfDrivers <- getDrivers(current_session)
dfLaps <- getLaps(current_session)



#definir ui-------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Lap Time"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("limitey", "Integer:",
                  min = 60, max = 170,
                  value = c(80,150)),
      checkboxGroupInput("checkbox_drivers","Pilotos:",dfDrivers[ , "full_name"]),
      actionButton("update","Actualizar gráfico"),
      actionButton("reload_data","Actualizar datos"),
    ),
    mainPanel(
      plotOutput("plot"),
      textOutput("seleccionados")
    )
  
  
)
)

#server logic----------------------------------------------------------
server <- function(input,output){
  
  driverInput <- eventReactive(input$update,input$checkbox_drivers)
  
  output$plot <- renderPlot({
    mainPlot(driverInput(),input$limitey)
  })
  
  output$seleccionados <- renderText({
    driverInput()
  })
  
  eventReactive(input$reload_data,getLaps())
  
  
}

#run the app
shinyApp(ui=ui,server=server)
