# Postwork Sesión 4
 
#### Objetivo
Ahora investigarás la dependencia o independencia del número de goles anotados por el equipo de casa y el número de goles anotados por el equipo visitante mediante un procedimiento denominado bootstrap.

#### Instrucciones

1. Obtén una tabla de cocientes al dividir estas probabilidades conjuntas por el producto de las probabilidades marginales correspondientes.

2. Mediante un procedimiento de boostrap, obtén más cocientes similares a los obtenidos en la tabla del punto anterior. Esto para tener una idea de las distribuciones de la cual vienen los cocientes en la tabla anterior. Menciona en cuáles casos le parece razonable suponer que los cocientes de la tabla en el punto 1, son iguales a 1 (en tal caso tendríamos independencia de las variables aleatorias X y Y).

#### Soluciones
1. Cargar librerías

```r
  library(ggplot2)
  library(hrbrthemes)
  library(plotly)
  library(dplyr)
  library(boot)
  library(ggpubr)
```
2. Importamos el dataframe almacenado como csv del postwork 2
```r
  data <- read.csv("https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/output_data/postwork_2/D1_17_18_19.csv")
```
3. Verificamos su estructura
```r
  head(data)
  # X       Date   HomeTeam   AwayTeam FTHG FTAG FTR
  # 1 1 2017-08-18    Leganes     Alaves    1    0   H
  # 2 2 2017-08-18   Valencia Las Palmas    1    0   H
  # 3 3 2017-08-19      Celta   Sociedad    2    3   A
  # 4 4 2017-08-19     Girona Ath Madrid    2    2   D
  # 5 5 2017-08-19    Sevilla    Espanol    1    1   D
  # 6 6 2017-08-20 Ath Bilbao     Getafe    0    0   D
  ```
4. Generamos la tabla de contingencia para generar las probabilidades relativas
```r
  contingency_table <- table(data[,c("FTHG","FTAG")])
  
  contingency_table
  #     FTAG
  # FTHG   0   1   2   3   4   5   6
  # 0  89  92  52  21   6   5   0
  # 1 132 131  78  20  10   2   0
  # 2 100 107  70  13  10   2   2
  # 3  51  37  28   7   2   2   1
  # 4  16  12   8   0   4   0   0
  # 5  10   6   5   0   1   0   0
  # 6   3   2   0   1   0   0   0
  # 7   0   1   0   0   0   0   0
  # 8   0   0   1   0   0   0   0
```
5. Añadimos los márgenes(totales) para cada columna y fila
```r
  contingency_table <- addmargins(contingency_table)

  contingency_table
  #       FTAG
  # FTHG     0    1    2    3    4    5    6  Sum
  # 0     89   92   52   21    6    5    0  265
  # 1    132  131   78   20   10    2    0  373
  # 2    100  107   70   13   10    2    2  304
  # 3     51   37   28    7    2    2    1  128
  # 4     16   12    8    0    4    0    0   40
  # 5     10    6    5    0    1    0    0   22
  # 6      3    2    0    1    0    0    0    6
  # 7      0    1    0    0    0    0    0    1
  # 8      0    0    1    0    0    0    0    1
  # Sum  401  388  242   62   33   11    3 1140
```
6. Dividimos cada celda por el total de goles(1140) para obtener las probabilidades relativas
```r
  contingency_table <- contingency_table / contingency_table["Sum","Sum"]

  contingency_table
  #         FTAG
  # FTHG            0           1           2           3           4           5           6         Sum
  # 0   0.078070175 0.080701754 0.045614035 0.018421053 0.005263158 0.004385965 0.000000000 0.232456140
  # 1   0.115789474 0.114912281 0.068421053 0.017543860 0.008771930 0.001754386 0.000000000 0.327192982
  # 2   0.087719298 0.093859649 0.061403509 0.011403509 0.008771930 0.001754386 0.001754386 0.266666667
  # 3   0.044736842 0.032456140 0.024561404 0.006140351 0.001754386 0.001754386 0.000877193 0.112280702
  # 4   0.014035088 0.010526316 0.007017544 0.000000000 0.003508772 0.000000000 0.000000000 0.035087719
  # 5   0.008771930 0.005263158 0.004385965 0.000000000 0.000877193 0.000000000 0.000000000 0.019298246
  # 6   0.002631579 0.001754386 0.000000000 0.000877193 0.000000000 0.000000000 0.000000000 0.005263158
  # 7   0.000000000 0.000877193 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000 0.000877193
  # 8   0.000000000 0.000000000 0.000877193 0.000000000 0.000000000 0.000000000 0.000000000 0.000877193
  # Sum 0.351754386 0.340350877 0.212280702 0.054385965 0.028947368 0.009649123 0.002631579 1.000000000
```
7. Generamos la tabla de cocientes
```r
  quotients <- contingency_table
  
  for (i in 1:(nrow(contingency_table)-1)){
    for(j in 1:(ncol(contingency_table)-1)){
      quotients[i,j] <- contingency_table[i,j]/(contingency_table[i,"Sum"] * contingency_table["Sum",j])
    }
  }
  
  quotients
  #         FTAG
  # FTHG            0           1           2           3           4           5           6         Sum
  # 0   0.954782854 1.020035013 0.924372369 1.457090688 0.782161235 1.955403087 0.000000000 0.232456140
  # 1   1.006063929 1.031895194 0.985088516 0.985903312 0.926151596 0.555690958 0.000000000 0.327192982
  # 2   0.935162095 1.034149485 1.084710744 0.786290323 1.136363636 0.681818182 2.500000000 0.266666667
  # 3   1.132715087 0.849307345 1.030475207 1.005544355 0.539772727 1.619318182 2.968750000 0.112280702
  # 4   1.137157107 0.881443299 0.942148760 0.000000000 3.454545455 0.000000000 0.000000000 0.035087719
  # 5   1.292223985 0.801312090 1.070623591 0.000000000 1.570247934 0.000000000 0.000000000 0.019298246
  # 6   1.421446384 0.979381443 0.000000000 3.064516129 0.000000000 0.000000000 0.000000000 0.005263158
  # 7   0.000000000 2.938144330 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000 0.000877193
  # 8   0.000000000 0.000000000 4.710743802 0.000000000 0.000000000 0.000000000 0.000000000 0.000877193
  # Sum 0.351754386 0.340350877 0.212280702 0.054385965 0.028947368 0.009649123 0.002631579 1.000000000
  ```
