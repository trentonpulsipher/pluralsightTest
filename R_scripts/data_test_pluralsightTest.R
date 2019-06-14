

# checked to make sure SQLite is loaded on my mac
# downloaded TablePlus application to work with SQLite

library(DBI)
library(RSQLite)
library(tidyverse)
library(lubridate)

# connect the database created by running .sql file in TablePlus
con <- DBI::dbConnect(RSQLite::SQLite(), "pluralsightTestDB.sqlite3")

# read in data from the four database tables
question_details <- DBI::dbReadTable(con, "question_details") %>% 
  as_tibble()

question_interactions <- DBI::dbReadTable(con, "question_interactions") %>% 
  as_tibble() %>%
  mutate(date_created = ymd_hms(date_created))

user_assessment_sessions <- DBI::dbReadTable(con, "user_assessment_sessions") %>% 
  as_tibble() %>%
  mutate(date_created = ymd_hms(date_created))

user_interactions <- DBI::dbReadTable(con, "user_interactions") %>% 
  as_tibble() %>%
  mutate(date_created = ymd_hms(date_created))



