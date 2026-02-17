# Evolutionary Integration Framework

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXXXX.svg)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## A Mathematical Framework for Measuring Evolutionary Integration Across Biological Systems

**Authors:** [Your Name], [Institution/Affiliation]  
**Contact:** [your.email@institution.edu]  
**Preprint:** [Link to bioRxiv/arXiv preprint]  
**Publication:** [Journal name, year, DOI - update upon acceptance]

---

## Overview

This repository contains data, code, and supplementary materials for our manuscript:

> **"Quantifying Individuality: A Mathematical Framework for Measuring Evolutionary Integration Across Biological Systems"**

We present a comprehensive mathematical framework for quantifying the degree of integration in biological systems undergoing evolutionary transitions in individuality (ETIs). The framework introduces four core metrics that collectively capture structural, functional, and evolutionary dimensions of biological individuality.

### Key Contributions

1. **Four Core Metrics** for measuring integration:
   - **Integration Index (I)**: Overall system cohesion
   - **Inseparability Coefficient (κ)**: Component interdependence
   - **Functional Specialisation (φ)**: Division of labour
   - **Hierarchical Coherence (H)**: Level of selection

2. **Field-Defining Empirical Protocol**: Three-tiered measurement system (Gold Standard → Validated Proxies → Minimal Data) with explicit precision estimates

3. **Critical Threshold Discovery**: Systems with κ ≥ 0.73 exhibit irreversible integration and accelerated complexity evolution

4. **Game-Theoretic Grounding**: Connection between integration metrics and evolutionary game theory (Stag Hunt, Snowdrift, Multi-level Selection)

5. **Broad Validation**: Analysis of 127 biological systems across 6 major transitions

---

## Repository Structure

```
evolutionary-integration-framework/
│
├── data/
│   ├── systems_dataset.csv              # 127 biological systems with all metrics
│   ├── volvocine_algae_casestudy.csv    # Detailed data for Case Study 1
│   ├── social_insects_casestudy.csv     # Detailed data for Case Study 2
│   ├── endosymbionts_casestudy.csv      # Detailed data for Case Study 3
│   └── data_dictionary.md               # Variable definitions and units
│
├── code/
│   ├── calculate_metrics.R              # Functions to compute I, κ, φ, H from raw data
│   ├── tier1_gold_standard.R            # Tier 1 measurement protocols
│   ├── tier2_validated_proxies.R        # Tier 2 measurement protocols
│   ├── tier3_minimal_data.R             # Tier 3 measurement protocols
│   ├── threshold_analysis.R             # Segmented regression & validation
│   ├── bootstrap_validation.R           # Bootstrap and LOOCV code
│   ├── generate_figures.R               # Code to reproduce all 7 figures + Supp Fig
│   ├── statistical_analyses.R           # PCA, clustering, SEM, PGLS
│   └── game_theoretic_simulations.py    # Agent-based models for game theory section
│
├── figures/
│   ├── figure1_pca_biplot.png           # Principal component analysis
│   ├── figure2_clustering_dendrogram.png
│   ├── figure3_threshold_plots.png
│   ├── figure4_hierarchical_coherence.png
│   ├── figure5_volvocine_casestudy.png
│   ├── figure6_social_insects.png
│   ├── figure7_predictive_power.png
│   └── figureS1_bootstrap_validation.png
│
├── tables/
│   ├── Table1_Notation_Conventions.csv
│   ├── Table2_System_Summary.csv
│   └── TableS1_Threshold_Validation.csv
│
├── supplementary/
│   ├── supplementary_methods.md         # Extended measurement protocols
│   ├── supplementary_results.md         # Additional analyses
│   ├── phylogenetic_trees/              # Newick format trees for PGLS
│   └── literature_data_sources.xlsx     # Source references for each system
│
├── docs/
│   ├── manuscript.pdf                   # Preprint/accepted manuscript
│   ├── tutorial_basic_usage.md          # Quick start guide
│   ├── tutorial_advanced.md             # Advanced analyses
│   └── FAQ.md                           # Frequently asked questions
│
├── LICENSE                              # MIT License
├── CITATION.cff                         # Citation metadata
├── CONTRIBUTING.md                      # Contribution guidelines
├── CODE_OF_CONDUCT.md                   # Community standards
└── README.md                            # This file
```

