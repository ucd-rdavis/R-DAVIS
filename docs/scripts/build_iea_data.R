# Build the IEA teaching snapshot used in weeks 4-5 (lessons and labs).
#
# Source: International Environmental Agreements Database Project, hosted by
# Université Laval, https://www.iea.ulaval.ca. Data described in Mitchell et al.
# (2020), Global Environmental Politics 20(1): 103-121,
# https://doi.org/10.1162/glep_a_00544
#
# Use is subject to the IEADB's terms.
# The output is a simplified subset for teaching, not the IEADB itself.
#
# The IEADB regenerates its CSVs weekly, so the course uses a frozen snapshot.
# Re-running this script pulls the *current* release and will change counts
# quoted in lessons and labs -- only re-run deliberately, then re-check them.
#
# Writes three linked tables to data/ (see data/iea_codebook.md):
#   iea_agreements.csv   one row per environmental agreement      (key: iea_id)
#   iea_memberships.csv  one row per country x agreement          (keys: iea_id, country)
#   iea_countries.csv    one row per present-day country          (key: country / iso3)

library(tidyverse)

zip_url <- "https://iea.ulaval.ca/sites/iea.ulaval.ca/files/ieadbDataset/all-csv-files.zip"
raw_dir <- file.path(tempdir(), "ieadb")
zip_path <- file.path(tempdir(), "ieadb.zip")
download.file(zip_url, zip_path, mode = "wb")
unzip(zip_path, exdir = raw_dir)

# Every file has a two-line citation preamble and a blank line before the
# header, and uses ";" as the delimiter.
read_iea <- function(file) {
  read_delim(file.path(raw_dir, file), delim = ";", skip = 3,
             guess_max = 1e5, show_col_types = FALSE)
}

# The IEADB codes unknown dates and years as 1111-11-11 / 1111.
unknown_year <- function(x) na_if(as.integer(x), 1111L)

treaties <- read_iea("db_treaties.csv")
members <- read_iea("db_members.csv") # column 11 throws harmless parse warnings
traits <- read_iea("db_country_traits.csv")
demog <- read_iea("db_demographics.csv")

# Agreements ------------------------------------------------------------------
# Keep environmental agreements only: inclusion codes BEA (bilateral), MEA
# (multilateral), OEA (other). Drops non-environmental and uncertain
# instruments and things the IEADB codes as "not an agreement".
agreements <- treaties %>%
  filter(`Inclusion (type of agreements)` %in% c("BEA", "MEA", "OEA")) %>%
  transmute(
    iea_id = `IEA#`,
    agreement_name = str_squish(`Agreement Name`),
    scope = recode(`Inclusion (type of agreements)`,
                   BEA = "Bilateral", MEA = "Multilateral", OEA = "Other"),
    instrument = case_when(
      `Agreement type level 2` %in% c("Agreement-type protocol", "Protocol") ~ "Protocol",
      `Agreement type level 2` %in% c("Amendment", "Amendment-type protocol") ~ "Amendment",
      `Agreement type level 2` == "Agreement" ~ "Agreement",
      TRUE ~ "Other"
    ),
    subject = `Issue area (subject)`,
    lineage = Lineage,
    year_signed = unknown_year(year(`Date IEA was concluded`)),
    year_in_force = unknown_year(year(`Date IEA entered into force`)),
    # Blank means never terminated; one malformed date (IEA 3112) stays NA.
    terminated = case_when(
      is.na(`Term Date`) | `Term Date` == "1111-11-11" ~ FALSE,
      str_detect(`Term Date`, "^\\d{4}-\\d{2}-\\d{2}$") ~ TRUE
    )
  )

# Memberships -----------------------------------------------------------------
# Collapse each country's action history on an agreement to the first year it
# signed, the first year the agreement entered into force for it (including
# tacit acceptance of amendments), and the first year it withdrew/denounced.
actions <- members %>%
  filter(`Mitch ID` %in% agreements$iea_id) %>%
  transmute(
    iea_id = `Mitch ID`,
    country = `Country (official name)`,
    year = unknown_year(Year),
    action = case_when(
      str_detect(`Action Type`, regex("withdraw|denunc", ignore_case = TRUE)) ~ "left",
      str_detect(`Action Type`, regex("^entry into force", ignore_case = TRUE)) ~ "joined",
      `Action Type` %in% c("Signature", "Definitive signature") ~ "signed",
      TRUE ~ "other"
    )
  )

first_year <- function(year, action, which) {
  y <- year[action == which & !is.na(year)]
  if (length(y) == 0) NA_integer_ else min(y)
}

memberships <- actions %>%
  group_by(iea_id, country) %>%
  summarize(
    year_country_signed = first_year(year, action, "signed"),
    year_joined = first_year(year, action, "joined"),
    year_left = first_year(year, action, "left"),
    .groups = "drop"
  )

# Count members per agreement: countries for which it ever entered into force.
agreements <- agreements %>%
  left_join(memberships %>%
              filter(!is.na(year_joined)) %>%
              count(iea_id, name = "n_members"),
            by = "iea_id") %>%
  arrange(iea_id)

# Countries -------------------------------------------------------------------
# Present-day countries only. Historical states, sub-national units and the
# EU stay in memberships but have no row here -- useful for teaching joins.
# "Czech Republic" and "Macedonia" duplicate "Czechia" and "North Macedonia"
# (renamed 2016 and 2019); memberships use the current names.
# A few rows carry legacy or missing codes; patch them to ISO 3166 so the
# World Bank demographics match.
iso3_fixes <- c(Myanmar = "MMR", Tanzania = "TZA", `Timor-Leste` = "TLS",
                Kosovo = "XKX", `South Sudan` = "SSD", Curacao = "CUW")

countries <- traits %>%
  filter(`Country Type` == "country", !Country %in% c("Czech Republic", "Macedonia")) %>%
  transmute(
    country = Country,
    iso3 = coalesce(iso3_fixes[Country], `Country Code`),
    continent = `Continent UN`,
    subregion = `Continent SUB`,
    oecd_joined = as.integer(OECD),
    eu_joined = as.integer(na_if(EU, 0))
  )

# Demographics are keyed by a "Name (ISO) - year" label; pull 2020 values.
demog_2020 <- demog %>%
  transmute(
    iso3 = str_match(`IEA#`, "\\(([A-Z]{3})\\)")[, 2],
    year = `demographic year`,
    population = population,
    gdp_per_capita = round(`GDP per capita (constant 2015 US$)`),
    democracy_index = `V-Dem Liberal Democracy Index (0-1)`
  ) %>%
  filter(year == 2020, !is.na(iso3)) %>%
  select(-year)

countries <- countries %>%
  left_join(demog_2020, by = "iso3") %>%
  arrange(country)

# Write -----------------------------------------------------------------------
write_csv(agreements, "data/iea_agreements.csv", na = "NA")
write_csv(memberships, "data/iea_memberships.csv", na = "NA")
write_csv(countries, "data/iea_countries.csv", na = "NA")
