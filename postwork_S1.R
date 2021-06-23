dir()
df = read.csv("SP1.csv")

goles <- list(df$FTHG,df$FTAG)
frec_casa <- table(goles[1])
frec_away <- table(goles[2])

frec_casa <- as.data.frame(frec_casa)
frec_away <- as.data.frame(frec_away)

frec_casa <- rename(frec_casa, goles = Var1)
frec_away <- rename(frec_away, goles = Var1)

# Agregando probabilidades marginales
frec_casa <- mutate(frec_casa, goles = as.numeric(goles),prob = Freq/sum(Freq))
frec_away <- mutate(frec_away, goles = as.numeric(goles),prob = Freq/sum(Freq))

conjunta <- data_frame()
indice <- 1
# probabilidad conjunta
for (i in 1:length(frec_casa$goles)) {
  for (j in 1:length(frec_away$goles)) {
    conjunta[indice,1] <- frec_casa$goles[i]
    conjunta[indice,2] <- frec_away$goles[j]
    conjunta[indice,3] <- frec_casa$prob[i] * frec_away$prob[j]
    indice <- indice + 1
  }
}

conjunta <- rename(conjunta, goles_casa = 1, goles_visita = 2, probabilidad = 3)
