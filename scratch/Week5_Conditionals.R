library(tidyverse)
surveys <- read_csv("https://ucd-rdavis.github.io/R-DAVIS/data/portal_data_joined.csv")

dim(surveys)
summary(surveys$hindfoot_length)

ifelse()

if (condition is met)
{do this thing}
else{do this other thing}

ifelse(test condition, if true do x, if false do y)

surveys$hindfoot_cat <- ifelse(test = surveys$hindfoot_length < 29.29,yes = "small",no = "big")

table(is.na(surveys$hindfoot_length),is.na(surveys$hindfoot_cat))
table(surveys$hindfoot_length < 29.29, surveys$hindfoot_cat)


surveys$hindfoot_length < 29.29
surveys$hindfoot_cat <- ifelse(surveys$hindfoot_length < 29.29, "small", "big")
head(surveys$hindfoot_cat)


ifelse(test1, 'a',ifelse(test2,'b',ifelse(test3,'c','d')))

surveys %>% 
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 29.29 ~ "big",
    TRUE ~ "small"
  )) %>% 
  select(hindfoot_length, hindfoot_cat) %>% 
  filter(is.na(hindfoot_length))
  
  
  head()

surveys %>% 
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 29.29 ~ "big",
    is.na(hindfoot_length) ~ NA_character_,
    TRUE ~ "small"
  )) %>% 
  select(hindfoot_length, hindfoot_cat) %>% 
  filter(is.na(hindfoot_length))
  head()


#Using the iris data frame (this is built in to R), create a new variable that categorizes petal length into three groups:
data(iris)
iris
  
summary(iris$Petal.Length)
petal_quants <- quantile(iris$Petal.Length,c(.25,.75))
#small (less than or equal to the 1st quartile)
#medium (between the 1st and 3rd quartiles)
#large (greater than or equal to the 3rd quartile)
iris |> 
  mutate(petal_category = case_when(
    Petal.Length < petal_quants[1] ~ 'small',
    Petal.Length > petal_quants[2] ~ 'big',
    TRUE ~ 'medium'
  )) |>
  group_by(petal_category) |>
  summarize(mean(Petal.Length))



#Hint: Explore the iris data using summary(iris$Petal.Length), to see the petal length distribution. Then use your function of choice: ifelse() or case_when() to make a new variable named petal.length.cat based on the conditions listed above. Note that in the iris data frame there are no NAs, so we don’t have to deal with them here.