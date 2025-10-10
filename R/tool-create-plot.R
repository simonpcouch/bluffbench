run_ggplot_code <- function(code, env) {
  result <- tryCatch(
    run_r_code(code, env),
    error = function(e) e
  )

  if (inherits(result, "error")) {
    return(ellmer::ContentToolResult(error = conditionMessage(result)))
  }

  if (inherits(result, "ggplot")) {
    temp_file <- tempfile(fileext = ".png")
    ggplot2::ggsave(temp_file, plot = result, width = 7, height = 5, dpi = 150)
    return(ellmer::content_image_file(temp_file))
  }

  result_type <- if (is.null(result)) {
    "NULL"
  } else {
    paste0(class(result), collapse = ", ")
  }

  ellmer::ContentToolResult(
    error = paste0("Code did not return a ggplot object. Got: ", result_type)
  )
}

run_r_code <- function(code, env) {
  suppressWarnings(eval(parse(text = code), envir = env))
}

#' ggplot visualization tool factory
#'
#' Creates an ellmer tool that evaluates R code to create ggplot visualizations
#' in a specified environment. The tool is named "create_ggplot" and accepts
#' R code that returns a ggplot object. This intentionally presents a narrow
#' interface to discourage models from exploring data with arbitrary code.
#'
#' @param env The environment in which to evaluate the code.
#'
#' @export
tool_create_ggplot <- function(env) {
  ellmer::tool(
    function(code) run_ggplot_code(code, env),
    name = "create_ggplot",
    description = "Create a ggplot visualization from the provided R code.",
    arguments = list(
      code = ellmer::type_string(
        "R code that begins with library(ggplot2) and then a call to the `ggplot()` function. This code runs in the global environment--do _not_ run any code via this tool that could cause side effects in the global environment such as calling `data()` on an object."
      )
    )
  )
}
