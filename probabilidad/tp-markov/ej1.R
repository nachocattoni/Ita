# S es la cantidad de dinero que está en juego
# k es la cantidad de dinero inicial del jugador A
# p es la probabilidad de que el jugador A gane en cada paso
# Esta función simula el juego hasta que el jugador A
# se quede con todo el dinero, o quede en bancarrota.
GamblersRuin <- function(S, k, p, graf=FALSE) {
  if(graf) G <- c(k)
  dinero <- k
  while(dinero != 0 && dinero != S){
    r <- sample(2, 1, prob=c(1 - p, p)) # Valor aleatorio entre 1 y 2.
    # print(dinero) Para ver un proceso en particular, descomentar esta linea
    if(r > 1){
      dinero <- dinero + 1
    }
    else {
      dinero <- dinero - 1
    }
    if(graf) G <- append(G, dinero)
  }
  if(graf){
    pdf("gamblersruin.pdf")
    plot(G, type='l', xlab="Tiempo", ylab="Dinero")
    dev.off()
  }
  return(dinero == S)
}

# rep es la cantidad de repeticiones que se quieren simular
# S es la cantidad de dinero que está en juego
# k es la cantidad de dinero inicial del jugador A
# p es la probabilidad de que A gane en cada paso
# Esta funcion simplemente simula GamblersRuin 'rep' veces, y
# obtiene información empírica basada en sus resultados.
PruebaEmpirica <- function(rep, S, k, p) {
  acum <- 0
  for (i in 1:rep) {
    s <- GamblersRuin(S, k, p)
    if(s) acum <- acum + 1
  }
  return(acum / rep)
}

# Algunas pruebas interesantes

# Si le pasamos el parámetro 'graf' en TRUE, la función nos va a devolver un
# lindo gráfico de la cantidad de dinero del jugador A en función del tiempo.
GamblersRuin(50, 25, 0.49, graf=TRUE)

# En este, empezamos con 7 dólares, y hay 10 en juego, nuestra probabilidad de ganar
# cada ronda es de 0.42. A pesar de la clara ventaja inicial, las probabilidades
# son más grandes de quedar en la ruina que de ganar.
PruebaEmpirica(200, 4, 2, 0.42)
# Resultado teórico: 0.3541127

# En este, empezamos con 4 dólares, y solo necesitamos uno más para ganar (hay 5 en
# juego), pero nuestra chance de ganar cada ronda es de 0.3. Aún a pesar de la gran
# ventaja, es más probable quedar en la ruina que ganar.
PruebaEmpirica(300, 5, 4, 0.3)
# Resultado teórico: 0.4201884

# Este es particularmente divertido, empezamos con 50 dólares, y necesitamos llegar a 100,
# y la probabilidad de ganar en cada partida es de 0.495, es decir, el juego está muy cerca
# de ser justo.
# Advertencia: Esta simulación tarda mucho.
PruebaEmpirica(300, 100, 50, 0.495) 
# Resultado teórico: 0.2689349

# Resulta fascinante que estas simulaciones, puestas como juegos en un casino, 
# podrían resultar exageramente atractivas, a pesar de la tan baja probabilidad
# de ser 'ganados'.
