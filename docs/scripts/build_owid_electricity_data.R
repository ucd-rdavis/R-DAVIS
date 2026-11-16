# Build the electricity teaching snapshot used in week 9 (Functions).
#
# Source: Our World in Data energy dataset (legacy release), https://github.com/owid/energy-data
# Electricity columns come from Ember's Yearly Electricity Data (2026) and the
# Energy Institute's Statistical Review of World Energy (2025), compiled by OWID.
# License: CC BY 4.0. Cite OWID and the underlying sources (see data/owid_electricity_codebook.md).
#
# The output is a simplified subset for teaching, not the OWID dataset itself.
# Re-running this script pulls whatever file OWID currently serves and may change
# numbers quoted in the lesson -- only re-run deliberately, then re-check them.
#
# Writes data/owid_electricity.csv: one row per country x year, 2000-2024.

library(tidyverse)

owid_url <- "https://raw.githubusercontent.com/owid/energy-data/master/owid-energy-data.csv"
raw <- read_csv(owid_url, show_col_types = FALSE)

elec <- raw %>%
  # countries only: drop regions and income groups (no ISO code) and OWID aggregates
  filter(!is.na(iso_code), !str_starts(iso_code, "OWID"),
         year >= 2000, year <= 2024) %>%
  select(country, iso_code, year, population,
         electricity_generation,
         coal_electricity, gas_electricity, oil_electricity,
         nuclear_electricity, hydro_electricity, wind_electricity,
         solar_electricity, biofuel_electricity,
         # OWID's other_renewable_electricity includes bioenergy; this one does not,
         # so the nine sources add up to electricity_generation
         other_renewable_electricity = other_renewable_exc_biofuel_electricity,
         carbon_intensity_elec) %>%
  arrange(country, year)

write_csv(elec, "data/owid_electricity.csv")
