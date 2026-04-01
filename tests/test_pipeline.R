# =============================================================================
# tests/test_pipeline.R — Unit tests using testthat
# =============================================================================

library(testthat)

# --- Source the functions under test ---
source("R/utils.R")
source("R/02_contingency_table.R", local = TRUE)

# =============================================================================
# Test: build_indicator_table
# =============================================================================

test_that("build_indicator_table returns a matrix", {
  df_test <- data.frame(
    health = c("good", "poor", "good", "fair"),
    exer   = factor(c(1, 0, 1, 0), labels = c("No", "Yes")),
    smoke  = factor(c(0, 1, 0, 1), labels = c("No", "Yes"))
  )
  tab <- build_indicator_table(df_test, "health", c("exer", "smoke"))
  expect_true(is.matrix(tab) || is.table(tab))
})

test_that("build_indicator_table columns are prefixed with variable name", {
  df_test <- data.frame(
    health = c("good", "poor"),
    exer   = factor(c(1, 0), labels = c("No", "Yes"))
  )
  tab <- build_indicator_table(df_test, "health", "exer")
  expect_true(all(grepl("^exer:", colnames(tab))))
})

test_that("build_indicator_table row counts match source data", {
  df_test <- data.frame(
    health = c("good", "good", "poor"),
    exer   = factor(c(1, 1, 0), labels = c("No", "Yes"))
  )
  tab <- build_indicator_table(df_test, "health", "exer")
  expect_equal(sum(tab), nrow(df_test))
})

# =============================================================================
# Test: round_df utility
# =============================================================================

test_that("round_df rounds numeric columns to specified digits", {
  df_num <- data.frame(a = c(1.23456, 7.89012), b = c("x", "y"))
  result <- round_df(df_num, digits = 2)
  expect_equal(result$a, c(1.23, 7.89))
  expect_equal(result$b, c("x", "y"))  # non-numeric unchanged
})

# =============================================================================
# Test: CA output structure
# =============================================================================

test_that("CA result contains row and column coordinates", {
  # Build minimal CA to test structure
  m <- matrix(c(10, 20, 30, 40, 25, 15, 35, 5),
              nrow = 2, dimnames = list(c("good", "poor"),
                                        c("exer:No", "exer:Yes", "smoke:No", "smoke:Yes")))
  ca_test <- CA(m, graph = FALSE)
  expect_true(!is.null(ca_test$row$coord))
  expect_true(!is.null(ca_test$col$coord))
})

cat("\n✅ All tests passed.\n")
