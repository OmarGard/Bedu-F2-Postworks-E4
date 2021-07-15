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
        autoplot(ts.colour = "#0D3B66") +
        ggtitle("Promedio de la suma mensual total de goles") +
        xlab("Año") + ylab("Promedio de goles") +
        theme_test() +
        geom_hline(aes(yintercept = mean(serie), color="media")) +
        scale_color_manual(name = "Estadísticos", values = c(media = "#EE964B"))
    # Notamos que nuestra serie tiene una media que parece constante, pero una varianza que no lo es, 
    # así que esto no la hace una gran candidata a ser una serie estacionaria
    
    # Podemos analizar el correlograma de la serie y el parcial de la serie, y podemos notar
    # que no es tan sencillo determinar los efectos de valores anteriores en los valores futuros
    # de la serie de tiempo
    
    acf(serie, lag.max = 50)
    pacf(serie, lag.max = 50)
    
    # Vamos a realizar una prueba de hipótesis para determinar si nuestra prueba es estacionaria
    # para poder ver si podemos aplicar algún modelo de autoregresión sobre ella, 
    # para ello tomaremos como hipótesis nula que nuestra serie contiene alguna raíz unitaria: 
    # H0: φ = 1 -> Presenta una tendencia estocástica y no es una serie estacionaria
    # H1: φ < 1 -> No presenta tendencia estocástica y es estacionaria
    
    # Y probaremos dicha hipótesis con una prueba de Dicky-Fuller Aumentada con el comando 
    # ur.df que viene de Unit Root Dickey - Fuller en inglés
    
    library(urca)
    y2 <- ur.df(serie,type="none", selectlags="AIC")
    summary(y2)  
    y2
    # ############################################### 
    # # Augmented Dickey-Fuller Test Unit Root Test # 
    # ############################################### 
    # 
    # Test regression none 
    # 
    # 
    # Call:
    #     lm(formula = z.diff ~ z.lag.1 - 1 + z.diff.lag)
    # 
    # Residuals:
    #     Min       1Q   Median       3Q      Max 
    # -1.15512 -0.21988  0.03193  0.20536  0.93389 
    # 
    # Coefficients:
    #     Estimate Std. Error t value Pr(>|t|)    
    # z.lag.1    -0.004696   0.013194  -0.356    0.723    
    # z.diff.lag -0.515050   0.082727  -6.226 9.14e-09 ***
    #     ---
    #     Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
    # 
    # Residual standard error: 0.3799 on 109 degrees of freedom
    # Multiple R-squared:  0.2668,	Adjusted R-squared:  0.2534 
    # F-statistic: 19.84 on 2 and 109 DF,  p-value: 4.501e-08
    # 
    # 
    # Value of test-statistic is: -0.3559 
    # 
    # Critical values for test statistics: 
    #     1pct  5pct 10pct
    # tau1 -2.58 -1.95 -1.62
    
    
    # Notamos que para un valor del 99%, 95% y 90% de significancia, el estadístico de prueba 
    # supera a todas las pruebas, así que por lo tanto nuestra serie es no estacionaria
    
    
    # Partiendo de la hipótesis de que la serie tiene raíces unitarias, podemos idealizar una forma 
    # en la que podemos hacer nuestra serie estacionaria
    
    # Supongamos que nuestra serie se puede modelas de la siguiente forma:
    # Y_t = B_0 + B_1 * t + e_t
    # Donde:
    # Y_t -> El valor actual de la serie
    # B_0 -> Un coeficiente de intercepto
    # B_1 -> Un coeficiente de la variable de tiempo
    # e_t -> Un error proveniente de una distribución normal que puede ser ruido blanco
    
    # Definimos 
    # z_t = y_t - y_(t-1) [Calculamos la diferencia entre un valor y su consecutivo para Y]
    # 
    # Entonces sustituyendo
    # = (B_0 + B_1 * t + e_t) - (B_0 + B_1 * t_(t-1) + e_(t-1))
    # = B_1 + (e_t - e_(t-1))
    # 
    # Ahora si observamos la esperanza de la nueva serie, podemos notar que 
    # E(Z_t) = B_1 ya que B_1 es una constante así que no se ve afectada, y (e_t - e_(t-1)) son errores que 
    #            se asumen vienen de una distribución de ruido blanco o normal N(0,..)    
    #            
    # Y si observamos la varianza, podemos notar que 
    # Var(Z_t) = 2K^2 ya que B_1 es una constante, así que no afecta la varianza, y (e_t - e_(t-1)) son errores
    # independientes uno del otro, ya que vienen de una distribución normal, así que podemos tomar la suma 
    # de sus varianzas, y supongamos que la varianza de e_t es algún número K^2, entonces la varianza de  e_(t-1) es
    # igual k^2 ya que provienen de la misma distribución, entonces nos queda K^2 + K^2 = 2K^2
    # 
    # Entonces tenemos que la nueva serie de diferencias tiene una media y una varianza constante, por lo 
    # tanto, debe de ser estacionaria, este proceso lo podemos repetir varias veces hasta obtener una serie estacionaria proveniente 
    # de nuestra serie original
    # 
    # Para calcular el número de veces, realizaremos una prueba de Dickey - Fuller para cada iteración de
    # diferencias, obteniendo lo siguiente
    # 
    library(forecast)
    ndiffs(serie)
    # [1] 1
    # Entonces debemos realizar solo una serie de diferencias, para obtener una serie que sea estacionaria
    
    serie.diff <- diff(serie)
    
    # Ploteamos la nueva serie para ver los resultados
    serie.diff %>%
        autoplot(ts.colour = "#0D3B66") +
        ggtitle("Promedio de la suma mensual total de goles (Serie diferenciada)") +
        xlab("Año") + ylab("Promedio de goles") +
        theme_test() +
        geom_hline(aes(yintercept = mean(serie.diff), color="media")) +
        scale_color_manual(name = "Estadísticos", values = c(media = "#EE964B"))
    
    # Tenemos un mejor correlograma  total y parcial para nuestra serie de tiempo
    acf(serie.diff, lag.max = 50)
    pacf(serie.diff, lag.max = 50)
    
    # Realizamos una prueba de Dickey - Fuller para corroborar los resultados
    y3 <- ur.df(serie.diff,type="none", selectlags="AIC")
    summary(y3) 
    
    # Value of test-statistic is: -13.8505 
    # 
    # Critical values for test statistics: 
    #     1pct  5pct 10pct
    # tau1 -2.58 -1.95 -1.62
    
    # Ahora podemos notar que el valor del estadístico de prueba es -13.8505, y es muchísimo menor que 
    # cualquier valor de significancia del 99%,95% y 90%
    # Por lo tanto tenemos una serie estacionaria a la cuál le podemos aplicar algún modelo de autoregresión
    
    
    
    # ===========================================================
    # Moelo Autorregresio de Medias moviles (ARMA)
    # ===========================================================
    # Trabajar con series de tiempo nos permite ampliar el análisis de los datos
    # para realizar predicciones futuras utilizando la infomación disponible del pasado.
    
    # Una vez que nuestro modelo es estacionario con una diferencia, procederesmo a aplicarle un 
    # modelo ARIMA(5,1,2)
    # Lo anterior debido a los resultados arrojados por los correlogramas acf y pacf,
    
    # Aplicamos el modelo con 5 auto regresivos, una diferencia y dos medias movil
    modelo_1 <- arima(serie, order = c(5,1,2))
    
    # Observamos el diagnostico del modelo
    # En donde se observa que los errores estandarizados tienen un comportamiento de ruido blanco
    # Mientras que los valores p del estadistico Ljung-Box se encuentran por encima de 0.05
    tsdiag(modelo_1)
    
    # Aplicamos el test de Ljung-Box para comprobar si hay ruido blanco
    # donde: 
    # Ho = Hay presencia de ruido blanco
    # Ha = No hay presencia de ruido blanco
    Box.test(residuals(modelo_1), type ="Ljung-Box")
    
    # Observamos el comportamiento de los residuos
    plot(residuals(modelo_1), main = "Gráfico de los residuales", xlab = "Año", ylab ="")
    
    # Hacemos el pronostico para los proximos 12 meses
    pronostico <- forecast(modelo_1, 12)
    
    # Veamos que ademas de tener el forecast, tambien podemos observar el limite superior e inferior a un 
    # 80 y 95% de confianza
    
    # Graficamos el forecast
    plot(pronostico, main = "Pronóstico del promedio de goles para el próximo año",
         xlab = "años", ylab = "Promedio de goles")
    
    # Con ggplot
    pronostico %>%
        autoplot(ts.colour = "#0D3B66") +
        ggtitle("Promedio de la suma mensual total de goles (pronóstico)") +
        xlab("Año") + ylab("Promedio de goles") +
        theme_test() +
        geom_hline(aes(yintercept = mean(serie), color="media")) +
        scale_color_manual(name = "Estadísticos", values = c(media = "#EE964B"))
    
    
    
