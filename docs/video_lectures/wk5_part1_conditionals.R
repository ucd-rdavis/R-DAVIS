library(tidyverse)

agreements <- read_csv("data/iea_agreements.csv")
str(agreements)
summary(agreements$n_members)

## ifelse()
agreements$n_members>mean(agreements$n_members,na.rm = T)
agreements$n_members>20.33
agreements$size_cat <- ifelse(test = agreements$n_members < mean(agreements$n_members,na.rm = T),yes = 'small',no = 'big')
agreements %>% group_by(size_cat) %>% filter(!is.na(n_members)) %>%
  summarize(min(n_members,na.rm = T),max(n_members,na.rm = T),mean(n_members,na.rm = T))

fake_firstQ <- 3
thirdQ <- quantile(agreements$n_members,0.75,na.rm = T)
agreements$three_cat <- ifelse(test = agreements$n_members < fake_firstQ,yes = 'small',ifelse(agreements$n_members>=fake_firstQ&agreements$n_members<=thirdQ,'medium','big'))
table(agreements$three_cat)
agreements %>% group_by(three_cat) %>% filter(!is.na(n_members)) %>%
  summarize(min(n_members,na.rm = T),max(n_members,na.rm = T),n())


agreements %>%
  mutate(size_cat = case_when(
    is.na(n_members) ~ NA_character_,
    n_members > thirdQ ~ "big",
    n_members < fake_firstQ ~ "small",
    TRUE ~ "medium"
  )) %>%
  group_by(size_cat) %>%
  summarize(n())
            
            
  summarize()
  head()



