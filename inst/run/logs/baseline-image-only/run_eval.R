# Run baseline samples with image_only = TRUE

RESULTS_DIR <- "inst/run/logs/baseline-image-only"

withr::local_envvar(VITALS_LOG_DIR = RESULTS_DIR)
devtools::load_all()

baseline_indices <- which(bluff_dataset$type == "baseline")
tsk <- bluff_task(epochs = 3, samples = baseline_indices)

# claude 4.5 opus ---------------------------------------------------
tsk_claude_4_5_opus <- tsk$clone()
tsk_claude_4_5_opus$eval(
  solver_chat = ellmer::chat_anthropic(model = "claude-opus-4-5-20251101"),
  image_only = TRUE
)

save(
  tsk_claude_4_5_opus,
  file = file.path(RESULTS_DIR, "tsk_claude_4_5_opus.rda")
)

# gemini 2.5 pro ----------------------------------------------------
tsk_gemini_2_5_pro <- tsk$clone()
tsk_gemini_2_5_pro$eval(
  solver_chat = ellmer::chat_google_gemini(model = "gemini-2.5-pro"),
  image_only = TRUE
)

save(
  tsk_gemini_2_5_pro,
  file = file.path(RESULTS_DIR, "tsk_gemini_2_5_pro.rda")
)

# gpt-5.2 -----------------------------------------------------------
tsk_gpt_5_2 <- tsk$clone()
tsk_gpt_5_2$eval(
  solver_chat = ellmer::chat_openai(model = "gpt-5.2"),
  image_only = TRUE
)

save(
  tsk_gpt_5_2,
  file = file.path(RESULTS_DIR, "tsk_gpt_5_2.rda")
)
