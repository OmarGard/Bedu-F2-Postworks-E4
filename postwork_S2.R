library(dplyr)

getwd()

setwd("/Users/omargard/Documents/Personal/Bedu/Fase2/S2/PostWork/Files")

df.2017 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
df.2018 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
df.2019 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

download.file(url = df.2017, destfile = "df.2017.csv", mode = "wb")
download.file(url = df.2018, destfile = "df.2018.csv", mode = "wb")
download.file(url = df.2019, destfile = "df.2019.csv", mode = "wb")

files <- lapply(dir(),read.csv)
str(files)

files <- lapply(files, select, Date, HomeTeam:FTR)

mydf <- do.call(rbind, files)

head(mydf)

dim(mydf)