8. Convertimos los cocientes a data frame para manipularlos
  ```r
  quotionents.df <- data.frame(quotients)
  
  head(quotionents.df)
  # FTHG FTAG      Freq
  # 1    0    0 0.9547829
  # 2    1    0 1.0060639
  # 3    2    0 0.9351621
  # 4    3    0 1.1327151
  # 5    4    0 1.1371571
  # 6    5    0 1.2922240
  ```
9. Eliminamos los registros de Sum
  ```r
  quotionents.df <- filter(quotionents.df, FTHG != "Sum" & FTAG != "Sum")
  ```
10. Establecemos la muestra de la cual obtendremos las muestras bootstrap que es la tabla de los cocientes
  ```r
  sample <-data[,c("FTHG","FTAG")]
  ```
11. Función para calcular los estadísticos del bootstrapping, que en este caso serán la media y mediana
  ```r
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
  ```
12. Generamos 1000 muestras de bootstrap a partir de la muestra sample
  ```r
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
   ```
13. Valores estadísticos calculados de cada muestra bootstrap. La primera columna corresponde a la mediana y la segunda a la media.
```r
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
  ```
>Nota sobre independencia de las variables:
>
>Cuando los eventos son mutuamente excluyentes (Independientes), la probabilidad conjunta de A y B es igual a la probabilidad marginal de A multiplicada por la de B:
>  P(A y B) = P(A) * P(B).
  
Así, en nuestra tabla de cocientes, tenemos la probabilidad conjunta dividida entre la probabilidad de las probas marginales. Por lo que un cociente de 1 implicaría que estamos dividiendo entre la probabilidad conjunta, es decir que los eventos son mutuamente excluyentes.

14. Graficamos la distribución de las medias de las muestras bootstrap
```r
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
```
![distribucion_medias_bootstrap](https://user-images.githubusercontent.com/60225087/125336231-233cc100-e313-11eb-927f-f77547349c08.png)

Tomando como recordatorio el teorema del límite central, sabemos que dada una muestra de tamaño n > 30, la distribución de las medias muestrales tiende a ser una distribución normal. Así que podemos realizar una prueba de hipótesis para probar la independencia de las variables ya que para que X y Y sean independientes, la media debe de ser igual 1.
  
Podemos darnos una mejor idea de que es posible que vengan de una distribución normal si observamos la gráfica de cuántiles normales de las medias.
```r
  qqnorm(myBootstrap$t[,2])
  qqline(myBootstrap$t[,2])
```
![Normal_q-q_plot](https://user-images.githubusercontent.com/60225087/125336433-5f702180-e313-11eb-9379-7511eb0a1d00.png)

15. De igual manera, podemos observar la gráfica de densidad para observar la curva de campana de nuestros datos.
```r
  ggdensity(myBootstrap$t[,2], 
            main = "Densidad de las medias muestrales Bootstrap",
            xlab = "Medias", ylab="Densidad")
 ```
![densidad_medias_muestrales](https://user-images.githubusercontent.com/60225087/125336451-672fc600-e313-11eb-8b47-54b0c6f41fa9.png)

Llevaremos a cabo una prueba de Shapiro Test para probar lo siguiente:

- H₀ μ=1
- H₁ μ≠1

```r
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
```
Podemos darnos cuenta que la prueba nos arroja un p-value muy pequeño, esto nos da suficiente razón para rechazar la hipótesis nula de que la media es igual a 1 y declarar que las variables X y Y no son independientes.
