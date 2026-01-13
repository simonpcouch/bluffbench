# Run baseline samples with clarify = TRUE

RESULTS_DIR <- "inst/run/logs/baseline-clarify-true"

withr::local_envvar(VITALS_LOG_DIR = RESULTS_DIR)
devtools::load_all()

baseline_indices <- which(bluff_dataset$type == "baseline")
tsk <- bluff_task(epochs = 3, samples = baseline_indices)

# claude 4.5 sonnet -------------------------------------------------
tsk_claude_4_5_sonnet <- tsk$clone()
tsk_claude_4_5_sonnet$eval(
  solver_chat = ellmer::chat_anthropic(model = "claude-sonnet-4-5-20250929"),
  clarify = TRUE
)

save(
  tsk_claude_4_5_sonnet,
  file = file.path(RESULTS_DIR, "tsk_claude_4_5_sonnet.rda")
)

# gemini 2.5 pro ----------------------------------------------------
tsk_gemini_2_5_pro <- tsk$clone()
tsk_gemini_2_5_pro$eval(
  solver_chat = ellmer::chat_google_gemini(model = "gemini-2.5-pro"),
  clarify = TRUE
)

save(
  tsk_gemini_2_5_pro,
  file = file.path(RESULTS_DIR, "tsk_gemini_2_5_pro.rda")
)

# gpt-5 -------------------------------------------------------------
tsk_gpt_5 <- tsk$clone()
tsk_gpt_5$eval(
  solver_chat = ellmer::chat_openai(model = "gpt-5"),
  clarify = TRUE
)

save(
  tsk_gpt_5,
  file = file.path(RESULTS_DIR, "tsk_gpt_5.rda")
)
