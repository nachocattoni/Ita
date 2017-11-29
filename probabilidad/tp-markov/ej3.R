zigZag <- function(n, p, acum=FALSE, graf=FALSE, plotSuffix='') {
  if(graf) G <- c(0)
  pos <- 0
  for (i in 1:n) {
    val <- sample(c(-1, 1), 1, prob=c(1 - p, p))
    pos <- pos + val
    if(graf){
      if(acum) G <- append(G, pos)
      else     G <- append(G, val)
    }
  }
  if(graf){
    pdf(paste("zigZag", plotSuffix, ".pdf", sep=''))
    if(acum){
      plot(G, type='l', xlab="Tiempo", ylab="Posición")
    }
    else {
      plot(G, type='b', xlab="Tiempo", ylab="Incremento")
    }
    dev.off()
  }
}

# Primero simulamos D_n, con pocos puntos para obtener un plot bonito
zigZag(10, 0.51, graf=TRUE, plotSuffix='Normal')

# Luego simulamos la posición de la partícula, con muchos puntos para notar
# qué tan lejos puede irse del estado inicial (0), y también, para tener
# un plot bonito.
zigZag(500, 0.51, graf=TRUE, acum=TRUE, plotSuffix='Acum')

