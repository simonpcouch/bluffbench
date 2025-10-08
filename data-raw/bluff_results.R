library(tidyverse)

bluff_results_raw <- process_results()

bluff_results <-
  bluff_results_raw %>%
  rename(model = task) %>%
  select(-metadata)

usethis::use_data(bluff_results, overwrite = TRUE)
