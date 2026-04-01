# =============================================================================
# 03_correspondence_analysis.R — Run CA and extract key statistics
# =============================================================================

# --- Run CA ---
res.ca <- CA(tab_combined, graph = FALSE)

# --- Eigenvalues / Explained inertia ---
section_header("Eigenvalues and % Inertia Explained")
eig_df <- as.data.frame(res.ca$eig)
colnames(eig_df) <- c("Eigenvalue", "% Variance", "Cumulative %")
print(round_df(eig_df))

# --- Row coordinates and contributions ---
section_header("Row Coordinates (Health Status)")
row_coords <- as.data.frame(res.ca$row$coord)
row_cos2   <- as.data.frame(res.ca$row$cos2)
row_contrib <- as.data.frame(res.ca$row$contrib)

cat("Coordinates:\n"); print(round_df(row_coords[, 1:2]))
cat("\nCos² (quality of representation):\n"); print(round_df(row_cos2[, 1:2]))
cat("\nContributions to dimensions (%):\n"); print(round_df(row_contrib[, 1:2]))

# --- Column coordinates and contributions ---
section_header("Column Coordinates (Behavioral Variables)")
col_coords  <- as.data.frame(res.ca$col$coord)
col_cos2    <- as.data.frame(res.ca$col$cos2)
col_contrib <- as.data.frame(res.ca$col$contrib)

cat("Coordinates:\n"); print(round_df(col_coords[, 1:2]))
cat("\nCos² (quality of representation):\n"); print(round_df(col_cos2[, 1:2]))
cat("\nContributions to dimensions (%):\n"); print(round_df(col_contrib[, 1:2]))

# --- Dimension descriptions ---
section_header("Dimension Descriptions (dimdesc)")
res.dimdesc <- dimdesc(res.ca, axes = 1:2)
print(res.dimdesc)

# --- Dim 1 summary table (as shown in report) ---
section_header("Dimension 1 Coordinate Summary")
dim1_rows <- data.frame(
  Category = rownames(row_coords),
  Type     = "Row",
  Dim1     = round(row_coords$`Dim 1`, 4)
)
dim1_cols <- data.frame(
  Category = rownames(col_coords),
  Type     = "Column",
  Dim1     = round(col_coords$`Dim 1`, 4)
)
dim1_table <- rbind(dim1_rows, dim1_cols)
dim1_table <- dim1_table[order(dim1_table$Dim1), ]
print(dim1_table)
