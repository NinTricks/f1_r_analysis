library(shiny)
library(httr)
library(jsonlite)
library(forstringr)
library(chron)

#TODO: habria que gestionar margenes segun las fechas de las propias vueltas de "laps" de la api
# ojito que puede petar si la carrera empieza en un dia y acaba en otro



current_session = "latest" #ojo que no llevo meetings, no problemo creo


#devuelve dataframe del json de drivers
getDrivers <- function(session){
  response <- GET(paste0('https://api.openf1.org/v1/drivers?session_key=',session))
  parsed_data <- fromJSON(content(response, 'text'))
  
  df <- data.frame(parsed_data)
  
  df[which(df["team_name"] == "Kick Sauber"),"team_colour"] <- "520000" #apaño color sauber
  
  return(df)
}


#devuelve dataframe del json de intervals
getIntervals <- function(session){
  response <- GET(paste0('https://api.openf1.org/v1/intervals?session_key=',session))
  parsed_data <- fromJSON(content(response, 'text'))
  
  df <- data.frame(parsed_data)
  
  return(df)
}

mainPlot <- function(drivers_in,limitey){ #el piloto de la vacia no estaría mal que fuera alguien con una carrera normal
  plot(x[which(dfIntervals$driver_number==14)],dfIntervals$gap_to_leader[which(dfIntervals$driver_number==14)],type='n',ylim=c(0,limitey))
  for (d in drivers_in){
    n = dfDrivers[which(dfDrivers$full_name==d), "driver_number"]
    lines(x[which(dfIntervals$driver_number==n)],dfIntervals$gap_to_leader[which(dfIntervals$driver_number==n)],type='l',lwd=3.5,col = paste0("#",dfDrivers[which(dfDrivers$driver_number==n),"team_colour"]))
  }
  grid(nx = NULL, ny = NULL,
       lty = 2,      # Grid line type
       col = "gray", # Grid line color
       lwd = 1)      # Grid line width
}


#tomar datos
dfDrivers <- getDrivers(current_session)
dfIntervals <- getIntervals(current_session)


x <- chron(times=str_right(dfIntervals$date,15))



#definir ui-------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Interval"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("limitey", "Integer:",
                  min = 1, max = 100,
                  value = 40),
      checkboxGroupInput("checkbox_drivers","Pilotos:",dfDrivers[ ,"full_name"]),
      actionButton("update","Actualizar gráfico")
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
  
}

#run the app
shinyApp(ui=ui,server=server)
