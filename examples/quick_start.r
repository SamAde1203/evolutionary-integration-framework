# Quick Start Example
# Demonstrates basic usage of the evolutionary integration framework
# Part of: Evolutionary Integration Framework
# Author: Sam Adeyemi

# ============================================================================
# SETUP
# ============================================================================

# Install required packages (run once)
# install.packages(c("ggplot2", "dplyr", "igraph", "segmented"))

# Load libraries
library(ggplot2)
library(dplyr)
library(igraph)

# Load framework functions
source("code/metrics/integration_index.R")
source("code/metrics/cohesion_coefficient.R")
source("code/metrics/modular_independence.R")
source("code/metrics/emergent_complexity.R")
source("code/metrics/hierarchical_coherence.R")
source("code/analysis/threshold_detection.R")

cat("\n")
cat("=============================================================================\n")
cat("EVOLUTIONARY INTEGRATION FRAMEWORK - QUICK START\n")
cat("=============================================================================\n\n")

# ============================================================================
# EXAMPLE 1: CALCULATE INTEGRATION FOR A SIMPLE NETWORK
# ============================================================================

cat("EXAMPLE 1: Simple 5-node interaction network\n")
cat("-----------------------------------------------------------------------------\n")

# Create example adjacency matrix (5 nodes)
example_network <- matrix(c(
  0, 1, 1, 0, 0,
  1, 0, 1, 1, 0,
  1, 1, 0, 1, 1,
  0, 1, 1, 0, 1,
  0, 0, 1, 1, 0
), nrow = 5, byrow = TRUE)

# Calculate Integration Index
I_result <- calculate_integration_index(example_network)
cat("Integration Index (I):", round(I_result$I, 3), "\n")
cat("  - Shannon Entropy:", round(I_result$H_observed, 3), "\n")
cat("  - Connectivity:", round(I_result$connectivity, 3), "\n")

# Calculate Modular Independence
M_result <- calculate_modular_independence(example_network)
cat("\nModular Independence (M):", round(M_result$M, 3), "\n")
cat("  - Number of communities:", M_result$n_communities, "\n")
cat("  - Modularity Q:", round(M_result$modularity_Q, 3), "\n")

# ============================================================================
# EXAMPLE 2: CALCULATE COHESION FROM VIABILITY DATA
# ============================================================================

cat("\n")
cat("EXAMPLE 2: Cohesion from viability measurements\n")
cat("-----------------------------------------------------------------------------\n")

# Create example viability data
viability_data <- data.frame(
  component_id = paste0("Cell", 1:5),
  viability_isolated = c(0.15, 0.20, 0.10, 0.25, 0.18),
  viability_integrated = c(0.95, 0.98, 0.92, 0.97, 0.96)
)

# Calculate Cohesion Coefficient
C_result <- calculate_cohesion_coefficient(viability_data)
cat("Cohesion Coefficient (C):", round(C_result$C, 3), "\n")
cat("  - Standard deviation:", round(C_result$C_sd, 3), "\n")
cat("  - High cohesion components:", 
    round(C_result$high_cohesion_proportion * 100, 1), "%\n")

# ============================================================================
# EXAMPLE 3: DETECT THRESHOLD IN REAL DATA
# ============================================================================

cat("\n")
cat("EXAMPLE 3: Threshold detection (if data file exists)\n")
cat("-----------------------------------------------------------------------------\n")

# Try to load full dataset
if (file.exists("data/processed/integration_metrics.csv")) {
  data <- read.csv("data/processed/integration_metrics.csv")

  cat("Loaded", nrow(data), "biological systems\n\n")

  # Detect threshold
  threshold_result <- detect_threshold(data, 
                                       cohesion_var = "Cohesion_Coefficient_C",
                                       outcome_var = "Reversible")

  cat("Detected Integration Threshold (κ):", round(threshold_result$threshold, 3), "\n")
  cat("  - 95% CI: [", round(threshold_result$ci_lower, 3), ",", 
      round(threshold_result$ci_upper, 3), "]\n")
  cat("  - R² improvement:", round(threshold_result$r2_improvement, 3), "\n")

  # Summary statistics by transition type
  cat("\n")
  cat("Summary by Transition Type:\n")
  cat("-----------------------------------------------------------------------------\n")
  summary_stats <- data %>%
    group_by(Transition_Type) %>%
    summarise(
      n = n(),
      mean_C = mean(Cohesion_Coefficient_C, na.rm = TRUE),
      mean_I = mean(Integration_Index_I, na.rm = TRUE),
      prop_reversible = mean(Reversible, na.rm = TRUE)
    )
  print(summary_stats, n = Inf)

} else {
  cat("Data file not found. Skipping threshold detection.\n")
  cat("To run this example, ensure data/processed/integration_metrics.csv exists.\n")
}

# ============================================================================
# EXAMPLE 4: COMPARE HIGH VS LOW INTEGRATION SYSTEMS
# ============================================================================

cat("\n")
cat("EXAMPLE 4: Contrasting high vs low integration\n")
cat("-----------------------------------------------------------------------------\n")

# High integration network (densely connected)
high_integration_net <- matrix(1, nrow = 6, ncol = 6)
diag(high_integration_net) <- 0
high_integration_net[1, 6] <- 0
high_integration_net[6, 1] <- 0

# Low integration network (sparse, modular)
low_integration_net <- matrix(0, nrow = 6, ncol = 6)
low_integration_net[1:3, 1:3] <- 1
low_integration_net[4:6, 4:6] <- 1
diag(low_integration_net) <- 0

# Calculate metrics
high_I <- calculate_integration_index(high_integration_net)
low_I <- calculate_integration_index(low_integration_net)

high_M <- calculate_modular_independence(high_integration_net)
low_M <- calculate_modular_independence(low_integration_net)

cat("High Integration System:\n")
cat("  I =", round(high_I$I, 3), "| M =", round(high_M$M, 3), "\n")

cat("Low Integration System:\n")
cat("  I =", round(low_I$I, 3), "| M =", round(low_M$M, 3), "\n")

cat("\n")
cat("Note: High integration → High I, Low M\n")
cat("      Low integration → Low I, High M\n")

# ============================================================================
# SUMMARY
# ============================================================================

cat("\n")
cat("=============================================================================\n")
cat("SUMMARY\n")
cat("=============================================================================\n\n")

cat("You've learned how to:\n")
cat("  ✓ Calculate Integration Index (I) from network data\n")
cat("  ✓ Calculate Cohesion Coefficient (C) from viability data\n")
cat("  ✓ Calculate Modular Independence (M) using community detection\n")
cat("  ✓ Detect integration threshold (κ ≈ 0.73)\n")
cat("  ✓ Compare systems with different integration levels\n\n")

cat("Next steps:\n")
cat("  • See docs/user_guide.md for complete documentation\n")
cat("  • Explore code/metrics/ for detailed metric implementations\n")
cat("  • Run code/analysis/threshold_detection.R on your own data\n")
cat("  • Check examples/ folder for more advanced analyses\n\n")

cat("Questions or issues? GitHub: https://github.com/SamAde1203/evolutionary-integration-framework\n\n")

cat("=============================================================================\n")
