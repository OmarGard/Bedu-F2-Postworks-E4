  
  # ############################################################################
  #                               EQUIPO 4
  #                           Sesion-1 Postwork
  # ############################################################################
  
  
  # 1. Importa los datos de soccer de la temporada 2019/2020 de la primera división 
  # de la liga española a R, los datos los puedes encontrar en el siguiente enlace: 
  # https://www.football-data.co.uk/spainm.php
  
  # 2. Extrae las columnas que contienen los números de goles anotados por los equipos 
  # que jugaron en casa (FTHG) y los goles anotados por los equipos que jugaron como visitante (FTAG)
  
  # 3. Consulta cómo funciona la función table en R al ejecutar en la consola ?table

  
  # 1. Cargamos los datos
  data.soccer <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
  download.file(url = data.soccer, destfile = "data.soccer.csv", mode = "wb")
  data <-  read.csv("data.soccer.csv")
  
  # 2.Extrae las columnas de goles en casa(FTHG) y visitante(FTAG)
  data <- data[ ,c(6:7)]
  
  
  # 3.Elabora tablas de frecuencias relativas.
  freq_home <-table(data$FTHG)
  freq_away <-table(data$FTAG)
  freq_conjunta <-table(data)
  
  
  # Posteriormente elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
  # 1. La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
  # 2. La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
  # 3. La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y 
  # el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
  
  
  # PROBABILIDADES MARGINALES
  # 1. Probabilidad marginal de goles en casa
  proba_home <- freq_home / length(data$FTHG)
  prop.table(proba_home) #Mismo resultado
  
  
  # 2. Probabilidad marginal de goles como visitante
  proba_away <- freq_away / length(data$FTAG)
  prop.table(freq_away) #Mismo resultado
  
  
  # Tabla de probailidades de goles en casa y visitante
  proba_away <- as.data.frame(proba_away)
  proba_home <- as.data.frame(proba_home)
  
  proba_away <- rename(proba_away, goles = Var1, Proba_Away = Freq)
  proba_home <- rename(proba_home, goles = Var1, Proba_Home = Freq)
  
  
  library(dplyr)
  tabla <- full_join(proba_home, proba_away, by = "goles")
  tabla
  
  
  # PROBABILIDAD CONJUNTA
  # 3. Probabilidad conjunto
  conj <- freq_conjunta/length(freq_conjunta)
  names(dimnames(freq_conjunta)) <- c("Home", "Away") 
  prop.table(freq_conjunta)
  
  
  
  
  
  