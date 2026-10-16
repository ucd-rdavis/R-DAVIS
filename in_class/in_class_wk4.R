library(tidyverse)
agreements <- read_csv("https://ucd-rdavis.github.io/R-DAVIS/data/iea_agreements.csv")

types_to_keep <- c("Bilateral","Multilateral")

dim(filter(.data = agreements,  scope %in% types_to_keep))
dim(filter(.data = agreements, {scope == 'Bilateral' | scope == "Multilateral"}))
dplyr::select()
dplyr::filter()

dim(agreements)
agreements2 <- filter(agreements, n_members > 150)
dim(agreements2)
all(agreements2$n_members > 150)
agreements3 <- select(agreements2, agreement_name, year_signed, n_members)

dim(agreements)
dim(agreements2)
dim(agreements3)

dim(select(.data = filter(.data = agreements,n_members>150),agreement_name, year_signed, n_members))

agreements %>%
  filter(.,n_members > 150) %>%
  select(.,agreement_name, year_signed, n_members) %>%
  dim(.)

filter(agreements,n_members > 150)

agreements <- agreements %>% ungroup()
str(agreements)

agreements %>%
  #group_by(scope,subject) %>%
  summarize(mean_members <- mean(n_members,na.rm = T),median_members <- median(n_members, na.rm = T))



  filter(scope == 'Multilateral')


z <- 2
z = 2 
z == 3  
  


agreements %>%
  #filter(!is.na(n_members)) %>%
  group_by(subject, scope) %>%
  summarize(mean_members = mean(n_members,na.rm = T))

agreements %>%
  filter(!is.na(n_members)) %>%
  group_by(subject, scope) %>%
  summarize(mean_members = mean(n_members))

agreements <- mutate(agreements,years_to_force = year_in_force - year_signed)

agreements$year_in_force

?`|>`
?`%>%`
?`%in%`
  
agreements %>%
  mutate(year_signed = 1990) %>%
  select(year_signed)
  
  mutate(years_to_force = year_in_force - year_signed, decades_to_force = years_to_force / 10) %>%
  select(years_to_force,decades_to_force)

agreements





