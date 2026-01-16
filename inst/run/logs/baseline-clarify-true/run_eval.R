# Run baseline samples with clarify = TRUE (now the default)
# Only runs Gemini 2.5 because other models baselines are included in bluff_results

RESULTS_DIR <- "inst/run/logs/baseline-clarify-true"

withr::local_envvar(VITALS_LOG_DIR = RESULTS_DIR)
devtools::load_all()

baseline_indices <- which(bluff_dataset$type == "baseline")
tsk <- bluff_task(epochs = 3, samples = baseline_indices)

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
