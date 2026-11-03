library(tidyverse)

list.files('data/')

eis_raw <- read_csv('data/eis_clean.csv')
eis <- eis_raw %>%
  filter(filed_year <= 2025)
eis <- eis %>%
  mutate(stage = case_when(
    str_detect(document_type, "Draft") ~ "Draft",
    str_detect(document_type, "Final") ~ "Final",
    TRUE ~ "Other"
  ))
top_agencies <- eis %>%
  count(lead_agency, sort = TRUE) %>%
  slice_head(n = 6) %>%
  pull(lead_agency)


eis <- eis %>%
  mutate(agency = if_else(lead_agency %in% top_agencies, lead_agency, "Other agencies"))

eis <- eis %>%
  mutate(epa_impact = factor(epa_impact, levels = c("Lack of Objections",
                                                    "Environmental Concerns",
                                                    "Environmental Objections",
                                                    "Environmentally Unsatisfactory")))

eis <- eis %>%
  mutate(comment_days = as.numeric(comment_due_date - federal_register_date),
         epa_lag = as.numeric(comment_letter_date - filed_date))
eis <- eis %>%
  mutate(comment_days = ifelse(comment_days >= 0 & comment_days <= 365, comment_days, NA),
         epa_lag = ifelse(epa_lag >= 0 & epa_lag <= 365, epa_lag, NA))

state_regions <- tibble(state = state.abb, region = as.character(state.region))

eis <- eis %>%
  left_join(state_regions, by = "state")

table(eis$region, useNA = "ifany")
summary(eis$comment_days)

base_histo <- ggplot(data = eis, mapping = aes(x = comment_days)) +
  geom_histogram(binwidth = 1) 

base_histo +
scale_x_continuous(limits = c(0,120),breaks = seq(0,120,20),
                     name = 'Comment period length (days)') +
  theme_bw()
table(eis$stage)
ggplot(data = eis, 
       mapping = aes(y = agency,fill = stage)) +
  geom_bar(position = "dodge")


drafts_rated <- eis %>%
  filter(stage == "Draft", !is.na(epa_impact), !is.na(epa_lag))

table(eis$epa_impact)
gbox <- ggplot(data = drafts_rated,
               mapping = aes(x = epa_impact, y = epa_lag)) +
  geom_boxplot()
gbox + geom_jitter(alpha = 0.1,color = 'tomato')

ggplot(data = drafts_rated,
               mapping = aes(x = epa_impact, y = epa_lag)) +
geom_jitter(alpha = 0.1,color = 'tomato') + 
  geom_boxplot(alpha = 0.0)


yearly_counts <- eis %>%
  count(filed_year, agency) %>%
  arrange(filed_year,n)

yearly_counts 

ggplot(data = yearly_counts,
       mapping = aes(x = filed_year,y = n,group = agency)) +
  geom_line()

ggplot(data = yearly_counts,
       mapping = aes(x = filed_year,y = n,color = agency)) +
  geom_line() +
  scale_color_brewer(type = 'qual')
