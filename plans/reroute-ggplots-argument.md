# Route model-in-the-middle via solver argument

## Current state

The "model-in-the-middle" feature is controlled by the `REROUTE_GGPLOTS` environment variable:

- Set in `inst/run/run_eval.R` via `Sys.setenv(REROUTE_GGPLOTS = "true")`
- Checked in `R/tool-create-plot.R:15` via `Sys.getenv("REROUTE_GGPLOTS")`
- When enabled, `interpret_plot()` interprets the ggplot instead of returning the image directly

The solver already uses a `the` environment to store `solver_chat` for access by `interpret_plot()`.

## Approach

Add a `model_in_the_middle` argument to the solver and store it alongside `solver_chat` in `the`.

## Tasks

- [x] Add `model_in_the_middle = FALSE` argument to `bluff_solver()` in `R/bluff-solver.R`
- [x] Store `the$model_in_the_middle <- model_in_the_middle` at the start of the solver
- [x] Replace env var check in `run_ggplot_code()` with `isTRUE(the$model_in_the_middle)`
- [x] Update `inst/run/run_eval.R` to show usage via `$eval(model_in_the_middle = TRUE)` instead of `Sys.setenv()`
- [x] Update solver documentation to describe the new argument
