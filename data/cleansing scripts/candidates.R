library(tidyverse)
library(rvest)
library(here)

# Indy website with full list of candidates on it
ind_url <- "https://inews-co-uk.cdn.ampproject.org/v/s/inews.co.uk/news/politics/european-elections-2019-candidates-mep-who-standing-eu-vote-full-list/amp/?usqp=mq331AQCCAE%3D&amp_js_v=0.1#aoh=15563404579313&amp_ct=1556340675013&referrer=https%3A%2F%2Fwww.google.com&amp_tf=From%20%251%24s&ampshare=https%3A%2F%2Finews.co.uk%2Fnews%2Fpolitics%2Feuropean-elections-2019-candidates-mep-who-standing-eu-vote-full-list%2F"

# Read the HTML
pull_site <- read_html(ind_url)

# Get the nodes which will be useful
useful_nodes <-
  pull_site %>% 
  # h2 is region, strong is party, ol and ul are candidates
  html_nodes("h2, p > strong, ol, ul") %>%
  # all the nodes we need have no class
  keep(~is.na(html_attr(., "class")))

# Create a tidy table
df <-
  tibble(tag = useful_nodes %>%  # indicative of variable
           html_name(),
         text = useful_nodes %>%  # the actual information
           html_text()) %>% 
  mutate(region = ifelse(tag == "h2", text, NA),
         party = ifelse(tag == "strong", text, NA),
         candidate = ifelse(tag %in% c("ol", "ul"), text, NA)) %>% 
  fill(region, party) %>%  # fill down
  filter(!is.na(candidate)) %>%  # all candidates now have party/region info
  select(-tag, -text) %>%  # no longer needed
  mutate_all(str_trim) %>%  # bye bye whitespace
  separate_rows(candidate, sep = "\n") %>%  # 1 row per candidate
  mutate(withdrawn = str_detect(candidate, "(withdrawn)"),  # highlight withdrawn candidates
         candidate = str_remove(candidate, " ?\\(withdrawn\\)")) %>%
  group_by(region, party) %>% 
  mutate(order = 1:n()) %>%  # add the order
  ungroup() %>% 
  mutate(party = fct_collapse(party, Conservative = c("Conservative", "Conservatives")),
         region = fct_infreq(region, ordered = TRUE))

# Add some notable candidates
query <- paste(
  "Tommy Robinson",
  "Nigel Farage",
  "Carl Benjamin", 
  "Rees-Mogg",
  "Widdecombe",
  "Magid",
  "Adonis",
  "Rachel Johnson",
  "Daniel Hannan",
  "Gerard Batten",
  sep = "|"
  )

df <-
  df %>% 
  mutate(notable = str_detect(candidate, query)) 

# Export the thing

df %>% 
  write_csv(here("data/2019_eu_candidates_uk.csv"))
