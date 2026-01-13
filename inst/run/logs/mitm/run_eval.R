# Run mocked and intuitive samples with model-in-the-middle

RESULTS_DIR <- "inst/run/logs/mitm"

withr::local_envvar(VITALS_LOG_DIR = RESULTS_DIR)
devtools::load_all()

adversarial_indices <- which(bluff_dataset$type %in% c("mocked", "intuitive"))
tsk <- bluff_task(epochs = 3, samples = adversarial_indices)

# claude 4.5 sonnet -------------------------------------------------
tsk_claude_4_5_sonnet <- tsk$clone()
tsk_claude_4_5_sonnet$eval(
  solver_chat = ellmer::chat_anthropic(model = "claude-sonnet-4-5-20250929"),
  model_in_the_middle = TRUE
)

save(
  tsk_claude_4_5_sonnet,
  file = file.path(RESULTS_DIR, "tsk_claude_4_5_sonnet.rda")
)
