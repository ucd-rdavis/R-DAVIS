
# this function calculates a percentage

pct <- function(part, total) {
  100 * part / total
}

pct(part = 1,total = 4)
2+2
library(tidyverse)
owid_flnm <- "data/owid_electricity.csv"
elec <- read_csv(owid_flnm)

head(elec)
head(elec$coal_electricity)
head(elec$electricity_generation)
elec %>%
  mutate(coal_pct  = 100 * coal_electricity/electricity_generation,
         wind_pct = pct(wind_electricity,electricity_generation),
        solar_pct = pct(solar_electricity,electricity_generation)) %>%
  select(coal_pct,wind_pct,solar_pct,country,year)



divide_numbers <- function(a, b) {
  if (b == 0) {
    return(NA) # Stops immediately so it doesn't divide by zero
  }
  a / b        # Implicitly returned if b is not 0
}


pct <- function(part, total, digits = 1) {
  round(100 * part / total, digits)
}

pct(part=1,total=3)
pct(part = 1,total = 3,digits = 2)

pct(1,3,1)
pct(digits = 1,total = 3, part = 1)

elec %>%
  filter(country == "Norway",year == 2024) %>%
  pivot_longer(coal_electricity:other_renewable_electricity,names_to = "type",
               values_to = "twh") %>%
  mutate(type = str_remove(type,"_electricity"),
         share = pct(twh,electricity_generation)) %>%
  select(type,twh,share) %>%
  arrange(desc(share))

elec_mix <- function(data,country_name,yr){
data %>%
  filter(country == country_name,year == yr) %>%
  pivot_longer(coal_electricity:other_renewable_electricity,names_to = "type",
               values_to = "twh") %>%
  mutate(type = str_remove(type,"_electricity"),
         share = pct(twh,electricity_generation)) %>%
  select(type,twh,share) %>%
  arrange(desc(share))
}
elec_mix(data = elec,country_name = 'Norway',yr = 2024)


count_2024 <- function(data) {
  data <- filter(data, year == 2024)
  n_rows <- nrow(data)
  n_rows
}
count_2024(elec)
nrow(elec)
n_rows

source("scripts/functions.R")

pct(0,100)
pct(0,0)

top_countries <- function(data, col, yr, n = 5) {
  data %>%
    filter(year == yr) %>%
    arrange(desc({{ col }})) %>%
    select(country,{{ col }}) %>%
    head(n)
}

top_countries(elec, wind_electricity, 2024)

elec_mix(elec, "Nrway", 2024)


elec_mix <- function(data, country_name, yr) {
  if (!country_name %in% data$country) {
    stop("Can't find '", country_name, "' in the data. Check the spelling.")
  }
  data %>%
    filter(country == country_name, year == yr) %>%
    pivot_longer(coal_electricity:other_renewable_electricity,
                 names_to = "type", values_to = "twh") %>%
    mutate(type = str_remove(type, "_electricity"),
           share = pct(twh, electricity_generation)) %>%
    select(type, twh, share) %>%
    arrange(desc(share))
}

elec_mix(elec, "Nrway", 2024)










