library(tidyverse)
library(lubridate)
library(readxl)
library(janitor)
library(scales)
library(here)

source(here("R/allocate_dhondt.R"))

candidates <- read_csv(here("data/2019_eu_candidates_uk.csv"))

max_seats <-
  candidates %>% 
  filter(region == "North West") %>% 
  count(on_the_ballot) %>% 
  arrange(on_the_ballot) %>% 
  {set_names(.$n, .$on_the_ballot)}

seats <- 8

set.seed(1)
votes <- replace(max_seats, TRUE, rnorm(8, 10000, 1000))

allocate_dhondt(votes, max_seats, seats)
