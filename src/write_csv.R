#for writting csv files of previous calculations
write.csv(data.frame(Date = return_dates, returns, check.names = FALSE),
          file.path(OUTPUT_DIR, "rendimientos.csv"), row.names = FALSE)
write.csv(data.frame(Activo = names(mu), Rendimiento_esperado_periodico = as.numeric(mu),
                     Volatilidad_periodica = sqrt(diag(Sigma))),
          file.path(OUTPUT_DIR, "estadisticas_activos.csv"), row.names = FALSE)
write.csv(data.frame(Activo = rownames(Sigma), Sigma, check.names = FALSE),
          file.path(OUTPUT_DIR, "matriz_covarianzas.csv"), row.names = FALSE)
write.csv(data.frame(Activo = rownames(cor(returns)), cor(returns), check.names = FALSE),
          file.path(OUTPUT_DIR, "matriz_correlaciones.csv"), row.names = FALSE)