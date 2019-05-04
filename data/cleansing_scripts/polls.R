library(tidyverse)
library(httr)
library(here)

polls <-
  GET("https://pollofpolls.eu/get/polls/GB-ep/format/csv") %>% 
  content()

prev_polls <- 
  read_csv(here("data/2019_eu_polls_uk.csv"))

prev_polls %>% 
  bind_rows(polls) %>% 
  distinct() %>% 
  write_csv(here("data/2019_eu_polls_uk.csv"))
