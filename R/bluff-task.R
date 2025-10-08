#' The bluff task
#'
#' Combines the [bluff_dataset], [bluff_solver], and [bluff_scorer] into a
#' [vitals::Task] for evaluating language models' ability to accurately
#' interpret counterintuitive visualizations.
#'
#' @param epochs Number of evaluation epochs to run. Default is 1.
#' @param dir Directory for logging evaluation results. Default is
#'   `vitals::vitals_log_dir()`.
#' @param samples Row indices from bluff_dataset to evaluate. Default is all rows.
#'
#' @return A vitals Task object combining the bluff dataset, solver, and scorer.
#' The task takes parameters `solver_chat` (required) and
#' `scorer_chat` (optional).
#'
#' @seealso [bluff_dataset] for the dataset, [bluff_solver] for the solver,
#'   [bluff_scorer] for the scorer, and [vitals::Task] for the task object.
#'
#' @export
bluff_task <- function(
  epochs = 1,
  dir = vitals::vitals_log_dir(),
  samples = seq_len(nrow(bluff_dataset))
) {
  vitals::Task$new(
    dataset = bluff_dataset[samples, ],
    solver = bluff_solver,
    scorer = bluff_scorer,
    epochs = epochs,
    name = "bluffbench",
    dir = dir
  )
}
