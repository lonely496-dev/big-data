# =============================================================================
# main.R — Health Behavior Correspondence Analysis
# Entry point: runs the full analysis pipeline
# =============================================================================

cat("\n========================================\n")
cat("  Health CA Analysis Pipeline\n")
cat("========================================\n\n")

# --- Source utilities ---
source("R/utils.R")

# --- Step 1: Data Preparation ---
cat("[1/5] Loading and preparing data...\n")
source("R/01_data_preparation.R")

# --- Step 2: Contingency Table ---
cat("[2/5] Building contingency table...\n")
source("R/02_contingency_table.R")

# --- Step 3: Correspondence Analysis ---
cat("[3/5] Running Correspondence Analysis...\n")
source("R/03_correspondence_analysis.R")

# --- Step 4: Hierarchical Clustering ---
cat("[4/5] Performing hierarchical clustering...\n")
source("R/04_clustering.R")

# --- Step 5: Visualizations ---
cat("[5/5] Generating visualizations...\n")
source("R/05_visualizations.R")

cat("\n✅ Pipeline complete. Outputs saved to outputs/\n")
