library(shiny)
library(httr)
library(jsonlite)

current_year = format(Sys.Date(), "%Y") #año actual


#Obtiene la tabla con la información de meeting del año year
#saca los resultados en el orden que le da la real gana, pero rula bien
getJsonTable <- function(year){
  response <- GET(paste0('https://api.openf1.org/v1/meetings?year=',year))
  parsed_data <- fromJSON(content(response, 'text'))
  #borrar columnas que sobran
  parsed_data["meeting_official_name"] = NULL
  parsed_data["country_code"] = NULL
  parsed_data["circuit_short_name"] = NULL
  parsed_data["year"] = NULL
  
  if(year == current_year){ #borra el latest, saldría duplicado
                            #tal vez buscar año del latest? más fino
    parsed_data <- parsed_data[-nrow(parsed_data), ]
  }

  
  return(parsed_data)
}

#definir ui
ui <- fluidPage(
  titlePanel("Meetings"),
  
  sidebarLayout(
    sidebarPanel(
      helpText(paste("Escribe el año que quieras buscar entre 1950 y ",current_year,
                     "SE VE QUE LA API TIENE DATOS DESDE 2023 SOLAMENTE, va a mejorar dice")),
      numericInput("year_in", label="Year",value=2023,min=1950, max=current_year),
      submitButton("Search")
    ),
    
    mainPanel(
      textOutput("year_text_output"),
      tableOutput("table_out"),
      
      textOutput("json_out")
    )
  )
  
)

#server logic
server <- function(input,output){
  
  output$year_text_output <- renderText({
    paste("Tu año seleccionado: ", input$year_in)
  })
  
  
  
  output$table_out <- renderTable({
    getJsonTable(input$year_in)
    
  }, rownames = TRUE, hover = TRUE)
  
}

#run the app
shinyApp(ui=ui,server=server)
