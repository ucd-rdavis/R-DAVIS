# Build the wildfire air-quality teaching snapshot used in week 10 (Iteration).
#
# Source: Aguilera, R. & Benmarhnia, T. Daily Total and Wildfire Concentrations of
# PM10 and Ozone for California ZIP Codes (2006-2020). Harvard Dataverse, V3.1.
# https://doi.org/10.7910/DVN/FYW1VU
# License: CC0 1.0. Cite the dataset and Aguilera et al. (2025), GeoHealth
# (see data/ca_wildfire_air_codebook.md).
#
# The output is a simplified subset for teaching, not the published dataset itself.
# The two ZIP-code files are ~380 MB each, so they are downloaded to a temporary
# folder (or set CA_AIR_SRC to a folder that already holds ozone.csv and pm10.csv).
#
# Writes data/ca_wildfire_air.csv: one row per city x day, 2006-2020.

library(tidyverse)

src_dir <- Sys.getenv("CA_AIR_SRC", tempdir())
ozone_file <- file.path(src_dir, "ozone.csv")
pm10_file  <- file.path(src_dir, "pm10.csv")

# Dataverse file IDs for CAzip_wf_ozone_2006to2020_Aug2025.csv and CAzip_wf_pm10_2006to2020_Aug2025.csv
options(timeout = 3600)
if (!file.exists(ozone_file)) download.file("https://dataverse.harvard.edu/api/access/datafile/13192073", ozone_file)
if (!file.exists(pm10_file))  download.file("https://dataverse.harvard.edu/api/access/datafile/13192085", pm10_file)

# One ZIP code per place: a mix of cities and towns hit by big fires
# (Camp Fire 2018 in Paradise, Carr Fire 2018 near Redding, Tubbs Fire 2017 in Santa Rosa)
places <- c("95616" = "Davis",
            "95969" = "Paradise",
            "96001" = "Redding",
            "95404" = "Santa Rosa",
            "93721" = "Fresno",
            "90012" = "Los Angeles")

ozone <- read_csv(ozone_file, show_col_types = FALSE) %>% filter(zip %in% names(places))
pm10  <- read_csv(pm10_file,  show_col_types = FALSE) %>% filter(zip %in% names(places))

air <- inner_join(pm10, ozone, by = c("zip", "date")) %>%
  mutate(city = places[as.character(zip)],
         year = as.integer(format(date, "%Y")),
         pm10 = round(pm10, 1),
         pm10_fire = round(wf_pm10, 1),
         # ozone comes in ppm; ppb gives friendlier numbers
         ozone = round(1000 * max.o3, 1),
         ozone_fire = round(1000 * wf_ozone, 1)) %>%
  select(city, zip, date, year, pm10, pm10_fire, ozone, ozone_fire) %>%
  arrange(city, date)

write_csv(air, "data/ca_wildfire_air.csv")
