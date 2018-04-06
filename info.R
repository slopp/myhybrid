info_text <- function(){
  div(
    div(style = "color: orange; font-size:2em; font-family: 'Roboto', sans-serif",
        HTML('<i class="fa fa-exclamation-triangle"> This is a Demo! </i>')
    ),
    
    hr(),
    h2('About the Simulation'),
    p("The vehicle data and MPG simulation come from the National Renewable Energy Lab's validated ", 
      a(href='https://www.nrel.gov/docs/fy15osti/63623.pdf', 'FASTSim'),
      " tool. The trip speed data, used as an input to the FASTSim simulation, is determined from Google Map Directions.
      The simulation results are NOT validated and are only estimates."),
    br(),
    h2('About the App'),
    p("This application demonstrates the use of RStudio's ", a(href='https://rstudio.github.io/reticulate/', 'reticulate '), 
      "and ", a(href='https://shiny.rstudio.com', 'shiny '), "packages. The reticulate package provides interoperability between Python and R. 
      This Shiny application incorporates a Python simulation model and the Python googlemaps API client. The results and visualizations 
      are written in R. For more information see ", a(href='https://github.com/slopp/myhybrid', "the GitHub repo.")),
    hr(),
    h2('Disclaimer'),
    p("This application was developed independently by RStudio as a DEMO using the freely available FASTSim model. 
      The app was not written in conjunction with the National Renewable Energy Lab (NREL) nor is the application
      endorsed by NREL. The results presented in the application are
      not to be used for accurate vehicle comparisons. RStudio is NOT RESPONSIBLE for the accuracy or reliability
      of any results presented in this application.")
  )
}