library(tidyverse)

bluff_results_raw <- process_results()

bluff_results <-
  bluff_results_raw %>%
  mutate(
    type = purrr::map_chr(metadata, ~ .x$type),
    type = ifelse(type != "intuitive" | is.na(type), "mocked", "intuitive")
  ) %>%
  rename(model = task) %>%
  select(-metadata) %>%
  mutate(
    model = case_when(
      model == "claude_4_5_sonnet" ~ "Claude Sonnet 4.5",
      model == "gemini_2_5_pro" ~ "Gemini Pro 2.5",
      model == "gpt_5" ~ "GPT-5"
    )
  )

usethis::use_data(bluff_results, overwrite = TRUE)
