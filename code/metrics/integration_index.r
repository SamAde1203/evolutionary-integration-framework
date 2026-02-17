# Integration Index (I) - Calculation Script
# Measures overall system cohesion using Shannon entropy
# Part of: Evolutionary Integration Framework
# Author: Sam Adeyemi

library(igraph)

#' Calculate Integration Index
#'
#' Measures the degree of integration using Shannon entropy of interaction networks
#'
#' @param network An adjacency matrix or igraph object representing the interaction network
#' @param directed Logical, whether the network is directed (default: FALSE)
#' @return List containing Integration Index (I) and related metrics
#' @export
#'
#' @examples
#' # Create example network
#' adj_matrix <- matrix(c(0,1,1,0, 1,0,1,1, 1,1,0,1, 0,1,1,0), nrow=4, byrow=TRUE)
#' result <- calculate_integration_index(adj_matrix)
#' print(result$I)

calculate_integration_index <- function(network, directed = FALSE) {

  # Convert to igraph if needed
  if (!igraph::is_igraph(network)) {
    g <- igraph::graph_from_adjacency_matrix(network, mode = ifelse(directed, "directed", "undirected"))
  } else {
    g <- network
  }

  # Get network properties
  n_nodes <- igraph::vcount(g)
  n_edges <- igraph::ecount(g)

  if (n_nodes == 0 || n_edges == 0) {
    warning("Network has no nodes or edges")
    return(list(I = 0, H_observed = 0, H_max = 0, connectivity = 0))
  }

  # Calculate degree distribution
  degrees <- igraph::degree(g)
  total_degree <- sum(degrees)

  if (total_degree == 0) {
    return(list(I = 0, H_observed = 0, H_max = 0, connectivity = 0))
  }

  # Normalize to probabilities
  p_i <- degrees / total_degree
  p_i <- p_i[p_i > 0]  # Remove zeros

  # Calculate Shannon entropy
  H_observed <- -sum(p_i * log2(p_i))

  # Maximum possible entropy (uniform distribution)
  H_max <- log2(n_nodes)

  # Integration Index: 1 - (H_observed / H_max)
  # High entropy (uniform) = low integration
  # Low entropy (concentrated) = high integration
  I <- 1 - (H_observed / H_max)

  # Additional metrics
  connectivity <- n_edges / (n_nodes * (n_nodes - 1) / 2)

  return(list(
    I = I,
    H_observed = H_observed,
    H_max = H_max,
    connectivity = connectivity,
    n_nodes = n_nodes,
    n_edges = n_edges
  ))
}

#' Calculate Integration Index from edge list
#'
#' @param edge_list A data frame with columns 'from' and 'to'
#' @param directed Logical, whether edges are directed
#' @return List containing Integration Index and metrics
#' @export

calculate_integration_from_edges <- function(edge_list, directed = FALSE) {
  g <- igraph::graph_from_data_frame(edge_list, directed = directed)
  return(calculate_integration_index(g, directed = directed))
}

# Example usage and validation
if (FALSE) {
  # Example 1: Simple 4-node network
  adj_matrix <- matrix(c(
    0, 1, 1, 0,
    1, 0, 1, 1,
    1, 1, 0, 1,
    0, 1, 1, 0
  ), nrow = 4, byrow = TRUE)

  result <- calculate_integration_index(adj_matrix)
  cat("Integration Index (I):", result$I, "\n")
  cat("Shannon Entropy:", result$H_observed, "\n")
  cat("Connectivity:", result$connectivity, "\n")

  # Example 2: Highly integrated network (star topology)
  star_matrix <- matrix(0, nrow = 5, ncol = 5)
  star_matrix[1, 2:5] <- 1
  star_matrix[2:5, 1] <- 1

  star_result <- calculate_integration_index(star_matrix)
  cat("\nStar network Integration Index:", star_result$I, "\n")

  # Example 3: Low integration (disconnected modules)
  modular_matrix <- matrix(c(
    0,1,1,0,0,0,
    1,0,1,0,0,0,
    1,1,0,0,0,0,
    0,0,0,0,1,1,
    0,0,0,1,0,1,
    0,0,0,1,1,0
  ), nrow = 6, byrow = TRUE)

  modular_result <- calculate_integration_index(modular_matrix)
  cat("Modular network Integration Index:", modular_result$I, "\n")
}
