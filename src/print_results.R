# for print csv files of optimization calculations
write.csv(
  weights_output,
  file.path(OUTPUT_DIR, "pesos_optimos.csv"),
  row.names = FALSE
)
write.csv(frontier[, c("rendimiento_esperado", "volatilidad", "sharpe")],
          file.path(OUTPUT_DIR, "frontera_eficiente_aproximada.csv"), row.names = FALSE)