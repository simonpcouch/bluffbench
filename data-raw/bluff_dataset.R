samples_dir <- "data-raw/samples"

sample_paths <- list.files(
  samples_dir,
  pattern = "\\.ya?ml$",
  full.names = TRUE
)

bluff_dataset <- purrr::map(sample_paths, yaml::read_yaml) |>
  purrr::map_dfr(\(sample) {
    tibble::tibble(
      id = sample$id,
      input = list(
        tibble::tibble(
          prompt = sample$input$prompt,
          setup = sample$input$setup,
          teardown = sample$input$teardown
        )
      ),
      target = sample$target
    )
  }) |>
  dplyr::arrange(id)

usethis::use_data(bluff_dataset, overwrite = TRUE)
