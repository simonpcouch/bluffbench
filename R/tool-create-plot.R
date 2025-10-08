#' Create a ggplot visualization tool
#'
#' An ellmer tool that wraps `predictive:::run_r_code()` to allow models to
#' create ggplot visualizations. The tool is named "create_ggplot" and accepts
#' R code that returns a ggplot object. This intentionally presents a narrow
#' interface to discourage models from exploring data with arbitrary code.
#'
#' @export
tool_create_ggplot <- ellmer::tool(
  predictive:::run_r_code,
  name = "create_ggplot",
  description = "Create a ggplot visualization from the provided R code.",
  arguments = list(
    code = ellmer::type_string(
      "R code that begins with library(ggplot2) and then a call to the `ggplot()` function. Do _not_ run any code via this tool that could cause side effects in the global environment such as calling `data()` on an object."
    )
  )
)
