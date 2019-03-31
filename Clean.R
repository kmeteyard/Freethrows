##Clean and check the data##

#Load in packages
library(tidyverse)

#Load in data
freethrows <- read.csv("free_throws.csv", header=TRUE)

#Let's do a few simple checks to ensure the data is consistent

head(freethrows)

#Any missing data?
anyNA(freethrows)
#No

#Any duplicates?
sum(duplicated(freethrows))
#Which?
freethrows[anyDuplicated(freethrows),]
#Two technical fouls seems feasible.

#Number of players
players <- levels(freethrows$player)
length(players)

#Let's check the names to ensure no similarities
players[duplicated(str_replace_all(players, "[[:punct:][:blank:]]+", ""))]

#Need to fix 3 players
freethrows$player <- recode(freethrows$player, `Amare Stoudemire` = "Amar'e Stoudemire", `DJ Mbenga` = "D.J. Mbenga", `J.J. Hickson` = "JJ Hickson")
#Total of 1095 players

#Is end result consistent for each game_id - Yes
n_distinct(freethrows$game_id)
summarise(freethrows, n_distinct(freethrows$game_id))
#Scores consistent amoungst each  
freethrows %>%
  group_by(game_id) %>%
  summarise(score = n_distinct(end_result)) %>%
  summarise(n())

#Check the makes/misses are consistent with the scores
plays <- freethrows %>%
  mutate(makes = str_detect(freethrows$play, "makes"), misses = str_detect(freethrows$play, "misses"), both = makes + misses)

which(plays$both == 2)
#One incorrect play

freethrows$shot_made[which(plays$both == 2)] <- 0
#Change to miss

#Save clean file
save(freethrows, file = "cleanfreethrows.RData")
