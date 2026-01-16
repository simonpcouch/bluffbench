# Run mocked and intuitive samples with model-in-the-middle

RESULTS_DIR <- "inst/run/logs/mitm"

withr::local_envvar(VITALS_LOG_DIR = RESULTS_DIR)
devtools::load_all()

adversarial_indices <- which(bluff_dataset$type %in% c("mocked", "intuitive"))
tsk <- bluff_task(epochs = 3, samples = adversarial_indices)

# claude 4.5 opus ---------------------------------------------------
tsk_claude_4_5_opus <- tsk$clone()
tsk_claude_4_5_opus$eval(
  solver_chat = ellmer::chat_anthropic(model = "claude-opus-4-5-20251101"),
  model_in_the_middle = TRUE
)

save(
  tsk_claude_4_5_opus,
  file = file.path(RESULTS_DIR, "tsk_claude_4_5_opus.rda")
)
