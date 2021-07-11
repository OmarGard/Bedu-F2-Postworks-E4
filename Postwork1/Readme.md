# Postwork Sesión 1.

#### Objetivo

El Postwork tiene como objetivo que practiques los comandos básicos aprendidos durante la sesión, de tal modo que sirvan para reafirmar el conocimiento. Recuerda que la programación es como un deporte en el que se debe practicar, habrá caídas, pero lo importante es levantarse y seguir adelante. Éxito

#### Requisitos
- Concluir los retos
- Haber estudiado los ejemplos durante la sesión

#### Desarrollo

El siguiente postwork, te servirá para ir desarrollando habilidades como si se tratara de un proyecto que evidencie el progreso del aprendizaje durante el módulo, sesión a sesión se irá desarrollando. A continuación aparecen una serie de objetivos que deberás cumplir, es un ejemplo real de aplicación y tiene que ver con datos referentes a equipos de la liga española de fútbol (recuerda que los datos provienen siempre de diversas naturalezas), en este caso se cuenta con muchos datos que se pueden aprovechar, explotarlos y generar análisis interesantes que se pueden aplicar a otras áreas. Siendo así damos paso a las instrucciones: 

1. Importa los datos de soccer de la temporada 2019/2020 de la primera división de la liga española a `R`, los datos los puedes encontrar en el siguiente enlace: https://www.football-data.co.uk/spainm.php

2. Del data frame que resulta de importar los datos a `R`, extrae las columnas que contienen los números de goles anotados por los equipos que jugaron en casa (FTHG) y los goles anotados por los equipos que jugaron como visitante (FTAG)

3. Consulta cómo funciona la función `table` en `R` al ejecutar en la consola `?table`
 
Posteriormente elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:

- La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
- La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
- La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)

__Notas para los datos de soccer:__ https://www.football-data.co.uk/notes.txt

### Solución
1. Descargamos los datos y los importamos en nuestra sesión de RStudio
```r
data <-  read.csv("https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/source_data/postwork_1/SP1.csv")
```
  2. Extraemos las columnas de goles en casa(FTHG) y visitante(FTAG)
```r
  data <- data[ ,c(6:7)]
```
  3. Elabora tablas de frecuencias relativas.
```r
  freq_home <-table(data$FTHG)
  freq_away <-table(data$FTAG)
  freq_conjunta <-table(data)
```
  4. Posteriormente elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
	  * La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
	  * La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
	  * La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)


Probabilidad marginal de goles en casa	
```r
proba_home <- freq_home / length(data$FTHG)
prop.table(proba_home) #Mismo resultado
```
Probabilidad marginal de goles como visitante
```r
proba_away <- freq_away / length(data$FTAG)
prop.table(freq_away) #Mismo resultado
```
Tabla de probabilidades de goles en casa y visitante
```r
proba_away <- as.data.frame(proba_away)
proba_home <- as.data.frame(proba_home)

proba_away <- rename(proba_away, goles = Var1, Proba_Away = Freq)
proba_home <- rename(proba_home, goles = Var1, Proba_Home = Freq)

library(dplyr)
tabla <- full_join(proba_home, proba_away, by = "goles")
tabla
```
Probabilidad conjunta
```r
  conj <- freq_conjunta/length(freq_conjunta)
  names(dimnames(freq_conjunta)) <- c("Home", "Away") 
  prop.table(freq_conjunta)
```
  



