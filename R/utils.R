# =============================================================================
# utils.R — Shared helper functions
# =============================================================================

#' Check and install required packages
#'
#' @param pkgs Character vector of package names
ensure_packages <- function(pkgs) {
  missing <- pkgs[!pkgs %in% rownames(installed.packages())]
  if (length(missing) > 0) {
    message("Installing missing packages: ", paste(missing, collapse = ", "))
    install.packages(missing)
  }
  invisible(lapply(pkgs, library, character.only = TRUE))
}

required_packages <- c("FactoMineR", "factoextra", "dplyr", "ggplot2", "scales")
ensure_packages(required_packages)

#' Save a ggplot with consistent sizing
#'
#' @param plot ggplot object
#' @param filename Output filename (saved to outputs/)
#' @param width Width in inches
#' @param height Height in inches
save_plot <- function(plot, filename, width = 8, height = 5) {
  dir.create("outputs", showWarnings = FALSE)
  path <- file.path("outputs", filename)
  ggsave(path, plot = plot, width = width, height = height, dpi = 150)
  message("  Saved: ", path)
}

#' Print a formatted section header
#'
#' @param title Section title text
section_header <- function(title) {
  line <- paste0(rep("-", nchar(title) + 4), collapse = "")
  cat("\n", line, "\n")
  cat(" ", title, "\n")
  cat(line, "\n")
}

#' Round a data frame of numeric columns
#'
#' @param df Data frame
#' @param digits Number of decimal places
round_df <- function(df, digits = 4) {
  numeric_cols <- sapply(df, is.numeric)
  df[numeric_cols] <- lapply(df[numeric_cols], round, digits = digits)
  df
}
