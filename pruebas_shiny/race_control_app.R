library(shiny)
library(httr)
library(jsonlite)

current_session = "latest"
#TODO: ajustar por fecha?

#Obtiene la tabla con la información de control de carrera
getRaceControlTable <- function(session){
  response <- GET(paste0('https://api.openf1.org/v1/race_control?session_key=latest&meeting_key=',session)) #hay session key, vigilar
  parsed_data <- fromJSON(content(response, 'text'))
  
  parsed_data["session_key"] = NULL
  parsed_data["meeting_key"] = NULL
  parsed_data["scope"] = NULL
  
  return(parsed_data)
}

printTableDirector <- function(){
  data <- getRaceControlTable(current_session)
  n = nrow(data)-17
  
  data <- data[-c(1:n), ]
  
  return(data)
}

getTiempoTable <- function(session){
  response <- GET(paste0('https://api.openf1.org/v1/weather?session_key=latest&meeting_key=',session))
  parsed_data <- fromJSON(content(response, 'text'))
  
  return(parsed_data)
}

printTableTiempo <- function(){
  data <- getTiempoTable(current_session)
  
  return(data[nrow(data),])
}

#definir ui-------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Race Control"),
  
  fluidRow(
    column(8,
           helpText(paste("Última actualización (hora española):")),
           textOutput("last_update"),
           wellPanel(helpText("Clima actual:"),tableOutput("table_tiempo"))
    )
  ),
  
  fluidRow(
    column(9,
           tableOutput("table_director")
    )
  )
    
  
)

#server logic----------------------------------------------------------
server <- function(input,output){
  
  autoInvalidate <- reactiveTimer(15000) #tiempo clock en ms
  timerTiempo <- reactiveTimer(60000)
  
  output$last_update <- renderText({
    autoInvalidate()
    paste(format(Sys.time(), "%H:%M:%S"))
  })
  
  output$table_director <- renderTable({
    autoInvalidate()
    printTableDirector()
  }, hover=TRUE)
  
  output$table_tiempo <- renderTable({
    timerTiempo()
    printTableTiempo()
  })
  
  
}

#run the app
shinyApp(ui=ui,server=server)
