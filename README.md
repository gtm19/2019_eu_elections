# 2019 EU Elections in the United Kingdom
## Getting, cleansing, and analysing the data for the elections which weren't supposed to be happening (but here we are)

Realising that I knew literally nothing about how the European Parliament elections work, and in spite of the fact that it will soon be utterly useless information for me, here is my attempt to obtain, tidy, and analyse whatever data I can get my hands on in relation to the elections taking place in May 2019.

Once I have the data (if I have time) the idea is to model the potential outcomes of the elections.

### The Data

#### Candidates

After a lot of Googling, there doesn't seem to be a centrally held list of candidates for the elections, either on the Electoral Commission website, or on any EU elections website.

Fortunately, several journalists had taken the time to list the candidates on their websites. I used [this article](https://inews-co-uk.cdn.ampproject.org/v/s/inews.co.uk/news/politics/european-elections-2019-candidates-mep-who-standing-eu-vote-full-list/amp/?usqp=mq331AQCCAE%3D&amp_js_v=0.1#aoh=15563404579313&amp_ct=1556340675013&referrer=https%3A%2F%2Fwww.google.com&amp_tf=From%20%251%24s&ampshare=https%3A%2F%2Finews.co.uk%2Fnews%2Fpolitics%2Feuropean-elections-2019-candidates-mep-who-standing-eu-vote-full-list%2F) from The Independent, a bit of extraction using [`rvest`](https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/), and some tidying with the [`tidyverse`](https://www.tidyverse.org/), to produce a [clean list of candidates](data/2019_eu_candidates_uk.csv), including their region, party, and order (which becomes important when the votes are in and seats are being allocated). I also added indicators of whether the candidate has been withdrawn, and another "notable" column for a few big names who the press will no doubt be keeping a keen eye on.

The R script I used to produce this `.csv` file can be found [here](data/cleansing_scripts/candidates.R).
