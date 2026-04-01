# =============================================================================
# 05_visualizations.R — All plots: biplot, dendrogram, cluster map, mosaic
# =============================================================================

dir.create("outputs", showWarnings = FALSE)

# ── Palette ──────────────────────────────────────────────────────────────────
PALETTE_HEALTH  <- "#1E88E5"   # row points (health)
PALETTE_BEHAV   <- "#E53935"   # column points (behavior)
PALETTE_CLUSTER <- c("#1E88E5", "#43A047", "#FB8C00")  # 3 cluster colors

# =============================================================================
# PLOT 1: CA Biplot (Factor Map)
# =============================================================================

p_biplot <- fviz_ca_biplot(
  res.ca,
  repel     = TRUE,
  col.row   = PALETTE_HEALTH,
  col.col   = PALETTE_BEHAV,
  labelsize = 4,
  title     = "Correspondence Analysis — Health Status × Behavioral Variables"
) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title    = element_text(face = "bold", color = "#212121", hjust = 0.5, size = 14),
    axis.title    = element_text(color = "#424242"),
    panel.grid.minor = element_blank(),
    legend.position  = "bottom"
  ) +
  labs(
    x = paste0("Dimension 1 (", round(res.ca$eig[1, 2], 1), "% inertia)"),
    y = paste0("Dimension 2 (", round(res.ca$eig[2, 2], 1), "% inertia)")
  )

save_plot(p_biplot, "01_ca_biplot.png", width = 9, height = 6)

# =============================================================================
# PLOT 2: Scree Plot — Explained Inertia per Dimension
# =============================================================================

p_scree <- fviz_screeplot(
  res.ca,
  addlabels = TRUE,
  barfill   = "#1E88E5",
  barcolor  = "#1565C0",
  linecolor = "#E53935",
  title     = "Scree Plot — Explained Inertia by Dimension"
) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

save_plot(p_scree, "02_scree_plot.png", width = 7, height = 5)

# =============================================================================
# PLOT 3: Row Contributions to Dimension 1
# =============================================================================

p_row_contrib <- fviz_contrib(
  res.ca, choice = "row", axes = 1, top = 10,
  fill  = "#1E88E5", color = "#1565C0",
  title = "Row Contributions — Dimension 1"
) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 30, hjust = 1))

save_plot(p_row_contrib, "03_row_contrib_dim1.png", width = 7, height = 5)

# =============================================================================
# PLOT 4: Column Contributions to Dimension 1
# =============================================================================

p_col_contrib <- fviz_contrib(
  res.ca, choice = "col", axes = 1, top = 10,
  fill  = "#E53935", color = "#B71C1C",
  title = "Column Contributions — Dimension 1"
) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 30, hjust = 1))

save_plot(p_col_contrib, "04_col_contrib_dim1.png", width = 7, height = 5)

# =============================================================================
# PLOT 5: Hierarchical Clustering Dendrogram
# =============================================================================

p_dend <- fviz_dend(
  hc,
  k           = N_CLUSTERS,
  cex         = 0.9,
  rect        = TRUE,
  rect_fill   = TRUE,
  rect_border = PALETTE_CLUSTER,
  k_colors    = PALETTE_CLUSTER,
  main        = "Dendrogram — Health Status Hierarchical Clustering",
  xlab        = "Health Status Category",
  ylab        = "Ward Distance"
) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

save_plot(p_dend, "05_dendrogram.png", width = 9, height = 6)

# =============================================================================
# PLOT 6: Cluster Map on CA Dimensions
# =============================================================================

p_clusters <- ggplot(row_coords_clustered,
    aes(x = Dim.1, y = Dim.2, color = Cluster, label = Label)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "#BDBDBD") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "#BDBDBD") +
  geom_point(size = 5, alpha = 0.9) +
  ggrepel::geom_text_repel(
    size        = 4.5,
    fontface    = "bold",
    show.legend = FALSE,
    box.padding = 0.4
  ) +
  scale_color_manual(
    values = PALETTE_CLUSTER,
    labels = c("Cluster 1: Excellent/Very Good",
               "Cluster 2: Good/Fair",
               "Cluster 3: Poor")
  ) +
  labs(
    title  = "Health Status Clusters on CA Dimensions",
    x      = paste0("Dimension 1 (", round(res.ca$eig[1, 2], 1), "%)"),
    y      = paste0("Dimension 2 (", round(res.ca$eig[2, 2], 1), "%)"),
    color  = "Cluster"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title      = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.position = "bottom",
    legend.title    = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

# ggrepel is optional — fall back gracefully
if (!requireNamespace("ggrepel", quietly = TRUE)) {
  p_clusters <- p_clusters +
    geom_text(vjust = -0.7, hjust = 0.5, size = 4, fontface = "bold")
}

save_plot(p_clusters, "06_cluster_map.png", width = 8, height = 6)

# =============================================================================
# PLOT 7: Mosaic Plot — Exercise × General Health
# =============================================================================

png("outputs/07_mosaic_exercise_health.png", width = 800, height = 600)
exer_hlth <- table(df$exerany, df$genhlth)
mosaicplot(
  exer_hlth,
  main  = "Exercise Participation × Self-Rated General Health",
  ylab  = "Self-Rated General Health",
  xlab  = "Exercise in the Past Month (0 = No, 1 = Yes)",
  las   = 2,
  color = c("#E3F2FD", "#1565C0"),
  cex.axis = 0.9
)
dev.off()
message("  Saved: outputs/07_mosaic_exercise_health.png")

# =============================================================================
# PLOT 8: Cos² Map — Quality of Representation
# =============================================================================

p_cos2_row <- fviz_cos2(
  res.ca, choice = "row", axes = 1:2,
  fill  = "#7B1FA2", color = "#4A148C",
  title = "Row Cos² — Quality of Representation on Dims 1–2"
) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 30, hjust = 1))

save_plot(p_cos2_row, "08_cos2_rows.png", width = 7, height = 5)

cat("\n✅ All visualizations saved to outputs/\n")
