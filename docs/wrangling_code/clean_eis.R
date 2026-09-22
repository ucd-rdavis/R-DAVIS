# clean_eis.R — build the teaching dataset from the raw EPA EIS API dump
# Reproduces eis_clean.csv from eis_record_api.parquet
library(tidyverse)
library(arrow)     # read_parquet

raw <- read_parquet("eis_record_api.parquet")

impact_lookup <- c(LO = "Lack of Objections",
                   EC = "Environmental Concerns",
                   EO = "Environmental Objections",
                   EU = "Environmentally Unsatisfactory")

eis <- raw |>
  transmute(
    eis_id                = eisId,
    title                 = str_squish(title),
    document_type         = type,
    lead_agency           = leadAgency,
    state                 = primaryState,
    all_states            = states,
    filed_date            = mdy(filedDate),
    filed_year            = year(filed_date),
    federal_register_date = mdy(federalRegisterReportDate),
    comment_letter_date   = mdy(commentLetterDate),
    comment_due_date      = mdy(dueDate),
    # decode EPA rating: two-letter impact code + trailing adequacy digit
    .impact_code = str_extract(str_to_upper(rating), "^(LO|EC|EO|EU)"),
    epa_impact   = unname(impact_lookup[.impact_code]),
    epa_adequacy = as.integer(str_extract(rating, "[1-3]$")),
    attachment_count = attachmentCount
  ) |>
  # 1970-01-01 is an epoch sentinel in the source, not a real date
  mutate(comment_letter_date = na_if(comment_letter_date, ymd("1970-01-01"))) |>
  select(-.impact_code) |>
  arrange(filed_date)

write_csv(eis, "eis_clean.csv")
# saveRDS(eis, "eis_clean.rds")  # preserves Date / integer types
