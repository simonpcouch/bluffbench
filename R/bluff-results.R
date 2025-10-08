#' Bluffbench results
#'
#' @description
#' The bluffbench results contain evaluation scores from running language models
#' on the bluffbench dataset. Each row represents one model's response to one
#' sample, showing whether the model correctly interpreted the counterintuitive
#' visualization.
#'
#' The dataset is a tibble with one row per model-sample combination, containing:
#' * `model`: The name of the language model evaluated
#' * `id`: Unique identifier for the sample (matches `bluff_dataset$id`)
#' * `score`: An ordered factor indicating whether the model's explanation was
#'   Correct (C) or Incorrect (I). A correct score means the model accurately
#'   described the actual plotted pattern, even when it contradicted expectations.
#'
#' @format A tibble with columns `model`, `id`, and `score`.
"bluff_results"

# See usage in bluff_results.R
process_results <- function() {
  task_files <- list.files("inst/run/tasks", full.names = TRUE)

  load_object <- function(file) {
    tmp <- new.env()
    load(file = file, envir = tmp)
    tmp[[ls(tmp)[1]]]
  }

  tasks <- list()
  for (task in task_files) {
    tasks[[gsub(".rda", "", basename(task))]] <- load_object(task)
  }
  names(tasks) <- gsub("tsk_", "", names(tasks))

  vitals::vitals_bind(!!!tasks)
}
