reticulate::use_condaenv('myhybrid')

library(reticulate)
library(purrr)
library(tibble)
library(tidyr)
library(TTR)
library(shiny)
library(ggplot2)
library(ggthemes)
library(stringr)
library(shinymaterial)
library(flexdashboard)
library(dplyr)

source('get_route.R')
source('simulate.R')
source('create_cycle.R')
source('info.R')

# Data for UI Inputs
vehicles <- vehicle_list()
hybrids <- vehicles %>% 
  filter(type > 1) %>% 
  pull(name)
conv <- vehicles %>% 
  filter(type == 1) %>% 
  pull(name)


# Dashboard Layout
ui <- material_page(
  title = 'MyHybrid',
  nav_bar_color = 'teal',
  tags$br(),
  material_row(
    # Inputs
    material_column(
      width = 3,
      material_card(
        title = "Select Route",
        material_text_box(
          "end",
          "From",
        ),
        material_text_box(
          "start",
          "To",
        )
      ),
      material_card(
        title = "Driving Style",
        material_slider(
          'smooth',
          'Aggressive to Cautious',
          3, 10, 4
        )
      ),
      material_card(
        title = "Vehicles to Compare",
        material_dropdown(
          input_id = "conv",
          label = "Select Baseline",
          choices = conv
        ),
        material_dropdown(
          input_id = "hybrid",
          label = "Select Hybrid",
          choices = hybrids
        )
      ),
      material_modal('info',
        'About',
        info_text(),
        button_icon = 'info'
      )
    ),
    
    # Map and Cycle
    material_column(
      width = 4,
      material_card(
        htmlOutput('map')
      ),
      material_card(
        title = "Simulated Trip Speed",
        plotOutput('cycle')
      )
    ),
    
    # Results and Gas
    material_column(
      width = 4,
      material_row(
        material_column(
          width = 6,
          material_card(
            title = "Baseline",
            icon('car'),
            htmlOutput('baseline')
          )
        ),
        material_column(
          width = 6,
          material_card(
            title = 'Hybrid',
            icon('battery'),
            htmlOutput('hybrid')
          ) 
        )
      ),
      material_card(
        title  = "Gas Consumption",
        plotOutput('gas')
      )
    )
  )
)

# Dashboard Logic
server <- function(input, output, session) {

  start_db <- debounce(
    reactive({input$start}), 2000
  )
  
  end_db <- debounce(
    reactive({input$end}), 2000
  )
  
  route <- reactive({
    req(start_db())
    req(end_db())
    material_spinner_show(session, 'map')
    material_spinner_show(session, 'cycle')
    route <- get_route(start_db(), end_db())
    route
  })
  
  cycle <- reactive({
    create_cycle(route(), input$smooth)
  })
  
  output$cycle <- renderPlot({
    plot_cycle(cycle())
  })
  
  sim_results <- reactive({
    req(cycle())
    material_spinner_show(session, 'gas')
    result <- simulate_vehicles(cycle(),
                      map_name_id(input$conv),
                      map_name_id(input$hybrid))
    material_spinner_hide(session, 'gas')
    material_spinner_hide(session, 'map')
    material_spinner_hide(session, 'cycle')
    result
  })
  
  output$gas <- renderPlot({
    plot_gas(sim_results())
  })
  
  output$map <- renderText({
    req(start_db())
    req(end_db())
    key <- Sys.getenv('EMBED_MAP_API')
    start <- URLencode(start_db())
    end <- URLencode(end_db())
    sprintf('<iframe 
      height = "400px"
      width = "100%%"
      frameborder = "0" style="border:0"
      src="https://www.google.com/maps/embed/v1/directions?key=%s&origin=%s&destination=%s"
      allowfullscreen>
     </iframe>', key, start, end)
  })
  
  output$baseline <- renderText({
    req(sim_results())
    sprintf('
      <h3> %d </h3>
      <p> Sticker MPG </p>
      %s
      <h3> %d </h3>
      <p> Simulated Trip MPG </p>
    ', 
            sim_results()[[1]]$sticker_mpg,
            hr(),
            round(sim_results()[[1]]$mpgge))
  })
  
  output$hybrid <- renderText({
    req(sim_results())
    sprintf('
      <h3> %d </h3>
      <p> Sticker MPG </p>
      %s
      <h3> %d </h3>
      <p> Simulated Trip MPG </p>
    ', 
            sim_results()[[2]]$sticker_mpg,
            hr(),
            round(sim_results()[[2]]$mpgge))
  })

}

shinyApp(ui, server)