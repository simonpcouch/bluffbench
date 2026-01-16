withr::local_envvar(VITALS_LOG_DIR = "inst/run/logs")
devtools::load_all()

tsk <- bluff_task(epochs = 3)

# To use a model-in-the-middle that interprets plots as text:
# tsk$eval(solver_chat = ..., model_in_the_middle = TRUE)

# claude 4.5 opus ----------------------------------------------------
tsk_claude_4_5_opus <- tsk$clone()
tsk_claude_4_5_opus$eval(
  solver_chat = ellmer::chat_anthropic(model = "claude-opus-4-5-20251101")
)

save(tsk_claude_4_5_opus, file = "inst/run/tasks/tsk_claude_4_5_opus.rda")

# gemini 3 pro ------------------------------------------------------
tsk_gemini_3_pro <- tsk$clone()
tsk_gemini_3_pro$eval(
  solver_chat = ellmer::chat_google_gemini(model = "gemini-3-pro-preview")
)

save(tsk_gemini_3_pro, file = "inst/run/tasks/tsk_gemini_3_pro.rda")

# gpt-5.2 -----------------------------------------------------------
tsk_gpt_5_2 <- tsk$clone()
tsk_gpt_5_2$eval(
  solver_chat = ellmer::chat_openai(model = "gpt-5.2")
)

save(tsk_gpt_5_2, file = "inst/run/tasks/tsk_gpt_5_2.rda")
