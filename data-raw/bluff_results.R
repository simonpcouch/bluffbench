library(tidyverse)

bluff_results_raw <- process_results()

bluff_results <-
  bluff_results_raw %>%
  mutate(type = purrr::map_chr(metadata, ~ .x$type)) %>%
  rename(model = task) %>%
  select(-metadata) %>%
  mutate(
    model = case_when(
      model == "claude_4_6_opus" ~ "Claude Opus 4.6",
      model == "gemini_3_pro" ~ "Gemini 3 Pro",
      model == "gpt_5_2" ~ "GPT-5.2"
    )
  )

usethis::use_data(bluff_results, overwrite = TRUE)
