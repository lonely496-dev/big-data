# Methodology

## Correspondence Analysis (CA)

Correspondence analysis is a multivariate technique for visualizing the associations in a two-way contingency table. It maps row and column categories into a low-dimensional space such that similar profiles appear close together.

### Row and Column Profiles

Given a contingency table **N** with grand total *n*, the **row profile** for row *i* is:

$$\mathbf{r}_i = \left(\frac{n_{i1}}{n_{i\cdot}}, \frac{n_{i2}}{n_{i\cdot}}, \ldots \right), \quad n_{i\cdot} = \sum_j n_{ij}$$

The **column profile** for column *j* is:

$$\mathbf{c}_j = \left(\frac{n_{1j}}{n_{\cdot j}}, \frac{n_{2j}}{n_{\cdot j}}, \ldots \right), \quad n_{\cdot j} = \sum_i n_{ij}$$

### Chi-Squared Distance

The chi-squared distance between two row profiles measures how differently they distribute across column categories, weighted by column marginals:

$$d^2(i, i') = \sum_j \frac{\left(\frac{n_{ij}}{n_{i\cdot}} - \frac{n_{i'j}}{n_{i'\cdot}}\right)^2}{n_{\cdot j}/n}$$

### Singular Value Decomposition

CA decomposes the standardized residual matrix via SVD:

$$\mathbf{S} = \mathbf{D}_r^{-1/2} \left(\frac{\mathbf{N}}{n} - \mathbf{r}\mathbf{c}^T\right) \mathbf{D}_c^{-1/2} = \mathbf{U} \boldsymbol{\Lambda} \mathbf{V}^T$$

where **D**_r and **D**_c are diagonal matrices of row and column masses.

### Inertia and Explained Variance

Total inertia equals the chi-squared statistic divided by *n*:

$$\phi^2 = \frac{\chi^2}{n} = \sum_k \lambda_k^2$$

Each dimension *k* explains a fraction $\lambda_k^2 / \phi^2$ of total inertia.

### Quality of Representation (cos²)

The cos² value for a category on dimension *k* is the squared cosine of the angle between the category's vector and the *k*-th axis. Values close to 1 indicate the category is well-represented on that dimension.

---

## Hierarchical Clustering on CA Coordinates

After obtaining CA coordinates, categories are clustered using:

1. **Distance metric:** Euclidean distance on the first 2 CA dimensions
2. **Linkage criterion:** Ward's method — minimizes total within-cluster variance

$$\Delta(A, B) = \frac{|A||B|}{|A|+|B|} \|\bar{\mathbf{x}}_A - \bar{\mathbf{x}}_B\|^2$$

3. **Cluster count:** *k = 3*, selected based on the dendrogram's height jumps

---

## Implementation Notes

- All CA computations use `FactoMineR::CA()`.
- Supplementary points (very low frequency categories) do not contribute to dimension construction but are projected onto the CA space.
- The `dimdesc()` function identifies categories most correlated with each dimension via Pearson correlation.
