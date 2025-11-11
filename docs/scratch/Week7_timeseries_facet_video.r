
library(tidyverse)
surveys_complete <- read_csv("https://ucd-rdavis.github.io/R-DAVIS/data/portal_data_joined.csv") %>% 
  filter(complete.cases(.))

  ## Plotting time series data
  
#   Let's calculate number of counts per year for each species. First we need
# to group the data and count records within each group. We can quickly use the dplyr function `count` to do this. `count` is very similar to the function `tally` we have seen before, but it interally calls `group_by` before the function and `ungroup` after. 
# 

yearly_counts <- surveys_complete %>%
                 count(year, species_id) 
head(yearly_counts)
yearly_counts <- surveys_complete %>% group_by(year,species_id) %>% summarize(n = n())
head(yearly_counts)
# Time series data can be visualized as a line plot with years on the x axis and counts
# on the y axis:
head(yearly_counts)

ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
     geom_line()


# Unfortunately, this does not work because we plotted data for all the species
# together. We need to tell ggplot to draw a line for each species by modifying
# the aesthetic function to include `group = species_id`:


ggplot(data = yearly_counts, 
       mapping = aes(x = year, y = n, group = species_id)) +
    geom_line()


#We will be able to distinguish species in the plot if we add colors (using `color` also automatically groups the data):


ggplot(data = yearly_counts, 
       mapping = aes(x = year, y = n, color = species_id)) +
    geom_line()


## Faceting

#**`ggplot2`** has a special technique called *faceting* that allows the user to split one
#plot into multiple plots based on a factor included in the dataset. We will use it to
#make a time series plot for each species:

ggplot(data = yearly_counts, 
       mapping = aes(x = year, y = n)) +
    geom_line() +
    facet_wrap(~species_id,scales = 'free_y')
