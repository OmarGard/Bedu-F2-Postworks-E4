  # ##########################################################################
  #                        Sesion_5 POSTWORK
  # ########################################################################### 
  
  # 1. A partir del conjunto de datos de soccer de la liga española de las temporadas 2017/2018,
  # 2018/2019 y 2019/2020, crea el data frame SmallData, que contenga las columnas 
  # date, home.team, home.score, away.team y away.score; 
  # Luego establece un directorio de trabajo y con ayuda de la función write.csv guarda el data frame como un archivo csv con nombre soccer.csv.
  # Puedes colocar como argumento row.names = FALSE en write.csv.
  
  # 2. Con la función create.fbRanks.dataframes del paquete fbRanks importe el archivo soccer.csv a R y 
  # al mismo tiempo asignelo a una variable llamada listasoccer. 
  # Se creará una lista con los elementos scores y teams que son data frames listos para la función rank.teams.
  # Asigna estos data frames a variables llamadas anotaciones y equipos.
  
  # 3. Con ayuda de la función unique crea un vector de fechas (fecha) que no se repitan 
  # y que correspondan a las fechas en las que se jugaron partidos.
  # Crea una variable llamada n que contenga el número de fechas diferentes.
  # Posteriormente, con la función rank.teams y usando como argumentos los data frames anotaciones y equipos, 
  # crea un ranking de equipos usando únicamente datos desde la fecha inicial 
  # y hasta la penúltima fecha en la que se jugaron partidos, 
  # estas fechas las deberá especificar en max.date y min.date. 
  # Guarda los resultados con el nombre ranking.
  
  # 4. Finalmente estima las probabilidades de los eventos, el equipo de casa gana, 
  # el equipo visitante gana o el resultado es un empate para los partidos que se jugaron en la última fecha del vector de fechas fecha. 
  # Esto lo puedes hacer con ayuda de la función predict y usando como argumentos ranking y fecha[n] 
  # que deberá especificar en date.


  library(dplyr)
  library(ggplot2)
  # Cargamos los datos
  df <- read.csv("https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/data/postwork_2/D1_17_18_19.csv")
  head(df)
  
  # Seleccionamos variables de interes
  SmallData <- df %>%
    select(Date, HomeTeam, AwayTeam, FTHG, FTAG)
  
  head(SmallData)
  
  # Renombramos variables para el uso posterior de "fbRanks"
  SmallData <- SmallData %>%
    rename(
      date = Date,
      home.team = HomeTeam,
      home.score = FTHG,
      away.team = AwayTeam,
      away.score = FTAG
    )
  
  head(SmallData)
  getwd()
  setwd("/Users/omargard/Documents/Personal/Bedu/Fase2/S5/Postwork/Data")
  
  # Guardamos los datos
  write.csv(SmallData, file = "soccer.csv", row.names = FALSE)
  
  # 2. Leemos los datos con ayuda de fbRanks
  library(fbRanks)
  listasoccer<- create.fbRanks.dataframes(scores.file = "soccer.csv", date.format = "%Y-%m-%d")
  
  anotaciones <- listasoccer$scores
  equipos <- listasoccer$teams 
  
  # 3. Creamos vector de fechas
  fecha <- unique(listasoccer$scores$date)
  n <- length(fecha)
  
  ranking <- rank.teams(scores = anotaciones, 
                        teams = equipos,
                        min.date = fecha[1], 
                        max.date = fecha[n-1])
  
  # 4. Estimacion de probabilidades
  predict(ranking, date = fecha[n])
  
  # Poisson

home.df <- as.data.frame(prop.table(table(SmallData[,"home.score"])))
away.df <- as.data.frame(prop.table(table(SmallData[,"away.score"])))

poisson_pred.home <- dpois(c(0:8),mean(home))
poisson_pred.away <- dpois(c(0:6),mean(away))

home.df <- home.df %>%
  mutate(
    poisson_pred = poisson_pred.home,
    x_ = as.numeric(as.character(home)) + 0.25
  )
home.df
away.df <- away.df %>%
  mutate(
    poisson_pred = poisson_pred.away,
    x_ = as.numeric(as.character(away)) - 0.25
    )

home.df <- home.df %>%
  mutate(clase = "Home")
home.df <- home.df %>%
  rename(
    goals = home
  )
home.df
away.df <- away.df %>%
  mutate(clase = "Away")
away.df <- away.df %>%
  rename(
    goals = away
  )
away.df

home_away.df <- rbind(home.df,away.df)

home_away.df <- home_away.df %>%
  transform(goals = as.numeric(as.character(goals)))
  
home_away.df %>%
    ggplot() +
    geom_col(aes(x = goals, y = Freq, fill = clase),position = "dodge") +
    guides(fill=guide_legend(title="Valores Verdaderos")) +
    geom_point(aes(x=x_,y=poisson_pred, colour=clase)) +
    geom_line(aes(x=x_,y=poisson_pred, group=clase, colour=clase))+
    scale_color_manual(values = c(Away= '#CE5754',
                               Home = '#048386')) +
    labs(x = "Goles Anotados",y = "Proporción de partidos", color = "Predicción Poisson") +
    scale_x_discrete(limits = c(0:8)) +
    ggtitle("Proporción de goles de anotados por partido como local y visitante")
    


