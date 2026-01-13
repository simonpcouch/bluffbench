# Run mocked and intuitive samples with memo prompt

RESULTS_DIR <- "inst/run/logs/memo"

withr::local_envvar(VITALS_LOG_DIR = RESULTS_DIR)
devtools::load_all()

prompt_memo <- paste(
  readLines(system.file("prompts/prompt-memo.md", package = "bluffbench")),
  collapse = "\n"
)

adversarial_indices <- which(bluff_dataset$type %in% c("mocked", "intuitive"))
tsk <- bluff_task(epochs = 3, samples = adversarial_indices)

# claude 4.5 sonnet -------------------------------------------------
tsk_claude_4_5_sonnet <- tsk$clone()
tsk_claude_4_5_sonnet$eval(
  solver_chat = ellmer::chat_anthropic(
    model = "claude-sonnet-4-5-20250929",
    system_prompt = prompt_memo
  )
)

save(
  tsk_claude_4_5_sonnet,
  file = file.path(RESULTS_DIR, "tsk_claude_4_5_sonnet.rda")
)
