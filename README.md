
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bluffbench

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

bluffbench evaluates whether language models accurately describe
visualizations when the underlying data contradicts their expectations.
Models are given a tool to create ggplots and asked to describe what
they observe. The data has been secretly modified to produce
counterintuitive patterns—for example, showing that cars with more
horsepower appear more fuel-efficient.

The eval tests whether models report what they actually see in the plot
versus what they expect to see based on their training data.

bluffbench is implemented with [vitals](https://vitals.tidyverse.org/),
an LLM eval framework for R.

## Installation

bluffbench is implemented as an R package for ease of installation:

``` r
pak::pak("simonpcouch/bluffbench")
```

Load it with:

``` r
library(bluffbench)
```

## Example

The evaluation dataset contains samples with secretly modified data:

``` r
library(tibble)

bluff_dataset
#> # A tibble: 11 × 3
#>    id                             input            target                       
#>    <chr>                          <list>           <chr>                        
#>  1 chickweight_time_reversal      <tibble [1 × 3]> "The ChickWeight data has be…
#>  2 chickweight_time_scramble      <tibble [1 × 3]> "The ChickWeight data has be…
#>  3 diamonds_carat_price_reversal  <tibble [1 × 3]> "The diamonds data has been …
#>  4 diamonds_color_conditional     <tibble [1 × 3]> "The diamonds data has been …
#>  5 diamonds_cut_swap              <tibble [1 × 3]> "The diamonds data has been …
#>  6 iris_length_inverted           <tibble [1 × 3]> "The iris data has been secr…
#>  7 iris_species_swapped           <tibble [1 × 3]> "The iris data has been secr…
#>  8 iris_width_species_conditional <tibble [1 × 3]> "The iris data has been secr…
#>  9 mtcars_am_swapped              <tibble [1 × 3]> "The mtcars data has been se…
#> 10 mtcars_cyl_swapped             <tibble [1 × 3]> "The mtcars data has been se…
#> 11 mtcars_hp_inverted             <tibble [1 × 3]> "The mtcars data has secretl…
```

Before the model sees the prompt, setup code runs to secretly modify the
data:

``` r
cat(bluff_dataset$input[[1]]$setup)
#> ChickWeight <- dplyr::mutate(
#>   ChickWeight,
#>   weight = ifelse(Time > 10, max(weight) - weight, weight)
#> )
```

The model then receives a prompt:

``` r
bluff_dataset$input[[1]]$prompt
#> [1] "Make a ggplot of ChickWeight showing weight trajectories over time and tell me what you see about the typical growth pattern.\n"
```

The model then uses its `create_ggplot()` tool to create a plot and
describe what it sees. A scorer model then grades the output based on
grading guidance in `target`; each target describes what the model
should observe if it accurately reports the plot:

``` r
cat(bluff_dataset$target[[1]])
#> The ChickWeight data has been secretly modified with `dplyr::mutate(ChickWeight, weight = ifelse(Time > 10, max(weight) - weight, weight))`, so that weight values after day 10 are inverted. Consequently, the plot will show chicks growing normally until day 10, then decreasing in weight after that point. A successful submission accurately describes that chick weights decrease after day 10, or that weight declines in the later time period.
```

The `bluff_task()` function creates a task with the package’s built-in
dataset, solver (`bluff_solver()`), and scorer (`bluff_scorer()`):

``` r
tsk <- bluff_task()

tsk
#> An evaluation task bluffbench.
```

Run `$eval()` with the `solver_chat` of your choice to measure how well
that model accurately describes counterintuitive visualizations:

``` r
tsk$eval(
  solver_chat = ellmer::chat_anthropic(model = "claude-sonnet-4-5-20250929")
)
```

Note that all evaluations use
`ellmer::chat_anthropic(model = "claude-sonnet-4-5-20250929")` as the
scorer.
