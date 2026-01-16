# bluffbench (development version)

* `bluff_solver()` gains several new arguments:
  - `image_only` provides only the plot image to the model without access to
    the `create_ggplot` tool (#7).
  - `clarify` appends a note that the dataset already exists in the
    environment. Now `TRUE` by default (#4).
  - `model_in_the_middle` has an intermediate model interpret the plot image
    before returning it to the solver (#2).
  - The package now includes bundled system prompt files for "memo" and 
    "reflection" tags (#6).

* `bluff_scorer()` now prompts for more concise reasoning from the grader
  model, preventing the scorer from "talking itself out of" correct 
  reasoning (#12).

* `bluff_dataset` now includes updated baseline samples with clearer prompts,
  resolving failures unrelated to the solvers' actual ability to faithfully
  interpret plots (#4, #15).

* `bluff_results` updated with new model versions: Claude 4.5 Sonnet to
  Claude 4.5 Opus, Gemini 2.5 Pro to Gemini 3 Pro, and GPT-5 to GPT-5.2
  (#14, #16).

* Added Sara Altman as author.

# bluffbench 0.0.0.9000

This tag was applied to a version of the package that existed around the time
of the authors' [first blog post on the topic](https://posit.co/blog/introducing-bluffbench/).
