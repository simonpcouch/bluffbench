#' The bluff solver
#'
#' Pass this function to `Task$new()` as the solver to process inputs from the
#' bluffbench dataset with a specified language model.
#'
#' The solver executes secret data transformations, provides the model with a
#' ggplot creation tool, prompts the model to visualize and describe the data,
#' and extracts the model's explanation of what it observes in the plot.
#'
#' @param inputs List of input objects from the bluffbench dataset. Each input
#'   should have `code` (R code setting up the data transformation) and `prompt`
#'   (instruction for the model).
#' @param ... Additional arguments (currently unused).
#' @param solver_chat An ellmer Chat object to use for solving the prompts.
#'
#' @return A list with the following components:
#' \describe{
#'   \item{result}{Character vector of model explanations, one for each input.}
#'   \item{solver_chat}{List of Chat objects used to generate each response.}
#' }
#'
#' @export
bluff_solver <- function(inputs, ..., solver_chat) {
  check_inherits(solver_chat, "Chat")

  res <- vector("list", length = length(inputs))

  withr::local_options(cli.progress_show_after = 0)
  cli::cli_progress_bar("Solving", total = length(inputs))
  cli::cli_progress_update(inc = 0)

  for (i in seq_along(inputs)) {
    input <- inputs[[i]]

    env <- new.env(parent = .GlobalEnv)

    run_r_code(input$setup, env)

    ch_i <- solver_chat$clone()
    ch_i$register_tool(tool_create_ggplot(env))

    ch_i$chat(input$prompt, echo = FALSE)

    res[[i]] <- ch_i

    run_r_code(input$teardown, env)

    cli::cli_progress_update()
    Sys.sleep(15)
  }
  cli::cli_progress_done()

  list(
    result = purrr::map_chr(res, function(c) c$last_turn()@text),
    solver_chat = res
  )
}

check_inherits <- function(x, class) {
  if (!inherits(x, class)) {
    cli::cli_abort("{.arg solver_chat} must be a {.cls {class}} object.")
  }
}
