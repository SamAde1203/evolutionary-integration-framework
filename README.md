# Quantifying Individuality: A Mathematical Framework for Evolutionary Integration

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18674564.svg)](https://doi.org/10.5281/zenodo.18674564)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-%3E%3D4.0-blue.svg)](https://www.r-project.org/)

## Overview

**Manuscript submitted to PNAS (February 17, 2026)**

Mathematical framework with **five metrics** (I, C, M, E, H) for quantifying evolutionary integration across biological systems.

### Key Findings
- **Universal Integration Threshold**: **κ ≈ 0.73** (68% vs 10% reversibility)
- **127 Biological Systems** analyzed across 6 major evolutionary transitions
- **Complete R Implementation** with validation scripts
- **Tiered Measurement Protocols** (gold-standard to proxy)

## Quick Start

```r
# Install packages
install.packages(c("ggplot2", "dplyr", "igraph", "ape", "segmented"))

# Load framework
source("code/metrics/integration_index.R")
source("code/metrics/cohesion_coefficient.R")

# Load 127-system dataset
data <- read.csv("data/processed/integration_metrics.csv")

# Calculate metrics for your network
my_network <- matrix(c(0,1,1,0,1,0,1,1,1,1,0,1,0,1,1,0), nrow=4)
integration <- calculate_integration_index(my_network)
cohesion <- calculate_cohesion_coefficient(your_viability_data)

# Detect threshold
source("code/analysis/threshold_detection.R")
threshold_result <- detect_threshold(data)
print(threshold_result$threshold)  # ≈ 0.73
Repository Structure
text
├── data/processed/integration_metrics.csv    # 127 systems dataset
├── code/metrics/*.R                          # 5 core metrics
├── code/analysis/threshold_detection.R       # κ ≈ 0.73 detection
├── examples/quick_start.R                    # Working examples
├── docs/user_guide.md                        # Complete documentation
├── CITATION.cff                              # Citation info
└── README.md                                 # You're reading it!
Files Included
Category	Files	Description
Data	integration_metrics.csv	127 systems with I, C, M, E, H
Metrics	5 .R scripts	Complete implementations
Analysis	threshold_detection.R	Segmented regression + validation
Examples	quick_start.R	Run in 2 minutes
Installation
Prerequisites
R ≥ 4.0

RStudio (recommended)

Required Packages
r
install.packages(c(
  "ggplot2",      # Visualization
  "dplyr",        # Data manipulation
  "igraph",       # Network analysis
  "ape",          # Phylogenetics
  "vegan",        # Diversity
  "cluster",      # Clustering
  "segmented",    # Thresholds
  "boot"          # Validation
))
Documentation
User Guide - Complete instructions

Data README - 127 systems details

CITATION.cff - Cite this work

quick_start.R - Run examples

Citation
Repository:

text
@software{adeyemi2026evolutionary,
  author = {Adeyemi, Sam},
  doi = {10.5281/zenodo.18674564},
  month = {2},
  title = {Evolutionary Integration Framework},
  url = {https://github.com/SamAde1203/evolutionary-integration-framework},
  year = {2026}
}
Manuscript:

text
@article{adeyemi2026quantifying,
  title = {Quantifying Individuality: A Mathematical Framework for Measuring Evolutionary Integration Across Biological Systems},
  author = {Adeyemi, Sam},
  journal = {Proceedings of the National Academy of Sciences},
  year = {2026},
  note = {Submitted}
}
License
MIT License - see LICENSE file.

Contact
Sam Adeyemi
GitHub: @SamAde1203
DOI: 10.5281/zenodo.18674564
