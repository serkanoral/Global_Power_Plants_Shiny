
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
  dashboardSidebar(disable = TRUE),
  dashboardBody(tabsetPanel(id = "tab_selected",
    tabPanel(title = "Global",leafletOutput("leaf_global_map"),
             plotOutput("total_fuel_plot_")), tabPanel(title = "Country")))
)



server <- function(input, output) {
  
# functions - plots ----
  

    
# render ----
    
output$leaf_global_map <- renderLeaflet({leaf_global()})
    
output$total_fuel_plot_ <-  renderPlot({total_fuel_plot()})

    
}

# Run ----
shinyApp(ui = ui, server = server)
