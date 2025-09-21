

### <small>Midterm </small>

This is the midterm exam for R-DAVIS Fall 2024. THE MIDTERM IS NOT GRADED. This is strictly meant to be an assessment of your learning thus far. You are welcome to use whatever materials you'd like. The exam is meant to take 1 hour. When you are finished, save a .R script as midterm_[lastname]_[firstname] in your class git repository and push your script to github.

BACKGROUND: The pandemic spurred Tyler to get back into running semi-seriously. That went pretty well until he hurt his Achilles tendon. The sports med doctors at UC Davis filmed and analyzed his running. The doctors said Tyler was getting old... and that he was over-striding and putting too much pressure on his Achilles when landing. So in 2024, Tyler has been practicing running differently. The doctors and trainers are having Tyler increase his cadence (strides per minute) while running, with the idea being that fast, short strides place less stress on the lower body. For this exam, you are going to read in data that Tyler has exported from his Garmin running watch and perform a descriptive analysis to assess how successful this effort has been.

TASK DESCRIPTION: 

1. Read in the file tyler_activity_laps_10-24.csv from the class github page. This file is at url `https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv`, so you can code that url value as a string object in R and call read_csv() on that object. The file is a .csv file where each row is a "lap" from an activity Tyler tracked with his watch. 

2. Filter out any non-running activities. 

3. Next, Tyler often has to take walk breaks between laps right now because trying to change how you've run for 25 years is hard. You can assume that any lap with a pace above 10 minute-per-mile pace is walking, so remove those laps. You should also remove any abnormally fast laps (< 5 minute-per-mile pace) and abnormally short records where the total elapsed time is one minute or less. 

4. Create a new categorical variable, pace, that categorizes laps by pace: "fast" (< 6 minutes-per-mile), "medium" (6:00 to 8:00), and "slow" ( > 8:00). Create a second categorical variable, `form` that distinguishes between laps run in the year 2024 ("new", as Tyler started his rehab in January 2024) and all prior years ("old"). 

5. Identify the average steps per minute for laps by form and pace, and generate a table showing these values with old and new as separate rows and pace categories as columns. Make sure that `slow` speed is the second column, `medium` speed is the third column, and `fast` speed is the fourth column (hint: think about what the `select()` function does). 

6. Finally, Tyler thinks he's been doing better since July after the doctors filmed him running again and provided new advice. Summarize the minimum, mean, median, and maximum steps per minute results for all laps (regardless of pace category) run between January - June 2024 and July - October 2024 for comparison.

<details>
<summary>**DO NOT OPEN** until you are ready to see the answers! </summary>
```{r, eval = T}
library(tidyverse)
url <- 'https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv'
lap_dt <- read_csv(url)

running_laps <- lap_dt %>% 
  filter(sport == 'running') %>%
  filter(total_elapsed_time_s >= 60) %>%
  filter(minutes_per_mile < 10 & minutes_per_mile > 5) %>%
  mutate(pace_cat = case_when(minutes_per_mile < 6 ~ 'fast',
                           minutes_per_mile >=6 & minutes_per_mile < 8 ~ 'medium',
                           T ~ 'slow'),
         form = case_when(year == 2024 ~ 'new form',
                          T ~ 'old form'))

running_laps %>% group_by(form,pace_cat) %>% 
  summarize(avg_spm = mean(steps_per_minute)) %>%
  pivot_wider(id_cols = form,values_from = avg_spm,names_from = pace_cat) %>%
  select(form,slow,medium,fast)

running_laps %>% filter(form == 'new form') %>%
  mutate(months = ifelse(month %in% 1:6,'early 2024','late 2024')) %>%
  group_by(months) %>% 
  summarize(
    min_spm = min(steps_per_minute),
    median_spm = median(steps_per_minute),
    mean_spm = mean(steps_per_minute),
    max_spm = max(steps_per_minute))
```
<details>



### <small>Final </small>

This is the final exam for R-DAVIS Fall 2024. THE FINAL IS NOT GRADED. This is strictly meant to be an assessment of your learning thus far. You are welcome to use whatever materials you'd like. The exam is meant to take 1 hour. When you are finished, save a .R script as final_[lastname]_[firstname] in your class git repository and push your script to github.

BACKGROUND

For the midterm, you compared Tyler's old running data with recent data to analyze to see if there was any difference in strides-per-minute (SPM). On July 1, 2024, Tyler went to a follow-up appointment with the UCD Sports Medicine clinic, and they told him that has cadence was still too low, and that his form was perhaps *more* damaging than it had been. The technician gave Tyler some training cues, as well as the advice that "elite professional runners are at least 180 strides-per-minute, so aim for that". 

Tyler looked into it, and found out that:

* He is not an elite professional runner

* That 180 number was based on strides counted in the 1984 MEN'S OLYMPIC 10K FINAL (seriously, this is true)

Given these two facts, the conclusion (since confirmed with technician) is that what really matters is not just high cadence but a positive relationship between cadence and speed. Perform the tasks below to analyze whether Tyler's SPM appears responsive to changes in pace, and more importantly whether things have improved since the July 1 check-up.

TASK DESCRIPTION 

1. Read in the file tyler_activity_laps_12-6.csv from the class github page. This file is at url `https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/refs/heads/main/data/tyler_activity_laps_12-6.csv`, so you can code that url value as a string object in R and call read_csv() on that object. The file is a .csv file where each row is a "lap" from an activity Tyler tracked with his watch. 

2. Filter out any non-running activities. 

3. We are interested in *normal* running. You can assume that any lap with a pace above 10 `minutes_per_mile` pace is walking, so remove those laps. You should also remove any abnormally fast laps (< 5 `minute_per_mile` pace) and abnormally short records where the total elapsed time is one minute or less. 

4. Group observations into three time periods corresponding to pre-2024 running, Tyler's initial rehab efforts from January to June of this year, and activities from July to the present. 
5. Make a scatter plot that graphs SPM over speed by lap.

6. Make 5 aesthetic changes to the plot to improve the visual. 
7. Add linear (i.e., straight) trendlines to the plot to show the relationship between speed and SPM for each of the three time periods (hint: you might want to check out the options for `geom_smooth()`)

8. Does this relationship maintain or break down as Tyler gets tired? Focus just on post-intervention runs (after July 1, 2024). Make a plot (of your choosing) that shows SPM vs. speed by *lap*. Use the `timestamp` indicator to assign lap numbers, assuming that all laps on a given day correspond to the same run (hint: check out the `rank()` function). Select only laps 1-3 (Tyler never runs more than three miles these days). Make a plot that shows SPM, speed, *and* lap number (pick a visualization that you think best shows these three variables).

<details>
  <summary>We'll post the answer key Thursday afternoon.</summary>
</details>
