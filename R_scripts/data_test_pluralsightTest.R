

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
  as_tibble() %>%
  mutate(date_created = as.POSIXct(as.numeric(date_created), origin = '1970-01-01', tz = "GMT"))

question_interactions <- DBI::dbReadTable(con, "question_interactions") %>% 
  as_tibble() %>%
  mutate(date_created = ymd_hms(date_created))

user_assessment_sessions <- DBI::dbReadTable(con, "user_assessment_sessions") %>% 
  as_tibble() %>%
  mutate(
    date_created = ymd_hms(date_created),
    date_modified = ymd_hms(date_modified)
  )

user_interactions <- DBI::dbReadTable(con, "user_interactions") %>% 
  as_tibble() %>%
  mutate(date_created = ymd_hms(date_created))

## Join the data together
d <- user_assessment_sessions %>%
  left_join(user_interactions, by = "user_assessment_session_id") %>%
  rename(
    ranking_overall = ranking.x,
    rd_overall = rd.x,
    display_score_overall = display_score.x,
    percentile_overall = percentile.x,
    date_created_overall = date_created.x,
    ranking_interaction = ranking.y,
    rd_interaction = rd.y,
    display_score_interaction = display_score.y,
    percentile_interaction = percentile.y,
    date_created_interation = date_created.y
  ) %>%
  left_join(question_interactions %>%
              left_join(question_details, by = "item_content_id") %>%
              rename(
                date_created = date_created.x,
                date_created_question_details = date_created.y
              )
            , by = c("user_assessment_session_id", "user_interaction_id", "assessment_item_id", "assessment_id"))

d %>% 
  filter(
    assessment_id == 31584,
    user_id == 2512356
  )