---

## Quick Start

### Installation

#### R Dependencies
```r
install.packages(c(
  "tidyverse",      # Data manipulation
  "ggplot2",        # Plotting
  "igraph",         # Network analysis
  "segmented",      # Threshold detection
  "boot",           # Bootstrap validation
  "ape",            # Phylogenetic comparative methods
  "lavaan",         # Structural equation modeling
  "cluster",        # Hierarchical clustering
  "vegan"           # Community detection
))
```

#### Python Dependencies
```bash
pip install numpy pandas matplotlib scipy networkx mesa
```

### Basic Usage

#### 1. Calculate Integration Metrics

```r
source("code/calculate_metrics.R")

# Load your network data
network_data <- read.csv("your_interaction_network.csv")

# Calculate all four metrics
results <- calculate_integration_metrics(
  network = network_data,
  viability_data = your_viability_data,
  specialization_data = your_specialization_data,
  fitness_data = your_fitness_data
)

# View results
print(results)
#   I     κ     φ     H     CIS
# 0.72  0.68  0.75  0.70  0.71
```

#### 2. Determine Appropriate Measurement Tier

```r
source("code/tier1_gold_standard.R")
source("code/tier2_validated_proxies.R")
source("code/tier3_minimal_data.R")

# Check data availability
tier <- determine_measurement_tier(
  has_perturbation_data = FALSE,
  has_coexpression_data = TRUE,
  has_network_topology = TRUE
)

# Use appropriate tier
if (tier == "Tier2") {
  results <- calculate_tier2_metrics(your_data)
}
```

#### 3. Test for Threshold Behavior

```r
source("code/threshold_analysis.R")

# Test if your systems exhibit threshold dynamics
threshold_result <- test_threshold(
  integration_values = your_kappa_values,
  complexity_values = your_complexity_values
)

# Bootstrap validation
bootstrap_threshold <- validate_threshold_bootstrap(
  data = your_data,
  n_iterations = 5000
)
```

---

## Core Metrics Explained

### Integration Index (I)

**Definition:** Quantifies overall system cohesion by comparing observed interaction patterns to a null model of independence.

**Formula:**
```
I = 1 - (H_observed / H_max)
```
where H is Shannon entropy of the interaction network.

**Interpretation:**
- I = 0: Random, independent interactions (no integration)
- I = 1: Complete integration (highly structured interactions)
- I ≥ 0.70: Threshold for irreversible transitions

**Data Requirements:**
- **Tier 1:** Perturbation experiments (CRISPR knockouts, ablations)
- **Tier 2:** Co-expression networks, activity synchrony
- **Tier 3:** Network topology only

---

### Inseparability Coefficient (κ)

**Definition:** Measures physiological/developmental interdependence—the extent to which components cannot survive independently.

**Formula:**
```
κ = (1/n) Σ [1 - V_i]
```
where V_i is viability of component i when isolated.

**Interpretation:**
- κ = 0: Components fully viable independently
- κ = 1: Complete dependence (no independent viability)
- **κ ≥ 0.73: Critical threshold** for irreversibility

**Data Requirements:**
- **Tier 1:** Separation experiments (fitness costs measured)
- **Tier 2:** Network betweenness centrality proxies
- **Tier 3:** Qualitative obligate vs. facultative classification

---

### Functional Specialisation (φ)

**Definition:** Assesses division of labour and irreversibility of specialized roles.

**Formula:**
```
φ = α·φ_behavioral + (1-α)·φ_developmental
```

**Interpretation:**
- φ = 0: Complete generalism (all components perform all functions)
- φ = 1: Complete specialization (irreversible roles)
- φ shows continuous variation (no threshold)

**Data Requirements:**
- **Tier 1:** Behavioral repertoires + developmental plasticity experiments
- **Tier 2:** Task allocation observations, caste polymorphism
- **Tier 3:** Presence/absence of distinct morphological castes

