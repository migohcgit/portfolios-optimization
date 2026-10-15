# this is the graph
cat("Número de portafolios:", nrow(portfolios), "\n")
cat("Número de puntos de la frontera:", nrow(frontier), "\n")
cat("Número de portafolios especiales:", nrow(special), "\n")

print(head(portfolios))

p <- ggplot2::ggplot(portfolios, ggplot2::aes(x = volatilidad, y = rendimiento_esperado)) +
  ggplot2::geom_point(ggplot2::aes(color = sharpe), alpha = 0.45, size = 1.2) +
  ggplot2::geom_line(data = frontier,
                     ggplot2::aes(x = volatilidad, y = rendimiento_esperado),
                     inherit.aes = FALSE, linewidth = 0.8, color = "#007F7F") +
  ggplot2::geom_point(data = special,
                      ggplot2::aes(x = volatilidad, y = rendimiento_esperado, shape = portafolio),
                      inherit.aes = FALSE, size = 3.2, color = "#B23A48") +
  ggplot2::labs(title = "Portafolios de Markowitz para N activos",
                subtitle = sprintf("%d activos | frecuencia %s | tasa libre de riesgo anual %.2f%%",
                                   n_assets, FREQUENCY, RISK_FREE_ANNUAL * 100),
                x = "Volatilidad por periodo", y = "Rendimiento esperado por periodo",
                color = "Sharpe", shape = "Portafolio") +
  ggplot2::theme_minimal()
ggplot2::ggsave(file.path(OUTPUT_DIR, "frontera_eficiente.png"), p, width = 10, height = 6, dpi = 160)