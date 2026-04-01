# =============================================================================
# 04_clustering.R — Hierarchical Clustering on CA row coordinates
# =============================================================================

# --- Euclidean distance on first 2 CA dimensions ---
row_coords_matrix <- res.ca$row$coord[, 1:2]
dist_matrix <- dist(row_coords_matrix, method = "euclidean")

# --- Ward's hierarchical clustering ---
hc <- hclust(dist_matrix, method = "ward.D2")

# --- Cut tree into k clusters ---
N_CLUSTERS <- 3
clusters <- cutree(hc, k = N_CLUSTERS)

section_header("Cluster Assignments")
cluster_df <- data.frame(
  Health_Category = names(clusters),
  Cluster         = as.integer(clusters)
)
cluster_df <- cluster_df[order(cluster_df$Cluster), ]
rownames(cluster_df) <- NULL
print(cluster_df)

# --- Add cluster labels to coordinate data for plotting ---
row_coords_clustered <- data.frame(
  row_coords_matrix,
  Cluster = as.factor(clusters),
  Label   = rownames(row_coords_matrix)
)

# --- Silhouette-inspired summary: within-cluster spread ---
section_header("Within-Cluster Spread (lower = more compact)")
for (k in 1:N_CLUSTERS) {
  members <- row_coords_matrix[clusters == k, , drop = FALSE]
  if (nrow(members) > 1) {
    centroid <- colMeans(members)
    spread   <- mean(apply(members, 1, function(x) sqrt(sum((x - centroid)^2))))
    cat(sprintf("  Cluster %d (%s): mean dist to centroid = %.4f\n",
        k, paste(rownames(members), collapse = ", "), spread))
  } else {
    cat(sprintf("  Cluster %d (%s): singleton\n",
        k, rownames(members)))
  }
}

# --- Extended: also try HCPC via FactoMineR ---
tryCatch({
  res.hcpc <- HCPC(res.ca, nb.clust = N_CLUSTERS, graph = FALSE)
  section_header("HCPC Cluster Descriptions (FactoMineR)")
  print(res.hcpc$desc.var)
}, error = function(e) {
  message("  HCPC skipped (requires interactive session for some versions): ", e$message)
})
