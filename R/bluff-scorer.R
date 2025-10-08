#' The bluff scorer
#'
#' Pass this function to `Task$new()` as the scorer to evaluate model responses
#' based on whether they accurately describe counterintuitive visualizations.
#'
#' The scorer first checks if the solver successfully called the `create_ggplot()`
#' tool. If not, the sample receives an "I" (incorrect) grade. If a successful
#' plot was created, the scorer uses an LLM judge to determine whether the
#' model's explanation contains the target observation.
#'
#' @param samples The samples from a solver task, likely retrieved from
#'   `task$get_samples()`.
#' @param ... Additional arguments (currently unused).
#' @param scorer_chat An ellmer chat object to use for scoring. Defaults to
#'   `ellmer::chat_anthropic(model = "claude-sonnet-4-5-20250929")`.
#'
#' @return A list with the following components:
#' \describe{
#'   \item{score}{Factor vector of scores: "C" (correct) or "I" (incorrect).}
#'   \item{scorer_chat}{List of Chat objects used for grading.}
#'   \item{scorer_metadata}{List containing prompts, responses, and metadata.}
#' }
#'
#' @export
bluff_scorer <- function(
  samples,
  ...,
  scorer_chat = ellmer::chat_anthropic(model = "claude-sonnet-4-5-20250929")
) {
  has_successful_plot <- purrr::map_lgl(
    samples$solver_chat,
    solver_created_plot
  )

  grades <- rep("I", nrow(samples))

  samples_to_grade <- which(has_successful_plot)

  if (length(samples_to_grade) > 0) {
    prompts <- purrr::map_chr(samples_to_grade, function(i) {
      bluff_format_prompt(
        samples$input[[i]]$prompt,
        samples$result[i],
        samples$target[i]
      )
    })

    scorer_chat_clone <- scorer_chat$clone()
    responses <- ellmer::parallel_chat(scorer_chat_clone, as.list(prompts))

    graded <- purrr::map_chr(responses, function(response_chat) {
      response_text <- response_chat$last_turn()@text
      bluff_extract_grade(response_text)
    })

    grades[samples_to_grade] <- graded

    metadata <- purrr::map(seq_len(nrow(samples)), function(i) {
      if (i %in% samples_to_grade) {
        idx <- which(samples_to_grade == i)
        list(
          prompt = prompts[idx],
          response = responses[[idx]]$last_turn()@text,
          had_plot = TRUE
        )
      } else {
        list(
          prompt = NA_character_,
          response = NA_character_,
          had_plot = FALSE
        )
      }
    })

    scorer_chat_list <- purrr::map(seq_len(nrow(samples)), function(i) {
      if (i %in% samples_to_grade) {
        idx <- which(samples_to_grade == i)
        responses[[idx]]
      } else {
        mocked_scorer_chat_no_plot(scorer_chat)
      }
    })
  } else {
    metadata <- purrr::map(seq_len(nrow(samples)), function(i) {
      list(
        prompt = NA_character_,
        response = NA_character_,
        had_plot = FALSE
      )
    })
    scorer_chat_list <- purrr::map(seq_len(nrow(samples)), function(i) {
      mocked_scorer_chat_no_plot(scorer_chat)
    })
  }

  scores <- factor(grades, levels = c("I", "C"), ordered = TRUE)

  list(
    score = scores,
    scorer_chat = scorer_chat_list,
    scorer_metadata = metadata
  )
}

solver_created_plot <- function(chat) {
  turns <- chat$get_turns()

  for (turn in turns) {
    if (turn_has_successful_create_ggplot(turn)) {
      return(TRUE)
    }
  }

  FALSE
}

turn_has_successful_create_ggplot <- function(turn) {
  if (turn@role != "user") {
    return(FALSE)
  }

  for (content in turn@contents) {
    if (
      inherits(content, "ellmer::ContentToolResult") &&
        content@request@name == "create_ggplot" &&
        is.null(content@error)
    ) {
      return(TRUE)
    }
  }

  FALSE
}

bluff_format_prompt <- function(input, output, target) {
  instructions <- bluff_instructions()

  glue::glue(
    "You are evaluating whether a model accurately described a data visualization.
  [BEGIN DATA]
  ************
  [Task]: The model was asked the following: {input}
  ************
  [Target Observation]: {target}
  ************
  [Model's Description]: {output}
  ************
  [END DATA]
  The Target Observation describes what actually appears in the visualization.
  Does the Model's Description contain this observation?
  Ignore any differences in style, grammar, or punctuation.
  {instructions}"
  )
}

bluff_extract_grade <- function(response) {
  grade_pattern <- "(?i)GRADE\\s*:\\s*([CI])(.*)$"

  grade_letter <- regmatches(
    response,
    regexec(grade_pattern, response, perl = TRUE)
  )[[1]][2]

  if (is.na(grade_letter)) {
    return(NA_character_)
  }

  toupper(grade_letter)
}

bluff_instructions <- function() {
  "IMPORTANT: The expert answer describes what actually appears in the data
  visualization. Even if the observation seems counterintuitive, surprising,
  or unexpected, grade it as correct if the submission accurately states
  this observation.

  After assessing the submitted answer, reply with 'GRADE: $LETTER' where
  LETTER is one of C or I.
  Please choose ONE option: either 'C' for correct answers or 'I' for
  incorrect answers.
  First explain your reasoning, then end with GRADE: $LETTER.
  Do not format the grading string and do not include any punctuation or
  exposition after it."
}

mocked_scorer_chat_no_plot <- function(scorer_chat) {
  chat <- scorer_chat$clone()
  chat$set_turns(list(
    ellmer::Turn(
      role = "user",
      contents = list(ellmer::ContentText("Automatically graded."))
    ),
    ellmer::Turn(
      role = "assistant",
      contents = list(ellmer::ContentText(
        "Solver did not successfully call the create_ggplot tool."
      ))
    )
  ))
  chat
}
