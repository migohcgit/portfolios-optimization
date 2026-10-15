# Simple return, chronological order 
price_matrix <- as.matrix(prices[, asset_names, drop = FALSE])
returns <- price_matrix[-1, , drop = FALSE] / price_matrix[-nrow(price_matrix), , drop = FALSE] - 1
return_dates <- prices$Date[-1]
colnames(returns) <- asset_names
rownames(returns) <- as.character(return_dates)
if (any(!is.finite(returns))) stop("Non finites returns, review for price and dates, may a character in a number variable")

# Expected return vector and covariance matrix
mu <- colMeans(returns)
Sigma <- stats::cov(returns)
# symmetrize by numerical stability and check for a positive definite matrix.
Sigma <- (Sigma + t(Sigma)) / 2
if (any(!is.finite(Sigma))) stop("Can't calculate covariance matrix. Finite or character error")