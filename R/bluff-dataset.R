#' Bluffbench dataset
#'
#' @description
#' The bluffbench dataset contains samples for evaluating language models' ability
#' to accurately interpret visualizations with counterintuitive data. Each sample
#' includes secret data transformations and prompts that ask models to create and
#' describe plots.
#'
#' The dataset is a tibble with one row per sample, containing:
#' * `id`: Unique identifier for the sample
#' * `input`: A list-column where each element is a tibble with:
#'   - `setup`: R code that secretly transforms the data (e.g., inverting values,
#'     swapping labels)
#'   - `teardown`: R code that cleans up the transformation (removes the dataset)
#'   - `prompt`: Natural language instruction asking the model to create a plot
#' * `target`: Description of what the transformation does and what a successful
#'   model response should state
#'
#' @format A tibble with columns `id`, `input`, and `target`.
#'
#' @examples
#' bluff_dataset
#'
#' # View a single sample
#' bluff_dataset[1, ]
#'
#' # Extract the input for the first sample
#' bluff_dataset$input[[1]]
#'
"bluff_dataset"
