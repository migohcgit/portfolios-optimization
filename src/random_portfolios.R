# Random portfolios (only for comparation) will be used later 
set.seed(SEED)
n_assets <- length(asset_names)
raw_weights <- matrix(rexp(N_RANDOM_PORTFOLIOS * n_assets), ncol = n_assets)
weights_random <- raw_weights / rowSums(raw_weights)
colnames(weights_random) <- asset_names

portfolio_return <- as.vector(weights_random %*% mu)
portfolio_variance <- rowSums((weights_random %*% Sigma) * weights_random)
portfolio_sd <- sqrt(pmax(portfolio_variance, 0))
sharpe <- ifelse(portfolio_sd > 0, (portfolio_return - risk_free_period) / portfolio_sd, NA_real_)

portfolios <- data.frame(
  id = seq_len(N_RANDOM_PORTFOLIOS),
  rendimiento_esperado = portfolio_return,
  varianza = portfolio_variance,
  volatilidad = portfolio_sd,
  sharpe = sharpe,
  weights_random,
  check.names = FALSE
)
