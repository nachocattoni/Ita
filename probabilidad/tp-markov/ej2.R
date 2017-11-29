expBernoulli <- function(p) {
  return(sample(0:1, 1, prob=c(1 - p, p)))
}

procesoBernoulli <- function(n, p, acum=FALSE) {
  result <- replicate(n, 0)
  for (i in 1:n) {
    result[i] <- expBernoulli(p)
  }
  if(acum) result <- cumsum(result)
  return(result)
}

pruebaEmpirica <- function(rep, n, p, acum=FALSE) {
  datos <- matrix(nrow=rep, ncol=n)
  for (i in 1:rep) {
    datos[i,] <- procesoBernoulli(n, p, acum)
  }
  result <- list(esperanza=replicate(n, 0), variancia=replicate(n, 0))
  for (i in 1:n) {
    # Procesar fila por fila y obtener espranza y variancia
    result$esperanza[i] = mean(datos[,i])
    result$variancia[i] = var(datos[,i])
  }
  return(result)
}

# 500 simulaciones de los procesos, con 10 repeticiones
# del experimento, y con 0.3 probabilidad de éxito.
print("Esperanza y Variancia de E_n")
pruebaEmpirica(500, 10, 0.3, acum=FALSE)
print("Esperanza y Variancia de S_n")
pruebaEmpirica(500, 10, 0.3, acum=TRUE)

# Otras pruebas realizadas jugando con los parámetros.
# Todos los valores resultaron muy similares, salvo por
# las últimas pruebas, dado su bajo número de repeticiones.
pruebaEmpirica(5000, 10, 0.3)
pruebaEmpirica(500, 100, 0.3)
pruebaEmpirica(10, 100, 0.3)
pruebaEmpirica(10, 3, 0.3)

# En el proceso S_n, que es el número de éxitos en el proceso Bernoulli, 
# tenemos que la esperanza(S_n) = np, y que variancia(S_n) = npq.
