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
  library(ggpubr)
  
  
  # Importamos el dataframe almacenado como csv del postwork 2
  data <- read.csv("https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/output_data/postwork_2/D1_17_18_19.csv")
  
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
  quotionents.df <- data.frame(quotients)
  head(quotionents.df)
  
  # Eliminamos los registros de Sum
  quotionents.df <- filter(quotionents.df, FTHG != "Sum" & FTAG != "Sum")
  
  # Establecemos la muestra de la cuál obtendremos las muestras bootstrap que es la tabla de los cocientes
  sample <-data[,c("FTHG","FTAG")]
 
  # Funcion para calcular los estadísticos del bootstrapping, que en este caso 
  # serán la media y mediana
  funcion.estadistico <- function(data, indices)
  {
    dt <- data[indices,]
    c_t <- table(dt)
    c_t <- addmargins(c_t)
    c_t <- c_t / c_t["Sum","Sum"]
    q_ <- c_t
    for (i in 1:(nrow(c_t)-1)){
      for(j in 1:(ncol(c_t)-1)){
        q_[i,j] <- c_t[i,j]/(c_t[i,"Sum"] * c_t["Sum",j])
      }
    }
    q_.df <- data.frame(q_)
    q_.df <- filter(q_.df, FTHG != "Sum" & FTAG != "Sum")
    
    c(median(q_.df[,3]),mean(q_.df[,3]))
  }
  
  # Generamos 1000 muestras de bootstrap a partir de la muestra sample
  set.seed(12345)
  myBootstrap <- boot(sample, funcion.estadistico, R = 1000, )
  myBootstrap
  
  # ORDINARY NONPARAMETRIC BOOTSTRAP
  # 
  # 
  # Call:
  #   boot(data = sample, statistic = funcion.estadistico, R = 1000)
  # 
  # 
  # Bootstrap Statistics :
  #   original      bias    std. error
  # t1* 0.8814433 -0.05292374  0.08066186
  # t2* 0.8595706  0.03382926  0.07035373
  
  
  # Valores estadísticos calculados de cada muestra bootstrap
  # La primera columna corresponde a la mediana y la segunda a la media
  head(myBootstrap$t)
  #       [,1]      [,2]
  # [1,] 0.6453804 0.8205002
  # [2,] 0.9528055 0.9464532
  # [3,] 0.7947166 0.8607623
  # [4,] 0.7416081 0.8320753
  # [5,] 0.9243843 0.9104668
  # [6,] 0.9047260 0.8759573
  
  summary(myBootstrap)
  # Number of bootstrap replications R = 1000 
  # original  bootBias   bootSE bootMed
  # 1  0.88144 -0.052924 0.080662 0.83958
  # 2  0.85957  0.033829 0.070354 0.88652
  
  # NOTA SOBRE INDEPENDENCIA DE LAS VARIABLES
  # Cuando los eventos son mutuamente excluyentes (Independientes), 
  # la probabilidad conjunta de A y B es igual a la probabilidad marginal de A multiplicada por la de B, 
  # P(A y B) = P(A) * P(B).
  
  # Asi, en nuestra tabla de cocientes, tenemos la probabilidad conjunta dividida entre la
  # probabilidad de las probas marginales. Por lo que un cociente de 1 implicaria que estamos
  # dividiendo entre la probabilidad conjunta, es decir que los eventos son mutuamente excluyentes
  
  
  # Graficamos la distribución de las medias de las muestras bootstrap
  ggplot() +
    geom_histogram(aes(myBootstrap$t[,2]),binwidth=0.01, fill="#69b3a2", color="#e9ecef") +
    geom_vline(aes(xintercept=mean(myBootstrap$t[,2]),
                   color="media"), linetype="dashed",
               size=1) + 
    geom_vline(aes(xintercept=median(myBootstrap$t[,2]),
                   color="mediana"), linetype="dashed",
               size=1) + 
    scale_color_manual(name = "Estadísticos", values = c(mediana = "#114B5F", media = "#F45B69")) +
    xlab("Medias") +
    ylab("Frecuencias") +
    ggtitle("Histograma de distribución de medias Bootstrap") 
  

  # Tomando como recordatorio el teorema del límite central, sabemos que dada una muestra
  # de tamaño n > 30, la distribución de las medias muestrales tiende a ser una distribución normal. 
  # Así que podemos realizar una prueba de hipótesis para probar la independencia de las variables
  # ya que para que X y Y sean independientes, la media debe de ser igual 1
  
  # Podemos darnos una mejor idea de que es posible de que vengan de una distribución normal si observamos
  # la gráfica de cuantiles normales de las medias
  
  qqnorm(myBootstrap$t[,2])
  qqline(myBootstrap$t[,2])
  
  # De igual manera, podemos observar la gráfica de densidad para observar la curva de campana de nuestros datos
  ggdensity(myBootstrap$t[,2], 
            main = "Densidad de las medias muestrales Bootstrap",
            xlab = "Medias", ylab="Densidad")
 
  # Llevaremos a cabo una prueba de hipótesis para probar lo siguiente
  # H0:μ=1
  # H1:μ≠1
  
  t.test(x=myBootstrap$t[,2], mu = 1,alternative = "two.sided")
    
  # One Sample t-test
  # 
  # data:  myBootstrap$t[, 2]
  # t = -38.173, df = 999, p-value < 2.2e-16
  # alternative hypothesis: true mean is not equal to 1
  # 95 percent confidence interval:
  #   0.8512693 0.8658131
  # sample estimates:
  #   mean of x 
  # 0.8585412 
  
  # Podemos darnos cuenta que la prueba nos arroja un p-value muy pequeño, esto
  # nos da suficiente razón para rechazar la hipótesis nula de que la media es igual a 1
  # y declarar que las variables X y Y no son independientes
 
  
