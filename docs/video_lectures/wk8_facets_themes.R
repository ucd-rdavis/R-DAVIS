library(tidyverse)

eis <- read_csv("https://ucd-rdavis.github.io/R-DAVIS/data/eis_clean.csv") %>%
  filter(filed_year <= 2025)

summary(eis$filed_year)

unique(eis$document_type)
eis <- eis %>% mutate(stage = case_when(
  str_detect(document_type,"Draft") ~ "Draft",
  str_detect(document_type,"Final") ~ "Final",
  T ~ "Other"
))

table(eis$stage)

top_agencies <- eis %>%
  count(lead_agency,sort = T) %>%
  slice_head(n = 6) %>%
  pull(lead_agency)
top_agencies

eis <- eis %>%
  mutate(agency = if_else(lead_agency %in% top_agencies, lead_agency, "Other agencies"))

table(eis$agency)

yearly_counts <- eis %>%
  #group_by(filed_year,agency)%>%
  #summarize(n = n())
  count(filed_year, agency)

ggplot(data = yearly_counts) + 
  geom_line(aes(x = filed_year,y = n,group = agency))

ggplot(data = yearly_counts, aes(x = filed_year, y = n))+
  facet_wrap(~agency,scales = "free_y") +
  geom_line()

yearly_count_by_state <- eis %>%
  #group_by(filed_year,agency)%>%
  #summarize(n = n())
  count(filed_year, agency, state)


ggplot(data = yearly_count_by_state) +
  geom_line(aes(x = filed_year,y = n)) +
  facet_grid(state ~ agency,scales = "free")

colnames(eis)
yearly_counts


ggplot(data = yearly_counts, aes(x = filed_year, y = n))+
  facet_wrap(~agency,scales = "free_y") +
  geom_line() +
  theme_economist()

library(ggthemes)
theme_ 



