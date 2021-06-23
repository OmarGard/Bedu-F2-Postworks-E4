  
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
  df = read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
  
  # 2. Extraemos columnas de goles en casa y visitantes
  goles <- list(df$FTHG, df$FTAG)
  goles
  
  # 3. Consultar la funcion table()
  ?table # Crea una tabla de frecuencias de un conjunto de datos
  
  
  
  # Posteriormente elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
  # 1. La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
  # 2. La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
  # 3. La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y 
  # el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
  
  # Cargamos la siguiente biblioteca para facilitar la manifuacion del dataset
  library(dplyr)
  
  # Veamos los valores de las variables que ocuparemos (numero de goles)
  sort(unique(df$FTHG))
  sort(unique(df$FTAG))
  
  freq_home <- data.frame(table(goles[1]))
  freq_away <- data.frame(table(goles[2]))
  
  freq_home <- rename(freq_home, goles = Var1)
  freq_away <- rename(freq_away, goles = Var1)
  
  # Agregando probabilidades marginales
  freq_home <- mutate(freq_home, goles = as.numeric(goles), prob_home = Freq/sum(Freq))
  freq_away <- mutate(freq_away, goles = as.numeric(goles), prob_away = Freq/sum(Freq))
  
  
  # Tabla Final con Frecuencia y probabilidaddes marginales
  tabla <- full_join(freq_home, freq_away, by = 'goles')
  tabla
  
  
  ###### REVISAR ESTA PARTE DE PROBA CONJUNTA
  conjunta <- data_frame()
  indice <- 1
  

  # probabilidad conjunta
  for (i in 1:length(freq_home$goles)) {
    for (j in 1:length(freq_away$goles)) {
      conjunta[indice,1] <- freq_home$goles[i]
      conjunta[indice,2] <- freq_away$goles[j]
      conjunta[indice,3] <- freq_home$prob[i] * freq_away$prob[j]
      indice <- indice + 1
    }
  }
  
  conjunta <- rename(conjunta, goles_casa = 1, goles_visita = 2, probabilidad = 3)
  conjunta
  