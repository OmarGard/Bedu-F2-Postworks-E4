# Postwork Sesión 2.

#### Objetivo

- Importar múltiples archivos csv a `R`
- Observar algunas características y manipular los data frames
- Combinar múltiples data frames en un único data frame

#### Requisitos

1. Tener instalado R y RStudio
2. Haber realizado el prework y estudiado los ejemplos de la sesión.

#### Desarrollo

Ahora vamos a generar un cúmulo de datos mayor al que se tenía, esta es una situación habitual que se puede presentar para complementar un análisis, siempre es importante estar revisando las características o tipos de datos que tenemos, por si es necesario realizar alguna transformación en las variables y poder hacer operaciones aritméticas si es el caso, además de sólo tener presente algunas de las variables, no siempre se requiere el uso de todas para ciertos procesamientos.

1. Importa los datos de soccer de las temporadas 2017/2018, 2018/2019 y 2019/2020 de la primera división de la liga española a `R`, los datos los puedes encontrar en el siguiente enlace: https://www.football-data.co.uk/spainm.php

2. Revisa la estructura de de los data frames al usar las funciones: `str`, `head`, `View` y `summary`

3. Con la función `select` del paquete `dplyr` selecciona únicamente las columnas `Date`, `HomeTeam`, `AwayTeam`, `FTHG`, `FTAG` y `FTR`; esto para cada uno de los data frames. (Hint: también puedes usar `lapply`).

4. Asegúrate de que los elementos de las columnas correspondientes de los nuevos data frames sean del mismo tipo (Hint 1: usa `as.Date` y `mutate` para arreglar las fechas). Con ayuda de la función `rbind` forma un único data frame que contenga las seis columnas mencionadas en el punto 3 (Hint 2: la función `do.call` podría ser utilizada).

__Notas para los datos de soccer:__ https://www.football-data.co.uk/notes.txt
    
### Solución

1. Importamos la librería `dplyr` y cargamos los datos
```r
library(dplyr)

    df.2017 <- "https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/source_data/postwork_2/SP1-1718.csv"
    df.2018 <- "https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/source_data/postwork_2/SP1-1819.csv"
    df.2019 <- "https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/source_data/postwork_2/SP1-1920.csv"
    
    download.file(url = df.2017, destfile = "df.2017.csv", mode = "wb")
    download.file(url = df.2018, destfile = "df.2018.csv", mode = "wb")
    download.file(url = df.2019, destfile = "df.2019.csv", mode = "wb")
```    
    
2. Guardamos los archivos en una lista para facilitar manipulación y revisamos la estructura
```r
    files <- lapply(dir(), read.csv)
    str(files)
    head(files)
    summary(files)
    View(files)
 ```
3. Seleccionamos columnas de interés
 ```r
    files <- lapply(files, select, Date, HomeTeam:FTR)
 ```
    
4. Acomodamos fechas
 ```r   
    files <- lapply(files, mutate, Date = as.Date(Date,"%d/%m/%y"))
    files[2] 
    
    D1_17_18_19 <- do.call(rbind, files)
    head(D1_17_18_19)
    dim(D1_17_18_19)
 ```
    
 Por último, guardamos el archivo
 ```r
    write.csv(D1_17_18_19,"D1_17_18_19.csv")
 ```
