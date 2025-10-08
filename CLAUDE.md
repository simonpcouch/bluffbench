This is an R package implementing an LLM evaluation that tests language models' ability to accurately interpret visualizations with counterintuitive data. Models are given a tool to create ggplots from secretly modified datasets and must describe what they observe. The eval measures whether models report the actual plotted patterns even when they contradict expectations.

## Related documentation

Future AI assistants should read the help pages for the following R functions:

* `ellmer::Chat()`
* `ellmer::Turn()`
* `ellmer::tool()`
* `vitals::Task()`

Also, read all of the files in R/.

## Package structure

The package exports four main objects:

- `bluff_dataset`: A tibble with `id`, `input` (list-column with `prompt`/`setup`/`teardown`), and `target` columns. Generated from YAML files in `data-raw/samples/`.
- `bluff_solver`: Takes inputs, runs setup code, gives model `create_ggplot` tool, runs teardown code, returns explanations.
- `bluff_scorer`: Checks if solver called `create_ggplot` successfully, then uses LLM judge to grade explanation against target. Returns factor scores (I/C).
- `bluff_task`: Combines dataset, solver, scorer into `vitals::Task`.

The solver runs setup, registers `tool_create_ggplot` (wraps `predictive:::run_r_code`), prompts model, runs teardown.

The scorer first checks turns for `ContentToolResult` with `request@name == "create_ggplot"` and `error == NULL`. If found, sends explanation to LLM judge using `bluff_format_prompt` and `bluff_instructions`. Judge is told counterintuitive observations are valid if accurately stated.

The `tool_create_ggplot` is defined as an `ellmer::tool` with name `"create_ggplot"` and description focused on creating ggplot objects, intentionally narrow to discourage data exploration.

Samples are defined in yaml:

- `id`: unique identifier matching filename
- `input.setup`: R code that modifies a dataset in global environment
- `input.teardown`: R code that removes the dataset (`rm(dataset_name)`)
- `input.prompt`: Natural instruction to create and describe a plot
- `target`: Description of transformation and what correct answer should state

When writing sample YAML files, keep row counts and values intact, only relabel or reorder to create misconceptions. Do not mention the perturbation in the prompt.

## Website

Rather than a pkgdown website, the package uses an `index.qmd` and `_quarto.yml` to knit to `docs/`. 
