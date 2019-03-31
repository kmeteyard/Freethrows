##Scrape the web for more data##
#Source: www.basketball-reference.com

library(tidyverse)
library(rvest)

###Scrape the web for players###
inputs <- letters
#Drop the x
inputs <- inputs[-24]

web_scrape <- function(letter) {
  #scrape the data
  url <- paste0("https://www.basketball-reference.com/players/", letter ,"/")
  fulldata <- url %>%
    read_html() %>%
    html_table() %>%
    .[[1]]
}

output <- lapply(inputs, web_scrape)
output <- bind_rows(output)

head(output)
#More detailed player information
#Could join this to our data set to perform additional analysis. 
#Out of the scope of the current project