library(tidyverse)
library(lubridate)
library(janitor)
library(readxl)
library(here)
library(sf)
library(tictoc)

source(here("R/allocate_dhondt.R"))

# Candidate data
candidates <- read_csv(here("data/2019_eu_candidates_uk.csv"))

# Seats
sts <- 
  read_csv(here("data/2019_eu_seats_uk.csv")) %>% 
  {setNames(.$seats, .$region)}

# Spoof Vote Distributions
set.seed(10)

vts <-
  candidates %>% 
  filter(!withdrawn) %>% 
  split(.$region) %>% 
  lapply(function(region) {
    
    parties <- sort(unique(region$on_the_ballot))
    
    votes <- runif(length(parties), 1000, 100000)
    
    setNames(votes/sum(votes), parties)
  })

# Function

elect <- function(candidate_df = candidates,
                  vote_dist,
                  seats_by_region) {
  
  regions <- names(vote_dist)
  
  election <-
    lapply(regions, function(reg) {
      # Filter: only non-withdrawn candidates from the region
      cand_df <- candidate_df[candidate_df$region == reg & !candidate_df$withdrawn,]
      
      # Reorder: "Party" then "Order" - for later subsetting
      cand_df <- cand_df[order(cand_df$on_the_ballot, cand_df$order), ]
      
      # Number of candidates running for each Party
      max_seats <- table(cand_df$on_the_ballot)
      
      # Allocate seats to Parties by D'Hondt methods
      allocate_seats <- allocate_dhondt(vote_dist[[reg]], max_seats, seats_by_region[[reg]])
      
      # Pick winning candidates from df
      who_won <-
        mapply(function(num, party) {
          cand_df[cand_df$on_the_ballot == party,][1:num, ]
        }, allocate_seats, names(allocate_seats), SIMPLIFY = FALSE)
      
      who_won <- do.call(rbind, who_won)
      
      return(who_won)
    })
  
  names(election) = regions
  
  do.call(rbind, election)
}

# Regular example
elect(candidates, vts, sts)

# Timing for 1000 iterations
tic()

test <-
  lapply(1:1000, function(x) vts) %>% 
  lapply(function(votes){
    elect(candidates, votes, sts)
  })

toc()