---

### Hierarchical Coherence (H)

**Definition:** Evaluates the extent to which natural selection operates at the collective level vs. component level.

**Formula:**
```
H = Var_between / (Var_between + Var_within)
```

**Interpretation:**
- H = 0: Selection acts entirely on components
- H = 1: Selection acts exclusively at collective level
- H increases with system age (r = 0.71, p < 0.001)

**Data Requirements:**
- **Tier 1:** Multi-generation fitness data for collectives and components
- **Tier 2:** Phylogenetic signal in collective-level traits
- **Tier 3:** Presence of collective-level adaptations

---

## Key Findings

### 1. Critical Integration Threshold

Systems with **κ ≥ 0.73** exhibit:
- **Irreversible integration** (2.4% reversion rate vs. 41% below threshold)
- **Accelerated complexity evolution** (slope increases from 0.34 to 2.87)
- **Qualitatively different evolutionary dynamics**

Validated through:
- Leave-one-out cross-validation (LOOCV mean = 0.698, SE = 0.024)
- Bootstrap resampling (5,000 iterations, mean = 0.703, SE = 0.019)

### 2. Two-Dimensional Integration Space

PCA reveals integration has two semi-independent axes:
1. **Structural Integration** (PC1, 52.1% variance): κ and φ
2. **Evolutionary Integration** (PC2, 24.2% variance): I and H

Implication: Systems can have strong structural integration before evolutionary integration emerges (and vice versa).

### 3. Five System Classes

Hierarchical clustering identifies:
1. Minimally integrated collectives (n=23, CIS < 0.30)
2. Cooperatively integrated groups (n=31, CIS = 0.40-0.60)
3. Structurally integrated, evolutionarily nascent (n=28)
4. Evolutionarily integrated, structurally moderate (n=19)
5. Fully integrated individuals (n=26, CIS > 0.75)

### 4. Strong Predictive Power

Composite Integration Score (CIS) predicts:
- **Organismal complexity**: R² = 0.89
- **Evolvability** (diversification rate): R² = 0.58
- **Robustness** (resistance to perturbation): R² = 0.71
- **Developmental stability**: R² = 0.52

### 5. Game-Theoretic Foundations

Each metric corresponds to resolution of specific evolutionary conflicts:

| Metric | Game | Resolution State |
|--------|------|------------------|
| **I > 0.70** | Stag Hunt | Cooperation as focal equilibrium |
| **C > 0.75** | Snowdrift | Defection prohibitively costly |
| **M = 0.3-0.6** | Multi-level Selection | Between-group > within-group |
| **E > 0.65** | Coordination | Comparative advantage realized |

---

## Case Studies

### Case Study 1: Volvocine Algae (Unicellular → Multicellular)

**Systems:** 12 species from *Chlamydomonas reinhardtii* (solitary) to *Volvox carteri* (2,000-cell spheroids)

**Key Findings:**
- *C. reinhardtii*: CIS = 0.054 (minimal integration)
- *Gonium pectorale* (16 cells): CIS = 0.28 (intermediate)
- *Volvox carteri*: CIS = 0.85 (fully integrated)
- κ = 0.89 > 0.73 threshold (irreversible germ-soma separation)

**Data Available:** `data/volvocine_algae_casestudy.csv`

### Case Study 2: Social Insects (Solitary → Eusocial)

**Systems:** 42 species across eusociality gradient

**Key Findings:**
- *Polistes dominula* (primitively eusocial): CIS = 0.55
- *Apis mellifera* (highly eusocial): CIS = 0.89
- κ predicts colony-level traits:
  - Colony size: r = 0.76
  - Number of castes: r = 0.82
  - Queen-worker dimorphism: r = 0.71

**Data Available:** `data/social_insects_casestudy.csv`

### Case Study 3: Endosymbiotic Organelles (Free-living → Obligate)

**Systems:** 15 endosymbiotic systems from recent (facultative) to ancient (mitochondria)

