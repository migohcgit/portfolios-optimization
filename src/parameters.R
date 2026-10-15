# Markowitz models for N assets

#this is the initial config
DATA_DIR <- "data"
OUTPUT_DIR <- "output"
FREQUENCY <- "monthly"       # "daily", "weekly", "monthly" o "annual" esto ya se decide
RISK_FREE_ANNUAL <- 0.0628    # CETES 28 dias % modificar si se ocupa
N_RANDOM_PORTFOLIOS <- 20000 
SEED <- 123
ALLOW_SHORT_SELLING <- FALSE # for now just long positions

if (!requireNamespace("quadprog", quietly = TRUE)) {
  stop("'quadprog' Missing. Install with install.packages('quadprog') and try again.")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop("'ggplot2' Missing. Install with install.packages('ggplot2') and try again.")
}

if (!dir.exists(DATA_DIR)) stop("can't find 'data' directory. Execute the script from project's root.")
if (!dir.exists(OUTPUT_DIR)) dir.create(OUTPUT_DIR, recursive = TRUE)

periods_per_year <- switch(FREQUENCY, daily = 252, weekly = 52, monthly = 12, annual = 1,
                           stop("FREQUENCY must be daily, weekly, monthly o annual."))
risk_free_period <- (1 + RISK_FREE_ANNUAL)^(1 / periods_per_year) - 1