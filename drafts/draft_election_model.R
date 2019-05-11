library(tidyverse)
library(lubridate)
library(janitor)
library(readxl)
library(here)
library(sf)

source(here("R/allocate_dhondt.R"))

# Candidate data
candidates <- read_csv(here("data/2019_eu_candidates_uk.csv"))

# Polls data
source(here("data/cleansing_scripts/polls.R"))



elect <- function(candidate_df = candidates) {
  
  candidate_df <- candidate_df[!candidate_df$withdrawn,]
  
  # Randomly allocate votes to ballot options
  .votes <- sapply(split(candidate_df$on_the_ballot, candidate_df$region), function(parties){
    unique_parties <- unique(parties)
    
    setNames(runif(length(unique_parties), 1000, 200000), unique_parties)
  })
  
  .max_seats <- sapply(split(candidates$on_the_ballot, candidates$region), table)
  
  return({
    list(.votes, .max_seats)
  })
  
}

elect()

