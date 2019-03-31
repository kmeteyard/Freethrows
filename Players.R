#Build a shiny app for player information#
#Use DT for interactive table
#Use plotly for interactive graphs

library(tidyverse)
library(plotly)
library(shiny)
library(DT)
library(nbafreethrows)

###Players from our data set###
freethrows <- nbafreethrows::nbafreethrows

#Reshape data for players#
players <- freethrows %>%
  group_by(player) %>%
  summarise(throws = n(), made = sum(shot_made), missed = (throws - made), percentage = sum(shot_made)/n())
players$player <- as.character(players$player)
###Reshape data for player seasons
playerseason <- freethrows %>%
  group_by(player, season) %>%
  summarise(throws = n(), made = sum(shot_made), missed = (throws - made), percentage = sum(shot_made)/n())
###

ui <- fluidPage(
  headerPanel("An interactive table of NBA players' free throw statistics"),
  mainPanel(
    DT::dataTableOutput("players"),
    h2("Click a player to see their shooting percentage by season"),
    plotlyOutput("plot"), width = 12
  )
)

server <- function(input, output, session){

  output$players <- renderDT({
    datatable(players, rownames = FALSE, selection = 'single', filter = 'top') %>%
      formatRound('percentage', 3)
  })

  output$plot <- renderPlotly({
    #s <- event_data("plotly_click", source = "players")
    s <- input$players_rows_selected
    if (length(s)) {
        a <- players[[s,1]]
        p <- playerseason %>%
        filter(player == a[[1]]) %>%
        ggplot(aes(season, percentage, group = 1)) + geom_point() + geom_path() 
     ggplotly(p)
       } 
    else {
      plotly_empty(type = "scatter")
    }
  })

}
shinyApp(ui, server)
