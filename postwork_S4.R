  # ############################################################################
  #                               EQUIPO 4
  #                           Sesion-4 Postwork
  # ############################################################################
  
  # Ahora investigarás la dependencia o independencia del número de goles anotados 
  # por el equipo de casa y el número de goles anotados por el equipo visitante 
  # mediante un procedimiento denominado bootstrap.
  
  # 1. Obtén una tabla de cocientes al dividir estas probabilidades conjuntas por 
  # el producto de las probabilidades marginales correspondientes.
  
  # 2. Mediante un procedimiento de boostrap, obtén más cocientes similares a los obtenidos en la tabla del punto anterior. 
  # Esto para tener una idea de las distribuciones de la cual vienen los cocientes en la tabla anterior. 
  # Menciona en cuáles casos le parece razonable suponer que los cocientes de la tabla en el punto 1, 
  # son iguales a 1 (en tal caso tendríamos independencia de las variables aleatorias X y Y).
  
  library(ggplot2)
  library(hrbrthemes)
  library(plotly)
  library(dplyr)
  library(boot)
  
  getwd()
  setwd("~/Bedu-S2-Postworks-E4")
  
  # Importamos el dataframe almacenado como csv del postwork 2
  data <- read.csv("./data/postwork_2/D1_17_18_19.csv")
  
  # Verificamos su estructura
  head(data)
  
  # Generamos la tabla de contingencia para generar las probabilidades relativas
  contingency_table <- table(data[,c("FTHG","FTAG")])
  contingency_table
  
  # Añadimos los márgenes(totales) para cada columna y fila
  contingency_table <- addmargins(contingency_table)
  contingency_table
  
  # Dividimos cada celda por el total de goles(1140) para obtener las probabilidades relativas
  contingency_table <- contingency_table / contingency_table["Sum","Sum"]
  contingency_table
  
  # Generamos la tabla de cocientes
  quotients <- contingency_table
  for (i in 1:(nrow(contingency_table)-1)){
    for(j in 1:(ncol(contingency_table)-1)){
      quotients[i,j] <- contingency_table[i,j]/(contingency_table[i,"Sum"] * contingency_table["Sum",j])
    }
  }
  quotients
  
  # Convertimos los cocientes a df para manipularlos
  df <- data.frame(quotients)
  df
  
  # Eliminamos los registros de Sum
  df <- filter(df, FTHG != "Sum" & FTAG != "Sum")
  df
  
  # Obtenemos una muestra inicial de la cuál se hará el bootstrapping
  sample <- df[sample(nrow(df),8),]
  sample
  
  # Funcion para calcular los estadísticos del bootstrapping
  foo <- function(data, indices)
  {
    dt <- data[indices,]
    c(median(dt[,3]),mean(dt[,3]))
  }
  
  # Generamos 1000 muestras de bootstrap a partir de la muestra sample
  set.seed(12345)
  myBootstrap <- boot(sample, foo, R = 1000)
  myBootstrap
  
  # Valores estadísticos calculados de cada muestra bootstrap
  head(myBootstrap$t)
  
  # Gráfica de la distruibución de las medias de las muestras bootstrap
  plot(myBootstrap, index = 2)
  
  # NOTA SOBRE INDEPENDENCIA DE LAS VARIABLES
  # Cuando los eventos son mutuamente excluyentes (Independientes), 
  # la probabilidad conjunta de A y B es igual a la probabilidad marginal de A multiplicada por la de B, 
  # P(A y B) = P(A) * P(B).
  
  # Asi, en nuestra tabla de cocientes, tenemos la probabilidad conjunta dividida entre la
  # probabilidad de las probas marginales. Por lo que un cociente de 1 implicaria que estamos
  # dividiendo entre la probabilidad conjunta, es decir que los eventos son mutuamente excluyentes
  
  # Por lo tanto considerando nuevamente neustra tabla de cocientes.
  quotients
  
  # Notemos que la matriz de goles de 0 a son los que estan mas cercanos a 1
  # Esto lo podemos deber a que las probabilidades de meter menos goles es mayor,
  # mientras que un partido con mas de 3 goles tiene menos porbabilidad de ocurrencia.
  
