# 🏥 Health Behavior Correspondence Analysis

<div align="center">

![R](https://img.shields.io/badge/R-4.3%2B-276DC3?style=for-the-badge&logo=r&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)
![Contributions](https://img.shields.io/badge/Contributions-Welcome-orange?style=for-the-badge)

**Exploring the relationship between self-reported health status, exercise habits, and smoking behavior using Correspondence Analysis and Hierarchical Clustering.**

[📖 Documentation](#documentation) • [🚀 Quick Start](#quick-start) • [📊 Results](#results) • [🤝 Contributing](#contributing)

</div>

---

## 📌 Overview

This project applies **Correspondence Analysis (CA)** and **Hierarchical Clustering on Principal Components (HCPC)** to a CDC health survey dataset. The goal is to uncover associations between self-rated general health and behavioral/demographic variables — including exercise participation, smoking history, health plan coverage, and gender.

By transforming frequency tables into geometric representations, CA reveals which behavioral profiles are most closely linked to positive or negative health outcomes.

---

## 🗂️ Repository Structure

```
health-ca-analysis/
│
├── R/
│   ├── 01_data_preparation.R       # Load, clean, and encode variables
│   ├── 02_contingency_table.R      # Build multi-column indicator table
│   ├── 03_correspondence_analysis.R# Run CA and extract coordinates
│   ├── 04_clustering.R             # HCPC: hierarchical clustering on CA dims
│   ├── 05_visualizations.R         # All plots: biplot, dendrogram, mosaic
│   └── utils.R                     # Shared helper functions
│
├── data/
│   └── README.md                   # Data source and variable descriptions
│
├── outputs/
│   └── README.md                   # Placeholder — generated plots saved here
│
├── docs/
│   └── methodology.md              # Statistical background and formulas
│
├── tests/
│   └── test_pipeline.R             # Unit tests for data prep & CA functions
│
├── main.R                          # Entry point — runs full pipeline
├── DESCRIPTION                     # Project metadata (R package style)
└── README.md                       # This file
```

---

## 🚀 Quick Start

### Prerequisites

```r
install.packages(c("FactoMineR", "factoextra", "dplyr", "ggplot2", "testthat"))
```

### Run the Full Pipeline

```r
source("main.R")
```

Or run step-by-step:

```r
source("R/01_data_preparation.R")
source("R/02_contingency_table.R")
source("R/03_correspondence_analysis.R")
source("R/04_clustering.R")
source("R/05_visualizations.R")
```

### Input Data

Place your CDC dataset as `data/cdc.csv`. The file should contain at minimum:

| Column     | Type        | Description                              |
|------------|-------------|------------------------------------------|
| `genhlth`  | categorical | Self-rated general health (excellent–poor)|
| `exerany`  | binary      | Exercise in past month (0/1)             |
| `hlthplan` | binary      | Health plan coverage (0/1)               |
| `smoke100` | binary      | Smoked 100+ cigarettes (0/1)             |
| `gender`   | categorical | Respondent gender (m/f)                  |

---

## 📊 Results

### Dimension 1 — Health-Behavior Gradient

The first CA dimension explains the largest share of variance and arranges health categories along a behavioral gradient:

| Category         | Type   | Dim 1 Coordinate |
|------------------|--------|-----------------|
| excellent        | Row    | −0.1414         |
| very good        | Row    | −0.0735         |
| good             | Row    | 0.0762          |
| fair             | Row    | 0.2315          |
| poor             | Row    | 0.4011          |
| Yes_Exercise     | Column | −0.1346         |
| No_Smoke         | Column | −0.1158         |
| No_Exercise      | Column | 0.3948          |
| Yes_Smoke        | Column | 0.1296          |

**Key finding:** Exercise and non-smoking are co-located with better health; sedentary and smoking profiles cluster near fair/poor health.

### Cluster Summary

| Cluster | Health Categories        | Behavioral Profile            |
|---------|--------------------------|-------------------------------|
| 1       | Excellent, Very Good     | High exercise, low smoking    |
| 2       | Good, Fair               | Moderate exercise, mixed      |
| 3       | Poor                     | Low exercise, higher smoking  |

---

## 📐 Methodology

### Chi-Squared Distance

$$d^2(i, i') = \sum_j \frac{(n_{ij}/n_{i\cdot} - n_{i'j}/n_{i'\cdot})^2}{n_{\cdot j}/n}$$

### Row Profiles

$$\mathbf{r}_i = \left(\frac{n_{i1}}{n_{i\cdot}}, \frac{n_{i2}}{n_{i\cdot}}, \ldots\right)$$

### Column Profiles

$$\mathbf{c}_j = \left(\frac{n_{1j}}{n_{\cdot j}}, \frac{n_{2j}}{n_{\cdot j}}, \ldots\right)$$

See [`docs/methodology.md`](docs/methodology.md) for full derivations.

---

## 🔬 Features

- ✅ Modular R scripts — each step is independently runnable
- ✅ Custom multi-variable indicator table builder
- ✅ CA biplot with repel labels (no overlap)
- ✅ Hierarchical clustering on CA coordinates (Ward's method)
- ✅ Cluster-colored scatter plot on CA dimensions
- ✅ Mosaic plot for exercise × health contingency
- ✅ Dimension descriptions via `dimdesc()`
- ✅ Unit tests for data preparation and table construction
- ✅ Easily extensible to additional behavioral variables

---

## 📄 License

This project is licensed under the MIT License — see [`LICENSE`](LICENSE) for details.

---

## 📚 References

- Alhuzali, T., Beh, E. J., & Stojanovski, E. (2022). Multiple correspondence analysis as a tool for examining Nobel Prize data. *PLOS ONE*, 17(4).
- Žlahtič, B. et al. (2024). The role of correspondence analysis in medical research. *Frontiers in Public Health*, 12.
- Moussa, M. A. A., & Ouda, B. A. (2021). Correspondence analysis of contingency tables. *Computer Methods and Programs in Biomedicine*, 27(2), 111–119.
