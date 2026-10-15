#this file prints results on console
cat("\nAnalisis terminado.\n")
cat("Activos:", paste(asset_names, collapse = ", "), "\n")
cat("Observaciones de rendimiento:", nrow(returns), "\n")
cat("Frecuencia:", FREQUENCY, "| tasa libre de riesgo por periodo:", round(risk_free_period, 6), "\n\n")
print(special)
cat("\nArchivos generados en:", normalizePath(OUTPUT_DIR), "\n")