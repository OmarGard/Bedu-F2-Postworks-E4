# ############################################################################
#                               EQUIPO 4
#                           Sesion-3 Postwork
# ############################################################################

# 1. Con el último data frame obtenido en el postwork de la sesión 2, elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
# - La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)
# - La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)
# - La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)

# 2. Realiza lo siguiente:
# - Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa.
# - Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
# - Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.
library(ggplot2)
library(hrbrthemes)
library(plotly)
library(dplyr)
library(boot)

getwd()
setwd("/Users/omargard/Documents/Personal/Bedu/Fase2/S3/PostWork/Files")

# Importamos el dataframe almacenado como csv del prework 2
data <- read.csv("D1_17_18_19.csv")

# Verificamos su estructura
head(data)

# Generamos la tabla de contingencia para generar las probabilidades relativas
contingency_table <- table(data[,c("FTHG","FTAG")])
contingency_table

# Añadimos los márgenes para cada columna y fila
contingency_table <- addmargins(contingency_table)
contingency_table
# Dividimos cada celda por el total de goles para obtener las probabilidades relativas
contingency_table <- contingency_table / contingency_table["Sum","Sum"]
contingency_table

#Generamos la tabla de cocientes
quotients <- contingency_table
for (i in 1:(nrow(contingency_table)-1)){
  for(j in 1:(ncol(contingency_table)-1)){
    quotients[i,j] <- contingency_table[i,j]/(contingency_table[i,"Sum"] * contingency_table["Sum",j])
  }
}
quotients

#Convertimos los cocientes a df para manipularlos
df<- data.frame(quotients)
df
# Eliminamos los registros de Sum
df<-filter(df,FTHG!="Sum" & FTAG!="Sum")
df
# Obtenemos una muestra inicial de la cuál se hará el bootstrapping
sample <- df[sample(nrow(df),8),]
sample

#Funcion para calcular los estadísticos del bootstrapping
foo <- function(data, indices)
{
  dt<-data[indices,]
  c(median(dt[,3]),mean(dt[,3]))
}
# Generamos 1000 muestras de bootstrap a partir de la muestra sample
set.seed(12345)
myBootstrap <- boot(sample, foo, R=1000)
myBootstrap
# Valores estadísticos calculados de cada muestra bootstrap
head(myBootstrap$t)
# Gráfica de la distruibución de las medias de las muestras bootstrap
plot(myBootstrap, index=2)

# TODO:
# - Refactorizar algunos nombres de variables si gustan
# - Colocar la última parte de los 1's de la tabla quotients'
