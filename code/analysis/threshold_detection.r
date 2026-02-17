# Threshold Detection Analysis
# Segmented regression to detect κ ≈ 0.73 threshold
# Part of: Evolutionary Integration Framework
# Author: Sam Adeyemi

library(segmented)
library(ggplot2)

#' Detect Integration Threshold
#'
#' Uses segmented regression to identify breakpoint in relationship between
#' cohesion and reversibility/complexity
#'
#' @param data Data frame with cohesion values and outcome measure
#' @param cohesion_var Name of cohesion variable (default: "Cohesion_Coefficient_C")
#' @param outcome_var Name of outcome variable (default: "Reversible")
#' @param initial_threshold Initial guess for threshold (default: 0.7)
#' @return List containing threshold estimate, confidence interval, and model
#' @export

detect_threshold <- function(data, 
                              cohesion_var = "Cohesion_Coefficient_C",
                              outcome_var = "Reversible",
                              initial_threshold = 0.7) {

  # Prepare data
  x <- data[[cohesion_var]]
  y <- data[[outcome_var]]

  # Fit initial linear model
  lm_model <- lm(y ~ x)

  # Fit segmented regression
  # This finds the breakpoint where slope changes
  seg_model <- tryCatch({
    segmented::segmented(lm_model, seg.Z = ~x, psi = initial_threshold)
  }, error = function(e) {
    warning("Segmented regression failed: ", e$message)
    return(NULL)
  })

  if (is.null(seg_model)) {
    return(list(
      threshold = initial_threshold,
      ci_lower = NA,
      ci_upper = NA,
      method = "failed"
    ))
  }

  # Extract threshold (breakpoint)
  threshold <- seg_model$psi[1, "Est."]
  ci_lower <- seg_model$psi[1, "Est."] - 1.96 * seg_model$psi[1, "St.Err"]
  ci_upper <- seg_model$psi[1, "Est."] + 1.96 * seg_model$psi[1, "St.Err"]

  # Calculate R-squared improvement
  r2_linear <- summary(lm_model)$r.squared
  r2_segmented <- summary(seg_model)$r.squared

  # Slope change
  slopes <- slope(seg_model)

  return(list(
    threshold = threshold,
    ci_lower = ci_lower,
    ci_upper = ci_upper,
    r2_linear = r2_linear,
    r2_segmented = r2_segmented,
    r2_improvement = r2_segmented - r2_linear,
    slopes = slopes,
    model = seg_model,
    method = "segmented_regression"
  ))
}

#' Validate threshold using multiple methods
#'
#' @param data Data frame with metrics
#' @param cohesion_var Cohesion variable name
#' @param outcome_var Outcome variable name
#' @return List of threshold estimates from different methods
#' @export

validate_threshold_multiple_methods <- function(data, 
                                                 cohesion_var = "Cohesion_Coefficient_C",
                                                 outcome_var = "Reversible") {

  results <- list()

  # Method 1: Segmented regression
  results$segmented <- detect_threshold(data, cohesion_var, outcome_var)

  # Method 2: Logistic regression inflection point
  x <- data[[cohesion_var]]
  y <- data[[outcome_var]]

  logit_model <- glm(y ~ x, family = binomial(link = "logit"))
  # Inflection point at x = -intercept / slope
  threshold_logit <- -coef(logit_model)[1] / coef(logit_model)[2]
  results$logistic_inflection <- list(threshold = as.numeric(threshold_logit))

  # Method 3: Maximum curvature
  # Fit smoothing spline and find max curvature
  smooth_fit <- smooth.spline(x, y, spar = 0.5)
  pred <- predict(smooth_fit, x = seq(min(x), max(x), length.out = 100))

  # Second derivative (curvature)
  dx <- diff(pred$x)
  dy <- diff(pred$y)
  dy2 <- diff(dy) / dx[-length(dx)]

  # Find maximum absolute curvature
  max_curve_idx <- which.max(abs(dy2))
  threshold_curve <- pred$x[max_curve_idx]
  results$max_curvature <- list(threshold = threshold_curve)

  # Summary statistics
  all_thresholds <- c(
    results$segmented$threshold,
    results$logistic_inflection$threshold,
    results$max_curvature$threshold
  )

  results$summary <- list(
    mean_threshold = mean(all_thresholds, na.rm = TRUE),
    sd_threshold = sd(all_thresholds, na.rm = TRUE),
    min_threshold = min(all_thresholds, na.rm = TRUE),
    max_threshold = max(all_thresholds, na.rm = TRUE)
  )

  return(results)
}

#' Plot threshold detection results
#'
#' @param data Data frame
#' @param threshold_result Result from detect_threshold()
#' @param cohesion_var Cohesion variable name
#' @param outcome_var Outcome variable name
#' @return ggplot object
#' @export

plot_threshold <- function(data, threshold_result, 
                           cohesion_var = "Cohesion_Coefficient_C",
                           outcome_var = "Reversible") {

  library(ggplot2)

  p <- ggplot(data, aes(x = .data[[cohesion_var]], y = .data[[outcome_var]])) +
    geom_point(alpha = 0.6, size = 2) +
    geom_vline(xintercept = threshold_result$threshold, 
               linetype = "dashed", color = "red", size = 1) +
    geom_ribbon(aes(xmin = threshold_result$ci_lower, 
                    xmax = threshold_result$ci_upper,
                    y = NULL),
                alpha = 0.2, fill = "red") +
    labs(
      title = "Integration Threshold Detection",
      subtitle = sprintf("Threshold κ = %.3f (95%% CI: %.3f - %.3f)",
                        threshold_result$threshold,
                        threshold_result$ci_lower,
                        threshold_result$ci_upper),
      x = "Cohesion Coefficient (C)",
      y = outcome_var
    ) +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", size = 14))

  return(p)
}

# Example usage
if (FALSE) {
  # Load data
  data <- read.csv("data/processed/integration_metrics.csv")

  # Detect threshold
  threshold_result <- detect_threshold(data)

  cat("Detected threshold:", threshold_result$threshold, "\n")
  cat("95% CI: [", threshold_result$ci_lower, ",", threshold_result$ci_upper, "]\n")
  cat("R² improvement:", threshold_result$r2_improvement, "\n")

  # Validate with multiple methods
  validation <- validate_threshold_multiple_methods(data)
  cat("\nMean threshold across methods:", validation$summary$mean_threshold, "\n")
  cat("SD:", validation$summary$sd_threshold, "\n")

  # Plot
  p <- plot_threshold(data, threshold_result)
  print(p)
  # ggsave("figures/threshold_detection.pdf", p, width = 8, height = 6)
}
