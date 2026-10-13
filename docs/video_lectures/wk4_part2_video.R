library("tidyverse")

agreements <- read_csv("https://ucd-rdavis.github.io/R-DAVIS/data/iea_agreements.csv")
str(agreements)
?summarize
summarize(agreements,mean(n_members,na.rm=T))
mean(agreements$n_members,na.rm = T)

table(agreements$scope)
agreements %>%
  group_by(scope)

agreements

agreements_grouped
members_by_scope <- agreements %>%
  group_by(scope) %>%
  summarize(mean_members = mean(n_members, na.rm = TRUE))
members_by_scope$mean_members

agreements %>%
  group_by(scope) %>%
  summarize(min_members = min(n_members, na.rm = TRUE),max_members = max(n_members, na.rm = TRUE))
 
agreements %>%
  mutate(years_to_force = year_in_force - year_signed) %>%
  group_by(scope) %>%
  summarize(mean(years_to_force,na.rm = T))

agreements %>%
  filter(!is.na(year_in_force)) %>%
  group_by(scope) %>%
  summarize(mean(year_in_force))
  
  mutate(year_signed_plus1 = year_signed + 1)

agreements %>%
  mutate(
         years_to_force = year_in_force - year_signed,
         decades_to_force = years_to_force/10,
         ) %>%
  select(years_to_force,decades_to_force)