**Key Findings:**
- Mitochondria: CIS = 0.94 (near-complete integration)
- *Buchnera aphidicola* (150 Mya): κ = 0.94, H = 0.72
- *Wolbachia* (facultative): κ = 0.41, H = 0.38
- Full hierarchical coherence requires hundreds of millions of years

**Data Available:** `data/endosymbionts_casestudy.csv`

---

## Data Dictionary

Full data dictionary available in `data/data_dictionary.md`.

**Primary Dataset** (`systems_dataset.csv`):

| Column | Type | Description | Range | Units |
|--------|------|-------------|-------|-------|
| `system_id` | string | Unique identifier | — | — |
| `system_name` | string | Species/system name | — | — |
| `transition_type` | categorical | Major transition category | 1-6 | — |
| `I` | numeric | Integration Index | [0, 1] | dimensionless |
| `kappa` | numeric | Inseparability Coefficient | [0, 1] | dimensionless |
| `phi` | numeric | Functional Specialisation | [0, 1] | dimensionless |
| `H` | numeric | Hierarchical Coherence | [0, 1] | dimensionless |
| `CIS` | numeric | Composite Integration Score | [0, 1] | dimensionless |
| `complexity` | integer | Cell/caste type count | ≥ 1 | types |
| `system_age_mya` | numeric | Divergence time | ≥ 0 | millions of years |
| `n_components` | integer | System size | ≥ 2 | individuals/cells |

---

## Citation

If you use this framework in your research, please cite:

```bibtex
@article{YourName2026integration,
  title={Quantifying Individuality: A Mathematical Framework for Measuring Evolutionary Integration Across Biological Systems},
  author={Your Name and Collaborators},
  journal={Journal Name},
  year={2026},
  volume={XX},
  pages={XXX--XXX},
  doi={10.XXXX/journal.XXXXXXX}
}
```

**APA Format:**
Your Name. (2026). Quantifying individuality: A mathematical framework for measuring evolutionary integration across biological systems. *Journal Name, XX*(X), XXX-XXX. https://doi.org/10.XXXX/journal.XXXXXXX

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Ways to contribute:**
- Report bugs or issues
- Suggest new features or metrics
- Add validation datasets for new systems
- Improve documentation
- Share case studies using the framework

---

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

**Summary:** You are free to use, modify, and distribute this code/data with attribution.

---

## Support & Contact

- **Issues:** [GitHub Issues](https://github.com/yourusername/evolutionary-integration-framework/issues)
- **Email:** your.email@institution.edu
- **Twitter:** [@yourhandle](https://twitter.com/yourhandle)
- **Lab Website:** [https://yourlab.institution.edu](https://yourlab.institution.edu)

---

## Acknowledgments

We thank the Alpha Wings AI community for computational support, reviewers for constructive feedback, and all researchers whose data contributed to this study.

**Funding:** [Grant information, if applicable]

---

## Frequently Asked Questions

**Q: Which measurement tier should I use?**  
A: Use the highest tier feasible for your system. Tier 1 provides highest precision (±0.05-0.12), Tier 2 is validated for most cases (±0.09-0.18), Tier 3 is for hypothesis generation only (±0.25-0.35).

**Q: Can I apply this to non-biological systems?**  
A: The metrics were developed for biological ETIs. Application to other domains (AI, organizations) requires careful validation and may need adaptation.

**Q: What sample size do I need?**  
A: Minimum n ≥ 20 systems for threshold detection, n ≥ 50 for robust predictive models. Case studies can use smaller samples for qualitative classification.

**Q: How do I handle missing data?**  
A: Use Tier 2 or Tier 3 proxies. See `supplementary/supplementary_methods.md` for imputation strategies. Report which tier was used for each metric.

**Q: Is the κ = 0.73 threshold universal?**  
A: It's robustly validated across diverse systems in our dataset, but may vary slightly in novel contexts. We recommend bootstrap validation for new datasets.

See [docs/FAQ.md](docs/FAQ.md) for more questions.

---

## Version History

- **v1.0.0** (2026-02-XX): Initial release with manuscript publication
- Preprint: bioRxiv [DOI] (2026-02-XX)

---

**Repository maintained by:** [Your Name]  
**Last updated:** February 2026
