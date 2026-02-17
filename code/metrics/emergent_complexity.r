# Emergent Complexity (E) - Calculation Script
# Quantifies non-additive properties
# Part of: Evolutionary Integration Framework
# Author: Sam Adeyemi

#' Calculate Emergent Complexity
#'
#' Measures the degree to which collective properties are non-additive
#' E = deviation from sum-of-parts prediction
#'
#' @param component_states Vector or matrix of component state values
#' @param collective_state Observed collective state value
#' @param prediction_method How to predict from components: "sum", "mean", "max"
#' @return List containing Emergent Complexity (E) and related metrics
#' @export

calculate_emergent_complexity <- function(component_states, collective_state, 
                                          prediction_method = "sum") {

  if (length(component_states) == 0) {
    warning("No component states provided")
    return(list(E = 0, deviation = 0))
  }

  # Predict collective state from components (additive model)
  predicted_state <- switch(prediction_method,
    "sum" = sum(component_states, na.rm = TRUE),
    "mean" = mean(component_states, na.rm = TRUE) * length(component_states),
    "max" = max(component_states, na.rm = TRUE),
    sum(component_states, na.rm = TRUE)
  )

  # Avoid division by zero
  if (predicted_state == 0) {
    predicted_state <- 0.001
  }

  # Calculate deviation from additive prediction
  deviation <- abs(collective_state - predicted_state) / predicted_state

  # Normalize to [0, 1]
  # Higher deviation = higher emergence
  E <- pmin(1, deviation)

  # Determine if synergistic (collective > predicted) or antagonistic
  synergy <- collective_state > predicted_state

  return(list(
    E = E,
    deviation = deviation,
    predicted = predicted_state,
    observed = collective_state,
    synergistic = synergy,
    fold_change = collective_state / predicted_state
  ))
}

#' Calculate Emergence from information theory
#'
#' Uses mutual information and transfer entropy
#'
#' @param component_distributions List of probability distributions for components
#' @param joint_distribution Joint probability distribution
#' @return Emergent complexity based on information measures
#' @export

calculate_emergence_information <- function(component_distributions, joint_distribution) {

  # Calculate Shannon entropy of components
  H_components <- sum(sapply(component_distributions, function(p) {
    p <- p[p > 0]
    -sum(p * log2(p))
  }))

  # Joint entropy
  p_joint <- joint_distribution[joint_distribution > 0]
  H_joint <- -sum(p_joint * log2(p_joint))

  # Mutual information (departure from independence)
  # I(X; Y) = H(X) + H(Y) - H(X,Y)
  MI <- H_components - H_joint

  # Normalize by maximum possible MI
  E <- pmin(1, abs(MI) / H_components)

  return(list(
    E = E,
    mutual_information = MI,
    H_components = H_components,
    H_joint = H_joint
  ))
}

#' Estimate Emergence from trait measurements
#'
#' @param component_traits Vector of individual component trait values
#' @param collective_trait Measured collective trait value
#' @return Emergent complexity estimate
#' @export

estimate_emergence_from_traits <- function(component_traits, collective_trait) {
  calculate_emergent_complexity(component_traits, collective_trait, method = "sum")
}

# Example usage
if (FALSE) {
  # Example 1: High emergence (synergy)
  components <- c(10, 15, 12, 18, 20)  # Individual productivities
  collective <- 95  # Collective productivity (> sum)

  result1 <- calculate_emergent_complexity(components, collective, "sum")
  cat("High emergence E:", result1$E, "\n")
  cat("Synergistic:", result1$synergistic, "\n")
  cat("Fold change:", result1$fold_change, "\n")

  # Example 2: Low emergence (additive)
  components2 <- c(10, 15, 12, 18, 20)
  collective2 <- 75  # Close to sum

  result2 <- calculate_emergent_complexity(components2, collective2, "sum")
  cat("\nLow emergence E:", result2$E, "\n")
}
