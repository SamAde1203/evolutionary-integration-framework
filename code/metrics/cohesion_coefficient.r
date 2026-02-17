# Cohesion Coefficient (C) - Calculation Script
# Measures physiological/developmental interdependence
# Part of: Evolutionary Integration Framework
# Author: Sam Adeyemi

#' Calculate Cohesion Coefficient
#'
#' Quantifies the degree to which components depend on the collective for survival/function
#' C = (1/n) * sum(1 - V_i)
#' where V_i = viability_isolated / viability_integrated
#'
#' @param viability_data Data frame with columns: component_id, viability_isolated, viability_integrated
#' @return List containing Cohesion Coefficient (C) and component-level details
#' @export
#'
#' @examples
#' viability <- data.frame(
#'   component_id = c("Cell1", "Cell2", "Cell3"),
#'   viability_isolated = c(0.2, 0.3, 0.1),
#'   viability_integrated = c(0.95, 0.98, 0.92)
#' )
#' result <- calculate_cohesion_coefficient(viability)
#' print(result$C)

calculate_cohesion_coefficient <- function(viability_data) {

  # Validate input
  required_cols <- c("viability_isolated", "viability_integrated")
  if (!all(required_cols %in% names(viability_data))) {
    stop("viability_data must contain columns: viability_isolated, viability_integrated")
  }

  n <- nrow(viability_data)

  if (n == 0) {
    warning("No data provided")
    return(list(C = 0, component_cohesions = numeric(0)))
  }

  # Calculate viability ratio for each component
  # V_i = survival isolated / survival integrated
  # If integrated > isolated, V_i < 1, indicating dependence
  V_i <- viability_data$viability_isolated / viability_data$viability_integrated

  # Cohesion for each component: 1 - V_i
  # High cohesion = low isolated viability relative to integrated
  component_cohesions <- 1 - V_i

  # Clip to [0, 1] range
  component_cohesions <- pmin(pmax(component_cohesions, 0), 1)

  # Overall Cohesion Coefficient: mean across components
  C <- mean(component_cohesions, na.rm = TRUE)

  # Standard deviation (measure of variation)
  C_sd <- sd(component_cohesions, na.rm = TRUE)

  # Identify highly cohesive components (> 0.7)
  high_cohesion_count <- sum(component_cohesions > 0.7, na.rm = TRUE)

  return(list(
    C = C,
    C_sd = C_sd,
    component_cohesions = component_cohesions,
    high_cohesion_proportion = high_cohesion_count / n,
    n_components = n
  ))
}

#' Calculate Cohesion from survival time data
#'
#' @param survival_data Data frame with columns: component_id, time_isolated, time_integrated
#' @return List containing Cohesion Coefficient
#' @export

calculate_cohesion_from_survival <- function(survival_data) {
  viability_data <- data.frame(
    component_id = survival_data$component_id,
    viability_isolated = survival_data$time_isolated / max(survival_data$time_integrated),
    viability_integrated = survival_data$time_integrated / max(survival_data$time_integrated)
  )
  return(calculate_cohesion_coefficient(viability_data))
}

#' Estimate Cohesion from proxy measures (Tier 2/3)
#'
#' When direct viability measurements unavailable, estimate from observable traits
#'
#' @param trait_loss Proportion of essential traits lost when isolated (0-1)
#' @param functional_dependence Degree of functional interdependence (0-1)
#' @return Estimated Cohesion Coefficient
#' @export

estimate_cohesion_proxy <- function(trait_loss, functional_dependence) {
  # Weighted average of proxy measures
  C_estimated <- (trait_loss * 0.6 + functional_dependence * 0.4)
  return(list(C = C_estimated, method = "proxy", precision = "+/- 0.15"))
}

# Example usage and validation
if (FALSE) {
  # Example 1: High cohesion (endosymbionts)
  endosymbiont_data <- data.frame(
    component_id = paste0("Cell", 1:5),
    viability_isolated = c(0.05, 0.10, 0.02, 0.08, 0.15),
    viability_integrated = c(0.95, 0.98, 0.96, 0.99, 0.97)
  )

  result1 <- calculate_cohesion_coefficient(endosymbiont_data)
  cat("Endosymbiont Cohesion (C):", result1$C, "\n")
  cat("Standard deviation:", result1$C_sd, "\n")

  # Example 2: Low cohesion (facultative association)
  facultative_data <- data.frame(
    component_id = paste0("Org", 1:5),
    viability_isolated = c(0.85, 0.90, 0.80, 0.88, 0.92),
    viability_integrated = c(0.95, 0.98, 0.90, 0.95, 0.99)
  )

  result2 <- calculate_cohesion_coefficient(facultative_data)
  cat("\nFacultative association Cohesion (C):", result2$C, "\n")

  # Example 3: Proxy estimation (when direct measurement unavailable)
  proxy_result <- estimate_cohesion_proxy(trait_loss = 0.75, functional_dependence = 0.80)
  cat("\nProxy-estimated Cohesion (C):", proxy_result$C, "\n")
  cat("Precision:", proxy_result$precision, "\n")
}
