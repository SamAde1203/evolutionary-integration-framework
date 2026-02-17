# Modular Independence (M) - Calculation Script
# Detects decomposable structure using community detection
# Part of: Evolutionary Integration Framework
# Author: Sam Adeyemi

library(igraph)

#' Calculate Modular Independence
#'
#' Measures the degree to which a system can be decomposed into semi-independent modules
#' Uses Louvain community detection and modularity Q
#'
#' @param network An adjacency matrix or igraph object
#' @param method Community detection method: "louvain" (default), "walktrap", "fast_greedy"
#' @return List containing Modularity (M), number of communities, and membership
#' @export

calculate_modular_independence <- function(network, method = "louvain") {

  # Convert to igraph if needed
  if (!igraph::is_igraph(network)) {
    g <- igraph::graph_from_adjacency_matrix(network, mode = "undirected", weighted = TRUE)
  } else {
    g <- network
  }

  n_nodes <- igraph::vcount(g)
  n_edges <- igraph::ecount(g)

  if (n_nodes < 2 || n_edges == 0) {
    warning("Network too small or no edges")
    return(list(M = 0, n_communities = 1, modularity_Q = 0))
  }

  # Community detection
  communities <- switch(method,
    "louvain" = igraph::cluster_louvain(g),
    "walktrap" = igraph::cluster_walktrap(g),
    "fast_greedy" = igraph::cluster_fast_greedy(g),
    igraph::cluster_louvain(g)  # default
  )

  # Modularity Q (ranges from -0.5 to 1)
  # Q > 0.3 indicates significant modular structure
  Q <- igraph::modularity(communities)

  # Normalize to [0, 1] for consistency
  # Transform: M = (Q + 0.5) / 1.5
  # This maps Q range [-0.5, 1] to M range [0, 1]
  M <- pmax(0, pmin(1, (Q + 0.5) / 1.5))

  n_communities <- length(unique(igraph::membership(communities)))

  # Module size distribution (entropy measure)
  module_sizes <- table(igraph::membership(communities))
  module_proportions <- module_sizes / n_nodes
  module_entropy <- -sum(module_proportions * log(module_proportions + 1e-10))

  return(list(
    M = M,
    modularity_Q = Q,
    n_communities = n_communities,
    membership = igraph::membership(communities),
    module_sizes = as.vector(module_sizes),
    module_entropy = module_entropy
  ))
}

#' Calculate modularity from predefined communities
#'
#' @param network Adjacency matrix or igraph object
#' @param membership Vector of community assignments
#' @return Modularity score
#' @export

calculate_modularity_from_membership <- function(network, membership) {
  if (!igraph::is_igraph(network)) {
    g <- igraph::graph_from_adjacency_matrix(network, mode = "undirected")
  } else {
    g <- network
  }

  Q <- igraph::modularity(g, membership)
  M <- pmax(0, pmin(1, (Q + 0.5) / 1.5))

  return(list(M = M, modularity_Q = Q))
}

# Example usage
if (FALSE) {
  # Example 1: Modular network (two clear communities)
  modular_net <- matrix(c(
    0,1,1,1,0,0,0,0,
    1,0,1,1,0,0,0,0,
    1,1,0,1,0,0,0,0,
    1,1,1,0,1,0,0,0,
    0,0,0,1,0,1,1,1,
    0,0,0,0,1,0,1,1,
    0,0,0,0,1,1,0,1,
    0,0,0,0,1,1,1,0
  ), nrow = 8, byrow = TRUE)

  result1 <- calculate_modular_independence(modular_net)
  cat("Modular network M:", result1$M, "\n")
  cat("Number of communities:", result1$n_communities, "\n")

  # Example 2: Highly integrated network (no modules)
  integrated_net <- matrix(1, nrow = 6, ncol = 6)
  diag(integrated_net) <- 0

  result2 <- calculate_modular_independence(integrated_net)
  cat("\nIntegrated network M:", result2$M, "\n")
}
