# Synthetic baseline dataset samples

Sample synthetic datasets that demonstrate particular types of relationships. Models should not have intuitions about the relationships just based off the dataset name or column names. 

Each example includes the dataset, prompt, and pattern. 

## 1. Categorical differences between groups

**Dataset**: 

    ```
    df <- 
        tibble::tibble(
            group = rep(c("A", "B", "C"), each = 10),
            measure = c(rnorm(10, 20, 3), rnorm(10, 40, 3), rnorm(10, 60, 3))
        )
    ```

**Pattern**: The dataset shows clear differences between groups. Group A has the lowest measure values, group B has intermediate values, and group C has the highest values.

**Prompt**: Use the df dataset to make a ggplot showing the relationship between group and measure, and tell me what patterns you observe.

## 2. Positive linear correlation

**Dataset**:

    ```
    df <-
        tibble::tibble(
            x = 1:30,
            y = 2 * (1:30) + rnorm(30, 0, 5)
        )
    ```

**Pattern**: The dataset shows a clear positive linear relationship between x and y. As x increases, y increases proportionally.

**Prompt**: Use the df dataset to make a ggplot with x on the x axis and y on the y axis, and tell me what relationship you observe.

## 3. No correlation

**Dataset**:

    ```
    df <-
        tibble::tibble(
            x = 1:30,
            y = rnorm(30, 50, 10)
        )
    ```

**Pattern**: The dataset shows no relationship between x and y. The y values are randomly distributed across all x values with no discernible pattern.

**Prompt**: Use the df dataset to make a ggplot with x on the x axis and y on the y axis, and tell me what relationship you observe.

## 4. Complex relationship with multiple variables

**Dataset**:

    ```
    state_income <-
        tibble::tibble(
            state = rep(c("California", "Texas", "New York"), each = 40),
            age = rep(25:64, times = 3),
            income = c(
                50000 + 800 * (25:64) + rnorm(40, 0, 5000),   
                45000 + 600 * (25:64) + rnorm(40, 0, 5000),    
                48000 + 700 * (25:64) + rnorm(40, 0, 5000)    
            )
        )
    ```

**Pattern**: The dataset shows income increases with age across all three states, with California showing the steepest increase, followed by New York, then Texas. All states show positive relationships between age and income, but at different rates.

**Prompt**: Use the state_income dataset to make a ggplot showing the relationship between age and income across the different states, and tell me what patterns you observe.

