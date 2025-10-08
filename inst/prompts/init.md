

I would like to write an LLM evaluation called bluffbench that measures how well various models accurately interpret visualizations that go against their intuition. You are situated in a skeleton R package for the eval.

The eval will be implemented in R using the vitals framework. Use the btw MCP to learn about important object types:

* vitals::Task
* ellmer::Chat
* ellmer::Turn

At a high level, the eval's solver:

* Situates a model with a `run_r_code()` tool (this should just be `predictive:::run_r_code()`--import predictive and use that tool as it is)
* Asks the model to make a ggplot of something it might have intuitions about but whose actual results will circumvent its expectations and provide an explanation of what it sees.
	* For example, one might mock `mtcars` so that the mpg is actually `max(mtcars$mpg) - mtcars$mpg` using `testthat::local_mocked_bindings()` (or just assigning to the global environment.)
	* One could also place a .csv file in a directory that has obviously named columns.

The dataset:

* Each input entry should be a tibble 

Then, the scorer takes the explanation of what the model saw and uses `model_graded_fact()` with a custom instruction that clarifies to the scorer that the true `target` may be counterintuitive but is actually true. `model_graded_fact()` should use `scorer_chat = chat_anthropic(model = "claude-sonnet-4-5-20250929")`.

The eval should be implemented as an R package, exporting three objects:

* `something_dataset`
* `something_solver`
* `something_scorer`

The code to generate `something_dataset` should live in `data-raw`.

There are a couple example evals in this directory that you should use as inspiration in `inst/sandbox/`:

* predictivebench: Implements a `modeling_dataset` that's quite involved on several axes.
* choreseval
