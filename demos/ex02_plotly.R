library(tidyverse)
library(shiny)

d <- readr::read_csv(here::here("data/weather.csv"))

ui <- fluidPage(
  titlePanel("Temperatures at Major Airports"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "name", "Select an airport",
        choices = c(
          "Seattle-Tacoma",
          "Raleigh-Durham",
          "Houston Intercontinental",
          "Denver",
          "Los Angeles",
          "John F. Kennedy"
        ),
        selected = "Seattle-Tacoma",
        multiple = TRUE
      ) 
    ),
    mainPanel( 
      plotlyOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  output$plot = renderPlotly({
    p <- d |>
      filter(name %in% input$name) |>
      ggplot(aes(x=date, y=temp_avg, color=name)) +
      geom_line() +
      theme_minimal() +
      labs(color = "") +
      theme(legend.position='bottom')
    plotly::ggplotly(p)
  })
}

shinyApp(ui = ui, server = server)
