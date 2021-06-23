  
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
  data.soccer <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
  data.soccer
  
  #Del data frame que resulta de importar los datos a R, extrae las columnas que 
  #contienen los números de goles anotados por los equipos que jugaron en casa (FTHG) 
  #y los goles anotados por los equipos que jugaron como visitante (FTAG)
  data.soccer$FTHG
  data.soccer$FTAG
  
  #Consulta cómo funciona la función table en R al ejecutar en la consola ?table
  ?table
  
  #Posteriormente elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
  # Qué es frecuencia relativa??? https://economipedia.com/definiciones/frecuencia-relativa.html
  #Conteo de goles
  goles.TH <- table(data.soccer$FTHG)
  goles.TA <- table(data.soccer$FTAG)
  #frecuencias relativas
  goles.FRTH <- goles.TH/sum(goles.TH)
  goles.FRTA <- goles.TA/sum(goles.TA)
  #prop.table(goles.TH) #esta línea es solo para comprobar resultados prop.table ya hace todo el calculo.
  
  #La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
  
  x <- 1 #Este entero representa la posicion del array en el paste se resta una unidad para presentar la cantidad de goles posicion 1 es igual a goles 0 y así sucesivamente
  paste("La probabilidad de que la casa anote", x-1, "goles es de: ", goles.FRTH[x]*100, "%")
  
  #La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
  y <- 2 #Este entero representa la posicion del array en el paste se resta una unidad para presentar la cantidad de goles posicion 1 es igual a goles 0 y así sucesivamente
  paste("La probabilidad de que el visitente anote", y-1, "goles es de: ", goles.FRTA[y]*100, "%")
  #La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega 
  #como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
  
  paste("La probabilidad de que la casa anote", x-1, "goles y el visitente anote", y-1, "goles es de:", (goles.FRTH[x]*goles.FRTA[y])*100, "%")
  
  
