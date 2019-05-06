library(tidyverse)
library(lubridate)
library(janitor)
library(readxl)
library(here)
library(sf)

# Candidate data
candidates <- read_csv(here("data/2019_eu_candidates_uk.csv"))

# Number of seats per region
seats <- read_csv(here("data/2019_eu_seats_uk.csv")) %>% 
  {set_names(.$seats, .$region)}

election <- function(.candidate_df, .seats, n = 2) {
  
  nested <- .candidate_df %>% 
    mutate(elected = FALSE) %>% 
    group_by(region_id, region) %>% 
    nest() %>% 
    mutate(seats = .seats[region])
  
  return(nested)
}

test <-
  election(candidates, seats)



test$data
constituency <- function(.df, .region = "North West") {
  tbl <-
    .df %>% 
    filter(region == .region)
  
  parties <-
    tbl %>% 
    pull(on_the_ballot) %>% 
    unique() %>% 
    sort()
  
  votes <- 
    runif(length(parties), 0, 100) %>% 
    {. / sum(.)} %>% 
    set_names(parties) %>% 
    sort(decreasing = TRUE)
  
  return(names(votes[1]))
  
}
