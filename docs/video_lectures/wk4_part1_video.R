library("tidyverse")

agreements <- read_csv("https://ucd-rdavis.github.io/R-DAVIS/data/iea_agreements.csv")
str(agreements)
nrow(agreements)
dim(agreements)

## SELECT variables or columns
agreements[,"scope{"}]
dplyr::select(.data = agreements,agreement_name, year_signed, n_members)

## FILTER is for rows

dplyr::filter(.data = agreements,year_signed > 1992 & year_signed < 1995)

### using select and filter at the same time

agreements2 <- filter(agreements, n_members > 150)
agreements3 <- select(agreements2, agreement_name, year_signed, n_members)

### nesting select and filter

agreements_big <- select(filter(agreements, n_members > 150), agreement_name, year_signed, n_members)


### piping

  agreements %>%
  filter( n_members > 150) %>%
  select(agreement_name, year_signed, n_members)




## arrange
  agreements %>%
    filter( n_members > 150) %>%
    select(agreement_name, year_signed, n_members) %>%
    arrange(-n_members)
  
agreements %>%
    filter( n_members > 150) %>%
    select(agreement_name, year_signed, n_members) %>%
    arrange(-n_members)

agreements

agreements_big  
  
  
