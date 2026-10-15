#optimization
solve_min_variance <- function(S) {
  n <- ncol(S)
  D <- S + diag(1e-10, n) # number regularization
  Amat <- cbind(rep(1, n), diag(n))
  bvec <- c(1, rep(0, n))
  fit <- quadprog::solve.QP(Dmat = D, dvec = rep(0, n), Amat = Amat,
                            bvec = bvec, meq = 1)
  w <- as.numeric(fit$solution)
  w[w < 1e-10] <- 0
  w / sum(w)
}

w_min <- solve_min_variance(Sigma)
ret_min <- sum(w_min * mu)
sd_min <- sqrt(as.numeric(t(w_min) %*% Sigma %*% w_min))

# Max sharp ratio porfolio and lower risk
best_idx <- which.max(portfolios$sharpe)
w_sharpe <- as.numeric(weights_random[best_idx, ])
if (is.finite((ret_min - risk_free_period) / sd_min) &&
    (ret_min - risk_free_period) / sd_min > portfolios$sharpe[best_idx]) {
  w_sharpe <- w_min
}

special_weights <- rbind(Minima_varianza = w_min, Maximo_Sharpe_simulado = w_sharpe)
colnames(special_weights) <- asset_names
special_return <- as.vector(special_weights %*% mu)
special_variance <- rowSums((special_weights %*% Sigma) * special_weights)
special_sd <- sqrt(pmax(special_variance, 0))
special_sharpe <- ifelse(special_sd > 0, (special_return - risk_free_period) / special_sd, NA_real_)
special <- data.frame(
  portafolio = rownames(special_weights),
  rendimiento_esperado = special_return,
  varianza = special_variance,
  volatilidad = special_sd,
  sharpe = special_sharpe,
  special_weights,
  row.names = NULL,
  check.names = FALSE
)

# Efficient Frontier: best sharp ratio
# keep the lower variance portfolio as a reference
frontier <- portfolios[order(portfolios$volatilidad), ]
frontier <- frontier[!duplicated(round(frontier$volatilidad, 6)), ]
frontier <- frontier[order(frontier$volatilidad), ]
frontier <- frontier[!duplicated(cummax(frontier$rendimiento_esperado)), ]

write.csv(portfolios, file.path(OUTPUT_DIR, "portafolios_simulados.csv"), row.names = FALSE)
write.csv(special, file.path(OUTPUT_DIR, "portafolios_optimos.csv"), row.names = FALSE)
weights_output <- data.frame(
  Activo = rownames(t(special_weights)),
  t(special_weights),
  check.names = FALSE,
  row.names = NULL
)