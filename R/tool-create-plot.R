run_ggplot_code <- function(code) {
  result <- tryCatch(
    run_r_code(code),
    error = function(e) {
      return(ellmer::ContentToolResult(error = conditionMessage(e)))
    }
  )

  if (inherits(result, "ggplot")) {
    temp_file <- tempfile(fileext = ".png")
    ggplot2::ggsave(temp_file, plot = result, width = 7, height = 5, dpi = 150)
    return(ellmer::content_image_file(temp_file))
  }

  ellmer::ContentToolResult(error = "Code did not return a ggplot object")
}

run_r_code <- function(code) {
  eval(parse(text = code), envir = .GlobalEnv)
}

#' ggplot visualization tool
#'
#' An ellmer tool that evaluates R code to create ggplot visualizations.
#' The tool is named "create_ggplot" and accepts R code that returns a ggplot
#' object. This intentionally presents a narrow interface to discourage models
#' from exploring data with arbitrary code.
#'
#' @export
tool_create_ggplot <- ellmer::tool(
  run_ggplot_code,
  name = "create_ggplot",
  description = "Create a ggplot visualization from the provided R code.",
  arguments = list(
    code = ellmer::type_string(
      "R code that begins with library(ggplot2) and then a call to the `ggplot()` function. This code runs in the global environment--do _not_ run any code via this tool that could cause side effects in the global environment such as calling `data()` on an object."
    )
  )
)
