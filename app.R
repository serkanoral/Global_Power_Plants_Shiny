
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(tidyverse)
library(leaflet)

# data source ----
source(file = "data.R")
source(file = "plots.R")



ui <- dashboardPage(
  dashboardHeader(title = "Power Plants"),
  dashboardSidebar(collapsed = TRUE),
  dashboardBody(tabsetPanel(id = "tab_selected",
    tabPanel(title = "Global",selectInput(inputId = "fuel_types",
                                          label = "Select Fuel Type",
                                          choices = unique_primary_fuel,
                                          selected = "Coal", 
                                          multiple = FALSE),
             leafletOutput("leaf_global_map"),
             splitLayout(cellWidths = c("50%", "50%"),
                         plotOutput("total_fuel_plot_"),
                         plotOutput("top_15"))
              ), 
    tabPanel(title = "Country",
             selectInput(inputId = "country_names",
                                            label = "Select Country Names",
                                            choices = unique_country_names,
                                            selected = "Turkey", 
                                            multiple = FALSE),
                         pickerInput(inputId = "fuel_type_picker",
                                     label = "Select Fuel Type", 
                                     choices = unique_primary_fuel,
                                     selected = c("Fuel", "Gas", "Hydro"), 
                                     multiple = TRUE,options = list(`actions-box` = TRUE)) ,
             leafletOutput("leaf_country_map"),
             plotOutput("fuel_country_plot"))))
)




server <- function(input, output) {
  
# functions - plots ----
  

    
# render ----
    
output$leaf_global_map <- renderLeaflet({leaf_global(input$fuel_types)})

output$total_fuel_plot_ <-  renderPlot({total_fuel_plot()})

output$top_15 <- renderPlot({top_15_plot(input$fuel_types)})
 
output$leaf_country_map <- 
  renderLeaflet({leaf_country(country_name = input$country_names, input$fuel_type_picker)})

output$fuel_country_plot <- 
  renderPlot({country_fuel_plot(fuel_type = input$fuel_type_picker, 
                                country_name = input$country_names )})    

}

# Run ----
shinyApp(ui = ui, server = server)
