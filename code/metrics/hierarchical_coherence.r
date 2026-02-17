# Hierarchical Coherence (H) - Calculation Script
# Evaluates level of selection using variance partitioning
# Part of: Evolutionary Integration Framework
# Author: Sam Adeyemi

#' Calculate Hierarchical Coherence
#'
#' Measures the relative strength of selection at the collective vs. component level
#' H = Var_between / (Var_between + Var_within)
#'
#' @param fitness_data Data frame with columns: collective_id, component_id, fitness
#' @return List containing Hierarchical Coherence (H) and variance components
#' @export

calculate_hierarchical_coherence <- function(fitness_data) {

  # Validate input
  if (!all(c("collective_id", "fitness") %in% names(fitness_data))) {
    stop("fitness_data must contain: collective_id, fitness")
  }

  # Calculate between-collective variance (collective-level selection)
  collective_means <- aggregate(fitness ~ collective_id, data = fitness_data, FUN = mean)
  grand_mean <- mean(fitness_data$fitness, na.rm = TRUE)

  # Weighted variance between collectives
  collective_sizes <- table(fitness_data$collective_id)
  Var_between <- sum(collective_sizes * (collective_means$fitness - grand_mean)^2) / 
                 sum(collective_sizes)

  # Within-collective variance (component-level selection)
  within_vars <- aggregate(fitness ~ collective_id, data = fitness_data, FUN = var)
  Var_within <- mean(within_vars$fitness, na.rm = TRUE)

  # Hierarchical Coherence: proportion of variance at collective level
  # H = 1 means all selection at collective level
  # H = 0 means all selection at component level
  total_var <- Var_between + Var_within

  if (total_var == 0 || is.na(total_var)) {
    warning("No variance in fitness data")
    return(list(H = 0.5, Var_between = 0, Var_within = 0))
  }

  H <- Var_between / total_var

  # Intraclass correlation coefficient (alternative measure)
  ICC <- Var_between / total_var

  return(list(
    H = H,
    Var_between = Var_between,
    Var_within = Var_within,
    Var_total = total_var,
    ICC = ICC,
    n_collectives = length(unique(fitness_data$collective_id)),
    n_components = nrow(fitness_data)
  ))
}

#' Calculate Hierarchical Coherence from multilevel selection experiment
#'
#' @param group_fitness Vector of group-level fitness values
#' @param individual_fitness_by_group List of vectors, each containing individual fitnesses within a group
#' @return Hierarchical Coherence
#' @export

calculate_coherence_from_experiment <- function(group_fitness, individual_fitness_by_group) {

  # Create long-format data frame
  fitness_data <- data.frame()
  for (i in seq_along(group_fitness)) {
    n_ind <- length(individual_fitness_by_group[[i]])
    fitness_data <- rbind(fitness_data, data.frame(
      collective_id = rep(i, n_ind),
      component_id = 1:n_ind,
      fitness = individual_fitness_by_group[[i]]
    ))
  }

  return(calculate_hierarchical_coherence(fitness_data))
}

#' Estimate Hierarchical Coherence from reproductive specialization
#'
#' When direct fitness data unavailable, estimate from specialization
#'
#' @param proportion_specialized Proportion of components with specialized roles
#' @param role_differentiation Degree of role differentiation (0-1)
#' @return Estimated H
#' @export

estimate_coherence_proxy <- function(proportion_specialized, role_differentiation) {
  # Higher specialization suggests stronger collective-level selection
  H_estimated <- (proportion_specialized * 0.6 + role_differentiation * 0.4)
  return(list(H = H_estimated, method = "proxy", precision = "+/- 0.20"))
}

# Example usage
if (FALSE) {
  # Example 1: High hierarchical coherence (strong group selection)
  fitness_group_selection <- data.frame(
    collective_id = rep(1:5, each = 10),
    component_id = rep(1:10, 5),
    fitness = c(
      rnorm(10, 80, 5),   # Group 1: high mean, low variance
      rnorm(10, 85, 5),   # Group 2
      rnorm(10, 75, 5),   # Group 3
      rnorm(10, 90, 5),   # Group 4
      rnorm(10, 78, 5)    # Group 5
    )
  )

  result1 <- calculate_hierarchical_coherence(fitness_group_selection)
  cat("High group selection H:", result1$H, "\n")
  cat("Between-group variance:", result1$Var_between, "\n")
  cat("Within-group variance:", result1$Var_within, "\n")

  # Example 2: Low hierarchical coherence (strong individual selection)
  fitness_individual_selection <- data.frame(
    collective_id = rep(1:5, each = 10),
    component_id = rep(1:10, 5),
    fitness = rnorm(50, 80, 20)  # High within-group variance
  )

  result2 <- calculate_hierarchical_coherence(fitness_individual_selection)
  cat("\nLow group selection H:", result2$H, "\n")

  # Example 3: Proxy estimation
  proxy_result <- estimate_coherence_proxy(
    proportion_specialized = 0.85,
    role_differentiation = 0.75
  )
  cat("\nProxy-estimated H:", proxy_result$H, "\n")
}
