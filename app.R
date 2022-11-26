
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
  dashboardSidebar(collapsed = TRUE,uiOutput("sidebar")),
  dashboardBody(tabsetPanel(id = "tab_selected",
    tabPanel(title = "Global",
             leafletOutput("leaf_global_map"),
             splitLayout(cellWidths = c("50%", "50%"),
                         plotOutput("total_fuel_plot_"),
                         plotOutput("top_15"))
              ), 
    tabPanel(title = "Country" ,
             leafletOutput("leaf_country_map"),
             splitLayout(cellWidths = c("50%","50%"),
                         plotOutput("total_fuel_plot"),
                         plotOutput("fuel_country_plot"))
             )))
)




server <- function(input, output) {
  


    
# render ----
  
# Global    
output$leaf_global_map <- 
  renderLeaflet({leaf_global(fuel_name = input$fuel_types,level = input$levels)})

output$total_fuel_plot_ <-  renderPlot({total_fuel_plot()})

output$top_15 <- renderPlot({top_15_plot(input$fuel_types)})

# Country

output$leaf_country_map <- 
  renderLeaflet({leaf_country(country_name = input$country_names, input$fuel_type_picker)})

output$fuel_country_plot <- 
  renderPlot({country_fuel_plot(fuel_type = input$fuel_type_picker, 
                                country_name = input$country_names )}) 

output$total_fuel_plot <- renderPlot(total_fuel_plot(country_names = input$country_names)) 


# sidebar

# Global
output$fuel_types <- renderUI({
  selectInput(inputId = "fuel_types",
               label = "Select Fuel Type",
               choices = unique_primary_fuel,
               selected = "Coal", 
               multiple = FALSE)})
  
  output$levels <- renderUI({
      pickerInput(inputId = "levels",
                  label = "Power Plant Capacity",
                  choices = unique_levels,
                  selected = unique_levels,
                  multiple = TRUE,
                  options = list(`actions-box` = TRUE)
                  )})
  
# Country
  
  output$country_names <-  renderUI({
    selectInput(inputId = "country_names",
                        label = "Select Country Names",
                        choices = unique_country_names,
                        selected = "Turkey", 
                        multiple = FALSE)})
  
  
  output$fuel_type_picker <- renderUI({
    pickerInput(inputId = "fuel_type_picker",
                label = "Select Fuel Type", 
                choices = unique_primary_fuel,
                selected = c("Coal", "Gas", "Hydro"), 
                multiple = TRUE,options = list(`actions-box` = TRUE))})
  


output$sidebar <- renderUI({
  if(input$tab_selected == "Global") {
    div(uiOutput("fuel_types"),
        uiOutput("levels"))
  } else if(input$tab_selected == "Country"){
    div(uiOutput("country_names"),
        uiOutput("fuel_type_picker"))
    
  }
  
})

}

# Run ----
shinyApp(ui = ui, server = server)
