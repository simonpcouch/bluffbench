withr::local_envvar(VITALS_LOG_DIR = "inst/run/logs")
devtools::load_all()

tsk <- bluff_task(epochs = 3)

# claude 4.5 sonnet -------------------------------------------------
tsk_claude_4_5_sonnet <- tsk$clone()
tsk_claude_4_5_sonnet$eval(
  solver_chat = ellmer::chat_anthropic(model = "claude-sonnet-4-5-20250929")
)

save(tsk_claude_4_5_sonnet, file = "inst/run/tasks/tsk_claude_4_5_sonnet.rda")

# gemini 2.5 pro ----------------------------------------------------
tsk_gemini_2_5_pro <- tsk$clone()
tsk_gemini_2_5_pro$eval(
  solver_chat = ellmer::chat_google_gemini(model = "gemini-2.5-pro")
)

save(tsk_gemini_2_5_pro, file = "inst/run/tasks/tsk_gemini_2_5_pro.rda")

# gpt-5 -------------------------------------------------------------
tsk_gpt_5 <- tsk$clone()
tsk_gpt_5$eval(
  solver_chat = ellmer::chat_openai(model = "gpt-5")
)

save(tsk_gpt_5, file = "inst/run/tasks/tsk_gpt_5.rda")
