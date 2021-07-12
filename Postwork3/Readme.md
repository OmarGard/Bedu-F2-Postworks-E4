# Postwork Sesión 3

#### Objetivo

- Realizar descarga de archivos desde internet
- Generar nuevos data frames
- Visualizar probabilidades estimadas con la ayuda de gráficas

#### Requisitos

1. R, RStudio
2. Haber realizado el prework y seguir el curso de los ejemplos de la sesión
3. Curiosidad por investigar nuevos tópicos y funciones de R

#### Desarrollo

Ahora graficaremos probabilidades (estimadas) marginales y conjuntas para el número de goles que anotan en un partido el equipo de casa o el equipo visitante.

1. Con el último data frame obtenido en el postwork de la sesión 2, elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:

- La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)

- La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)

- La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)

2. Realiza lo siguiente:

- Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa.
- Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
- Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.

__Notas para los datos de soccer:__ https://www.football-data.co.uk/notes.txt

### Solución

Cargamos las librerías necesarias
```r
  library(ggplot2)
  library(hrbrthemes)
  library(plotly)
  library(dplyr)
```  
  
Importamos el dataframe almacenado como csv del postwork 2
  ```r
  data <- read.csv("https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/output_data/postwork_2/D1_17_18_19.csv")
  ```
  
 Verificamos su estructura
 ```r
  head(data)
 ```
  
 Generamos la tabla de contingencia para obtener las frecuencias relativas
  ```r
  contingency_table <- table(data[,c("FTHG","FTAG")])
  contingency_table
  ```
  
 Añadimos los márgenes para cada columna y fila
 ```r
  contingency_table <- addmargins(contingency_table)
  contingency_table
  ```
  
  #### 1. PROBABILIDADES MARGINALES
  Dividimos cada celda por el total de goles para obtener las probabilidades
  ```r
  for (i in 1:nrow(contingency_table)){
    for(j in 1:ncol(contingency_table)){
      contingency_table[i,j] <- contingency_table[i,j]/contingency_table["Sum","Sum"]
    }
  }
  contingency_table
  ```
  
  Probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)
  ```r
  for(i in 1:(nrow(contingency_table)-1)){
    print(paste("Probabilidad marginal de que el equipo en casa anote", i-1, "goles:", contingency_table[i,8]))
  }
  ```
  
  Probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)
  ```r
  for(i in 1:(ncol(contingency_table)-1)){
    print(paste("Probabilidad marginal de que el equipo visitante anote ", i-1, "goles:", contingency_table[10,i]))
  }
  ```
  
  La probabilidad conjunta
  ```r
  for (i in 1:(nrow(contingency_table)-1)){
    for(j in 1:(ncol(contingency_table)-1)){
      print(paste("Probabilidad conjunta de que el equipo en casa anote", i-1, "goles y el equipo visitante anote",j-1,"goles:", contingency_table[i,j]))
    }
  }
  ```
  #### 2. GRAFICOS DE LAS PROBABILIDADES
  Creación de gráfico de goles anotados como visitante
  ```r
  barplot(contingency_table[-10,"Sum"],
          xlab="Número de goles anotados",
          ylab="Probabilidades",
          main="Probabilidades marginales del número\n de goles que anota el equipo de casa", 
          names.arg=rownames(contingency_table[-10,]),
          col="#70D1E0")
  ```
  ![proba_num_goles_equipo_casa](https://user-images.githubusercontent.com/60225087/125330471-7101fb00-e30c-11eb-9281-331ce84ec0cb.png)

  Creación de gráfico de goles anotados en casa
  ```r
  barplot(contingency_table["Sum",-8],
          xlab="Número de goles anotados",
          ylab="Probabilidades",
          main="Probabilidades marginales del número\n de goles que anota el equipo visitante", 
          names.arg=colnames(contingency_table[,-8]),
          col="#9835A4")
  ```
  
  Convertimos la tabla a dataframe para poder generar el heatmap de probabilidades conjuntas
  ```r
  df <- data.frame(contingency_table)
  ```
  
  Eliminamos los valores marginales
  ```r
  df <- filter(df,FTHG != "Sum" & FTAG != "Sum")
  ```
  
  Añadimos una columna de texto para el plot interactivo
  ```r
  df <- df %>%
    mutate(text = paste0("Goles casa: ", FTHG, "\n", "Goles visitante: ", FTAG, "\n", "Prob: ",round(Freq*100,2), "%\n"))
  df
  ```
  
  Creación de un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.
  ```r
  heatmap <- ggplot(df, aes(FTHG, FTAG, fill= Freq, text=text)) + 
    geom_tile() +
    xlab("Goles del equipo en casa") + 
    ylab("Goles del equipo visitante") +
    labs(title="Probabilidades conjuntas de los números\n de goles del equipo en casa y visitante", fill="Prob") + 
    theme_ipsum()
  ggplotly(heatmap, tooltip="text")
  ```
