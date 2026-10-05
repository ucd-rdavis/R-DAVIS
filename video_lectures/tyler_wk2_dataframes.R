surveys_url <- 'https://ucd-rdavis.github.io/R-DAVIS/data/portal_data_joined.csv'
surveys_url
surveys <- read.csv(file = surveys_url)

head(surveys)
getwd()
download.file(url = surveys_url, destfile = 'data/portal_data_joined.csv')

surveys <- read.csv(file = 'data/portal_data_joined.csv')
head(surveys)
?read.csv

surveys


class(surveys)

nrow(surveys)
ncol(surveys)
str(surveys)
tail(surveys)
tail(x = surveys,n = 10)
head(surveys)
str(surveys)

colnames(surveys)
names(surveys)
rownames(surveys)
summary(surveys)


surveys[7:nrow(surveys),]
head(surveys)


surveys["species_id"]       # Result is a data.frame
surveys[, "species_id"]     # Result is a vector
surveys[["species_id"]]     # Result is a vector
surveys$species_id          # Result is a vector

surveys$year
surveys$genus




install.packages('tidyverse')

library(tidyverse)

?filter()

dplyr::filter()
stats::filter()

t_surveys <- read_csv("data/portal_data_joined.csv")
t_surveys
class(t_surveys)

t_surveys[,1]
surveys <- read.csv('data/portal_data_joined.csv')
surveys[,1]


t_surveys[,1]


