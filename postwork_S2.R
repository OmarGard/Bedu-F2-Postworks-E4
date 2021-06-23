    # ############################################################################
    #                               EQUIPO 4
    #                           Sesion-2 Postwork
    # ############################################################################
    
    
    # 1. Importa los datos de soccer de las temporadas 2017/2018, 2018/2019 y 2019/2020 de la 
    # primera división de la liga española a R, los datos los puedes encontrar en el siguiente enlace: 
    # https://www.football-data.co.uk/spainm.php
    
    # 2.Revisa la estructura de de los data frames al usar las funciones: str, head, View y summary
    
    # 3. Con la función select del paquete dplyr selecciona únicamente las columnas 
    # Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR; esto para cada uno de los data frames. 
    # (Hint: también puedes usar lapply).
    
    # 4. Asegúrate de que los elementos de las columnas correspondientes de los nuevos data frames sean 
    # del mismo tipo (Hint 1: usa as.Date y mutate para arreglar las fechas). 
    # Con ayuda de la función rbind forma un único data frame que contenga las seis columnas mencionadas 
    # en el punto 3 (Hint 2: la función do.call podría ser utilizada).
    
    library(dplyr)
    
    # Agergar aqui el directorio de al macenamiento de los datos y luego correr el codigo
    dir <- "/Users/omargard/Documents/Personal/Bedu/Fase2/S2/PostWork/Files"
    dir <- "C:/Users/GOMEZ/Documents/BEDU_Santander/Programación y Estadística con R/sesion_4"
    setwd(dir)
    
    # 1. Cargamos los datos
    df.2017 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
    df.2018 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
    df.2019 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
    
    download.file(url = df.2017, destfile = "df.2017.csv", mode = "wb")
    download.file(url = df.2018, destfile = "df.2018.csv", mode = "wb")
    download.file(url = df.2019, destfile = "df.2019.csv", mode = "wb")
    
    
    # 2. Guardamos los archivos en una lista para facilirtar manipulacion y revisamos la estructura
    files <- lapply(dir(), read.csv)
    str(files)
    
    # 3. Seleccionamos columnas de interes
    files <- lapply(files, select, Date, HomeTeam:FTR)
    
    # 4. Acomodamos fechas
    files <- lapply(files, mutate, Date = as.Date(Date,"%d/%m/%y"))
    files[2] 
    
    mydf <- do.call(rbind, files)
    head(mydf)
    dim(mydf)
    
    
    
