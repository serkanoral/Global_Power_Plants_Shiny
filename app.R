
library(shiny)
library(shinydashboard)

library(shinyWidgets)
library(tidyverse)
library(leaflet)
library(shinydashboardPlus)
library(rsconnect)
library(terra)

# data source ----
source(file = "data.R")
source(file = "plots.R")




ui <- dashboardPage(skin = "midnight",
  dashboardHeader(title = "Power Plants"),
  dashboardSidebar(collapsed = FALSE, uiOutput("sidebar")),
  dashboardBody( tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "main.css")),
    tabsetPanel(id = "tab_selected",
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

  leaf_global_<-  reactive({
    req(input$fuel_types)
    req(input$levels)
    leaf_global(fuel_name = input$fuel_types,level = input$levels)})

output$leaf_global_map <- 
  renderLeaflet({leaf_global_()})



output$total_fuel_plot_ <-  renderPlot({total_fuel_plot()})


top_15_plot_ <- reactive({
  req(input$fuel_types)
  top_15_plot(input$fuel_types)
})

output$top_15 <- renderPlot({top_15_plot_()})

# Country
leaf_country_ <- reactive({
  req(input$country_names)
  req(input$fuel_type_picker)
  leaf_country(country_name = input$country_names, input$fuel_type_picker)
})

output$leaf_country_map <- 
  renderLeaflet({leaf_country_()})

country_fuel_plot_ <- reactive({
  req(input$fuel_type_picker)
  req(input$country_names)
  country_fuel_plot(fuel_type = input$fuel_type_picker, 
                    country_name = input$country_names )
})

output$fuel_country_plot <- 
  renderPlot({country_fuel_plot_()}) 

total_fuel_plot_ <- reactive({
  req(input$country_names)
  total_fuel_plot(country_names = input$country_names)
})

output$total_fuel_plot <- renderPlot(total_fuel_plot_()) 


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
  
  country_fuel_select_ <- reactive({
    req(input$country_names)
    country_fuel_select(country_name = input$country_names)
  })
  
  output$fuel_type_picker <- renderUI({
    pickerInput(inputId = "fuel_type_picker",
                label = "Select Fuel Type", 
                choices = country_fuel_select_(),
                selected = country_fuel_select_(), 
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
