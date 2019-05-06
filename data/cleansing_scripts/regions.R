library(tidyverse)
library(lubridate)
library(janitor)
library(readxl)
library(here)
library(sf)

# Get geospatial data
eng_wales <- read_sf("https://opendata.arcgis.com/datasets/44667328cf45481ba91aef2f646b5fc0_0.geojson")

ni <- read_sf(here("data/ni/OSNI_Open_Data_Largescale_Boundaries__NI_Outline/OSNI_Open_Data_Largescale_Boundaries__NI_Outline.shp"))

# Get seats per region
seats <- 
  read_csv(here("data/2019_eu_seats_uk.csv"))

# Get candidates
candidates <-
  read_csv(here("data/2019_eu_candidates_uk.csv"))

# Combine geospatial data
uk_ni <-
  rbind(
    eng_wales %>% 
      select(region = eer16nm),
    ni %>% 
      select(geometry) %>% 
      mutate(region = "Northern Ireland")
  ) %>% 
  st_simplify(dTolerance = 0.001) %>% 
  arrange(region) %>% 
  # Make region names the same as the candidate list
  mutate(region = candidates %>% 
           pull(region) %>% 
           unique() %>% 
           sort(),
         region_id = 1:nrow(.)) %>% 
  select(region_id, region) %>% 
  left_join(seats, by = "region")

# Export
uk_ni %>% 
  write_sf(here("data/2019_eu_regions_uk.geojson"))


