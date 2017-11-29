library("markovchain")

# Retorna TRUE/FALSE dependiendo de si el vector es un
# vector de probabilidad válido de 4 elementos.
validarFila <- function(v) {
  if(length(v) != 4) return(FALSE)
  for (i in 1:length(v)) {
    if(v[i] < 0 || v[i] > 1) return(FALSE)
  }
  if(sum(v) != 1) return(FALSE)
  return(TRUE)
}

simulacionMarkov <- function(tMatrix, initial, rep) {
  # Check initial (ejercicio a)
  if(!validarFila(initial)) return(FALSE)

  # Check transitionMatrix (ejericio b)
  filas <- nrow(tMatrix)
  if(filas != 4) return(FALSE)
  for (i in 1:filas) {
    if(!validarFila(tMatrix[i,])) return(FALSE)
  }

  # Hacer la simulación (ejercicio c)
  MC <- new("markovchain", states=c("A", "B", "C", "D"), transitionMatrix=tMatrix)
  init <- sample(c("A", "B", "C", "D"), 1, prob=initial)

  if(length(absorbingStates(MC)) > 0) return(FALSE) # No debe tener estados absorbentes
  lista <- rmarkovchain(n=rep, object=MC, t0=init)

  # Graficarla! (enunciado)
  print(lista)
  # plot(lista)
  return(TRUE)
}
v <- (matrix(c(0, .25, .5, .25, .75, 0, .12, .13, .1, .1, 0, .8, .2, .2, .6, 0), byrow=TRUE, nrow=4))
print(v)
simulacionMarkov(matrix(c( 0 , .25, .5 , .25,
                          .75,  0 , .12, .13,
                          .1 , .1 ,  0 , .8, 
                          .2 , .2 , .6 ,  0), byrow=TRUE, nrow=4), c(.25, .25, .25, .25), 100)


