# User Guide

## Overview

This framework provides quantitative tools for measuring evolutionary integration across biological systems.

## Installation

### Prerequisites
- R >= 4.0
- RStudio (recommended)

### Install Required Packages

```r
install.packages(c(
  "ggplot2",    # Visualization
  "dplyr",      # Data manipulation
  "igraph",     # Network analysis
  "ape",        # Phylogenetic analysis
  "vegan",      # Diversity metrics
  "cluster",    # Clustering
  "segmented",  # Threshold detection
  "boot"        # Bootstrap validation
))
```

## Quick Start

1. Clone the repository
2. Source the metric functions
3. Load your data
4. Calculate metrics

See `examples/quick_start.R` for a working example.

## Core Metrics

### Integration Index (I)
Measures overall system cohesion using Shannon entropy of interaction networks.
- Range: 0 (no integration) to 1 (complete integration)
- Script: `code/metrics/integration_index.R`

### Cohesion Coefficient (C)
Quantifies physiological/developmental interdependence.
- Range: 0 (independent) to 1 (inseparable)
- **Threshold**: C ≈ 0.73 marks irreversible transitions
- Script: `code/metrics/cohesion_coefficient.R`

### Modular Independence (M)
Detects decomposable structure using community detection.
- Range: 0 (no modules) to 1 (highly modular)
- Script: `code/metrics/modular_independence.R`

### Emergent Complexity (E)
Quantifies non-additive system properties.
- Range: 0 (additive) to 1 (highly emergent)
- Script: `code/metrics/emergent_complexity.R`

### Hierarchical Coherence (H)
Evaluates level of selection.
- Range: 0 (individual selection) to 1 (group selection)
- Script: `code/metrics/hierarchical_coherence.R`

## Data Format

Your data should include:
- Network adjacency matrices (for I, M)
- Component viability data (for C)
- Component state distributions (for E)
- Fitness data at multiple levels (for H)

## Threshold Analysis

The universal threshold (κ ≈ 0.73) can be detected using:

```r
source("code/analysis/threshold_detection.R")
result <- detect_threshold(your_data)
```

## Citation

Please cite: Adeyemi, S. (2026). Quantifying Individuality: A Mathematical Framework for Measuring Evolutionary Integration Across Biological Systems. *PNAS* (submitted).

## Support

- Issues: Open a GitHub issue
- Contact: [@SamAde1203](https://github.com/SamAde1203)
