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
    
    #Importa los datos de soccer de las temporadas 2017/2018, 2018/2019 y 2019/2020 
    #de la primera división de la liga española a R, los datos los puedes encontrar 
    #en el siguiente enlace: https://www.football-data.co.uk/spainm.php
    
    
    library(dplyr)
    
    # Agregar aqui el directorio de almacenamiento de los datos y luego correr el codigo
    # Nota: si deescargo el repositorio completo, elimine los archivos de la carpeta
    # data/postwork_2, los cuales se almacenaran una vez se corra el codigo. 
    
    rootwd <- "E:/ecardoz/Bedu-F2-Postworks-E4"
    
    setwd(paste0(rootwd,"/output_data/postwork_2"))
    
    # 1. Cargamos los datos
    df.2017 <- "https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/source_data/postwork_2/SP1-1718.csv"
    df.2018 <- "https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/source_data/postwork_2/SP1-1819.csv"
    df.2019 <- "https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/source_data/postwork_2/SP1-1920.csv"
    
    download.file(url = df.2017, destfile = "df.2017.csv", mode = "wb")
    download.file(url = df.2018, destfile = "df.2018.csv", mode = "wb")
    download.file(url = df.2019, destfile = "df.2019.csv", mode = "wb")
    
    
    # 2. Guardamos los archivos en una lista para facilirtar manipulacion y revisamos la estructura
    files <- lapply(dir(), read.csv)
    str(files)
    head(files)
    summary(files)
    View(files)
    
    # 3. Seleccionamos columnas de interes
    files <- lapply(files, select, Date, HomeTeam:FTR)
    
    # 4. Acomodamos fechas
    files[1] <- lapply(files[1], mutate, Date = as.Date(Date, "%Y-%m-%d"))
    
    files <- lapply(files, mutate, Date = as.Date(Date,"%d/%m/%y"))
    files[2] 
    
    D1_17_18_19 <- do.call(rbind, files)
    head(D1_17_18_19)
    dim(D1_17_18_19)
    
    # Guardamos el archivo
    write.csv(D1_17_18_19,"D1_17_18_19.csv")
    
    
    
    