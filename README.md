# Quantifying Individuality: A Mathematical Framework for Evolutionary Integration

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-%3E%3D4.0-blue.svg)](https://www.r-project.org/)

## Overview

Mathematical framework for measuring evolutionary integration across biological systems.

**Manuscript**: "Quantifying Individuality: A Mathematical Framework for Measuring Evolutionary Integration Across Biological Systems" by Sam Adeyemi (submitted to PNAS, February 2026)

### Key Findings
- **Universal Integration Threshold**: κ ≈ 0.73 separates reversible from irreversible transitions
- **127 Biological Systems** analyzed across 6 major evolutionary transitions
- **Four Core Metrics**: Integration Index (I), Cohesion (C), Modularity (M), Emergence (E)

## Quick Start

```r
# Install required packages
install.packages(c("ggplot2", "dplyr", "igraph", "ape"))

# Load functions
source("code/metrics/integration_index.R")

# Load example data
data <- read.csv("data/processed/integration_metrics.csv")
```

## Repository Structure

```
├── data/          # 127 systems dataset
├── code/          # R scripts for all metrics
├── figures/       # Publication figures
├── docs/          # Documentation
└── examples/      # Example workflows
```

## Citation

```bibtex
@article{adeyemi2026quantifying,
  title={Quantifying Individuality: A Mathematical Framework for Measuring Evolutionary Integration Across Biological Systems},
  author={Adeyemi, Sam},
  journal={Proceedings of the National Academy of Sciences},
  year={2026},
  note={Submitted}
}
```

## Installation

### Prerequisites
- R >= 4.0
- RStudio (recommended)

### Required R Packages
```r
install.packages(c("ggplot2", "dplyr", "igraph", "ape", "vegan", "cluster", "segmented", "boot"))
```

## Documentation

- [User Guide](docs/user_guide.md) - Complete usage instructions
- [Examples](examples/) - Example workflows

## License

MIT License - see LICENSE file

## Contact

Sam Adeyemi  
GitHub: [@SamAde1203](https://github.com/SamAde1203)

## Status

**Manuscript submitted to PNAS**: February 2026  
**Code release**: Upon manuscript acceptance
