# =============================================================================
# 01_data_preparation.R — Load and preprocess the CDC health survey dataset
# =============================================================================

# --- Configuration ---
DATA_PATH <- "data/cdc.csv"

# --- Load data ---
if (!file.exists(DATA_PATH)) {
  stop(
    "Dataset not found at: ", DATA_PATH,
    "\nPlease place cdc.csv in the data/ directory.",
    "\nSee data/README.md for variable descriptions."
  )
}

df_raw <- read.csv(DATA_PATH, stringsAsFactors = FALSE)

cat("  Rows loaded:", nrow(df_raw), "\n")
cat("  Columns:    ", ncol(df_raw), "\n")

# --- Select and encode variables ---
REQUIRED_COLS <- c("genhlth", "exerany", "hlthplan", "smoke100", "gender")

missing_cols <- setdiff(REQUIRED_COLS, colnames(df_raw))
if (length(missing_cols) > 0) {
  stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
}

df <- df_raw %>%
  select(all_of(REQUIRED_COLS)) %>%
  mutate(
    # Ordinal health status — preserve meaningful order
    genhlth = factor(genhlth,
      levels = c("excellent", "very good", "good", "fair", "poor"),
      ordered = TRUE
    ),
    # Binary behavioral variables → descriptive labels
    exerany  = factor(exerany,  levels = c(0, 1), labels = c("No_Exercise", "Yes_Exercise")),
    hlthplan = factor(hlthplan, levels = c(0, 1), labels = c("No_Plan",     "Yes_Plan")),
    smoke100 = factor(smoke100, levels = c(0, 1), labels = c("No_Smoke",    "Yes_Smoke")),
    gender   = as.factor(gender)
  ) %>%
  na.omit()

cat("  Rows after cleaning:", nrow(df), "\n")
cat("  Missing values removed:", nrow(df_raw) - nrow(df), "\n\n")

# --- Summary snapshot ---
section_header("Variable Distributions")
print(summary(df))

# --- Frequency table: health status ---
section_header("Health Status Counts")
health_counts <- df %>%
  count(genhlth) %>%
  mutate(pct = scales::percent(n / sum(n), accuracy = 0.1))
print(health_counts)
