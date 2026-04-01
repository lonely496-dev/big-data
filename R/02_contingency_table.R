# =============================================================================
# 02_contingency_table.R — Build multi-column indicator contingency table
# =============================================================================

#' Build a combined indicator table: one row variable vs multiple column variables
#'
#' Each column variable is expanded into binary indicator columns named
#' "varname:level", then all are column-bound into a single frequency matrix.
#'
#' @param df         Data frame containing the variables
#' @param row_var    Name of the row variable (string)
#' @param col_vars   Character vector of column variable names
#'
#' @return A numeric matrix with row categories as rows and
#'         "varname:level" pairs as columns
build_indicator_table <- function(df, row_var, col_vars) {
  result_list <- lapply(col_vars, function(col_var) {
    tab <- table(df[[row_var]], df[[col_var]])
    colnames(tab) <- paste0(col_var, ":", colnames(tab))
    tab
  })
  tab_combined <- do.call(cbind, result_list)
  return(tab_combined)
}

# --- Build the table ---
COL_VARS <- c("exerany", "hlthplan", "smoke100", "gender")

tab_combined <- build_indicator_table(df, "genhlth", COL_VARS)

section_header("Combined Indicator Contingency Table")
print(tab_combined)

# --- Row and column profiles ---
row_totals <- rowSums(tab_combined)
col_totals <- colSums(tab_combined)
grand_total <- sum(tab_combined)

row_profiles <- tab_combined / row_totals
col_profiles  <- t(t(tab_combined) / col_totals)

section_header("Row Profiles (health category distributions)")
print(round_df(as.data.frame(row_profiles)))

section_header("Column Profiles (behavioral variable distributions)")
print(round_df(as.data.frame(col_profiles)))

# --- Chi-squared test ---
chi_test <- chisq.test(tab_combined)
cat("\nChi-squared statistic:", round(chi_test$statistic, 3),
    " | df:", chi_test$parameter,
    " | p-value:", format.pval(chi_test$p.value, digits = 3), "\n")
