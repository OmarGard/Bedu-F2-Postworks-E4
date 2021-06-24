  
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
  LigaEsp1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
  
  download.file(url = LigaEsp1920, destfile = "LigaEsp1920.csv", mode = "wb")
  
  datainicial <-  read.csv("LigaEsp1920.csv")
  #2.Extrae las columnas FTHG y FTAG.
  datainicial<-datainicial[ ,c(6:7)]
  #3.Elabora tablas de frecuencias relativas.
  (freqFTHG<-table(datainicial$FTHG))
  (freqFTAG<-table(datainicial$FTAG))
  (freqBoth<-table(datainicial))
  #La probabilidad (marginal) de que el equipo que juega en casa anote x goles
  (margHome <- freqFTHG / length(datainicial$FTHG))
  prop.table(freqFTHG) #Mismo resultado
  #La probabilidad (marginal) de que el equipo que juega como visitante anote x goles
  (margAway <- freqFTAG / length(datainicial$FTAG))
  prop.table(freqFTAG) #Mismo resultado
  #La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles
  (conj<-freqBoth/380)
  prop.table(freqBoth)