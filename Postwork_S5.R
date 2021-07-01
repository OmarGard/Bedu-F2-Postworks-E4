library(dplyr)
df <- read.csv("https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/data/postwork_2/D1_17_18_19.csv")
head(df)
SmallData <- df %>%
  select(Date, HomeTeam,AwayTeam,FTHG,FTAG)
head(SmallData)
SmallData <- SmallData %>%
  rename(
    date=Date,
    home.team=HomeTeam,
    home.score=FTHG,
    away.team=AwayTeam,
    away.score=FTAG
  )
head(SmallData)
getwd()
setwd("/Users/omargard/Documents/Personal/Bedu/Fase2/S5/Postwork/Data")
write.csv(SmallData, file="soccer.csv",row.names = FALSE)

library(fbRanks)
listasoccer<- create.fbRanks.dataframes(scores.file = "soccer.csv", date.format = "%Y-%m-%d")
anotaciones <- listasoccer$scores
equipos <- listasoccer$teams 

fecha <- unique(listasoccer$scores$date)
n <- length(fecha)

ranking <- rank.teams(scores=listasoccer$scores, 
                      teams=listasoccer$teams,
                      min.date = fecha[1], 
                      max.date = fecha[n-1])

predict(ranking,date=fecha[n])
