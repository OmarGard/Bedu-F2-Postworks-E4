    # ##########################################################################
    #                         Sesion_6 postwork
    # ##########################################################################
    
    # SERIES DE TIEMPO
    
    # Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:
    # 1. Agrega una nueva columna sumagoles que contenga la suma de goles por partido.
    # 2. Obtén el promedio por mes de la suma de goles.
    # 3. Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.
    # 4. Grafica la serie de tiempo.
    
    library(dplyr)
    
    data <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-06/Postwork/match.data.csv")
    head(data)
    
    # 1. Suma total de goles
    data <- data %>% mutate(sumagoles = home.score + away.score)
    head(data) 
    
    # 2. Promedio mensual del total de goles
    str(data)
    data <- data %>% mutate(date = as.Date(date))
    
    # Extraemos los meses y anios
    data <- data %>% mutate(mes = as.numeric(format(date, '%m')),
                            anio = as.numeric(format(date, '%Y')))
    head(data)
    
    # Sacamos promedio mensual
    promedio <- data %>% 
        select(sumagoles, mes, anio) %>%
        group_by(anio, mes) %>%
        summarise(promedio = mean(sumagoles))
    
    
    # 3. Serie de tiempo del promedio mensual del total de goles
    serie <- ts(promedio$promedio, start = c(2010,8), end = c(2019,12), frequency = 12)
    
    # 4. Grafico del pormedio mensual del total de goles
    plot(serie, main = "Promedio mesual del total de goles", xlab = "Periodo", ylab = "Promedio de goles")
    
    
    # Con ggplot
    library(ggplot2)
    library(ggfortify)
    serie %>%
        autoplot(ts.colour = "blue") +
        ggtitle(" Promedio mensual del total de goles") +
        xlab("Año") + ylab("Promedio de goles") +
        theme_test()
    
