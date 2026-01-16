# Run mocked and intuitive samples with memo prompt

RESULTS_DIR <- "inst/run/logs/thinking"

withr::local_envvar(VITALS_LOG_DIR = RESULTS_DIR)
devtools::load_all()

prompt_thinking <-
  "Your primary job is to accurately interpret visualizations. This requires careful analytical thinking.

  When evaluating a visualization, first analyze the plot as if you had no prior knowledge about the data and subject matter.
  Ignore the axis labels during this process, only describing the visual elements of the plot. Think carefully about what
  patterns, trends, and relationships you actually observe. Emit in <MEMO></MEMO> tags what you see during this process.

  Afterwards, you may incorporate knowledge about the data or contextual knowledge, but make sure to accurately report and
  incorporate what you noted in the prior <MEMO></MEMO> tags, even if it contradicts your prior or contextual knowledge. 
  Reason through any discrepancies between visual evidence and expectations."

adversarial_indices <- which(bluff_dataset$type %in% c("mocked", "intuitive"))
tsk <- bluff_task(epochs = 3, samples = adversarial_indices)

# claude 4.5 opus ---------------------------------------------------
tsk_claude_4_5_opus <- tsk$clone()
tsk_claude_4_5_opus$eval(
  solver_chat = ellmer::chat_anthropic(
    model = "claude-opus-4-5-20251101",
    system_prompt = prompt_thinking
  )
)

save(
  tsk_claude_4_5_opus,
  file = file.path(RESULTS_DIR, "tsk_claude_4_5_opus.rda")
)
