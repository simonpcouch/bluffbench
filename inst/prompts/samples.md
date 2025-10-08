## Writing Bluff Samples

Each sample of the eval makes some secret change to a dataset that the solver probably has intuition about, e.g. taking `mtcars$hp <- max(mtcars$hp) - mtcars$hp` under the hood before the solver is instantiated. Then, the solver is asked to create a plot from the data and describe what it "sees." Samples are written in `.yaml` files:

- Keep each sample in `data-raw/samples/{id}.yaml`.
- `id` should be unique, descriptive, and match the filename.
- Nest the solver setup and instruction under `input` with two scalar strings:
  - `code`: any R that prepares the workspace. Prefer `testthat::local_mocked_bindings()`  so changes are scoped and prefer tidyverse.
  - `prompt`: a brief, natural request to the model (e.g. “Make a ggplot of...”) that a user might make. Avoid exposition or spoilers.
- Leave `target` as free-form text. Spell out:
  1. The hidden transformation (from the solver’s perspective).
  2. What the rendered chart will now display.
  3. The specific observation a successful solver should report (“A successful submission states that...”).

- Keep the underlying row counts and values intact—only relabel or reorder to create misconceptions. If printed out, the data should look roughly convincing.
- Do not mention the perturbation in the prompt. The trap should emerge only from the plotted result.
