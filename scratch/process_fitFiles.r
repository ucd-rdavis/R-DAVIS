if(!requireNamespace("remotes")) {
  install.packages("remotes")
}
remotes::install_github("grimbough/FITfileR")
library(FITfileR)

acts <- list.files('~/Downloads/export_55674554/activities/',pattern = 'fit$',full.names = T)
library(pbapply)
getwd()
# Initialize empty file
fwrite(data.table(), "finals_data_2.csv")

pblapply(acts, function(x) {
  result <- laps(readFitFile(x))
  fwrite(result, "output.csv", append = TRUE)
  invisible(NULL)  # Don't accumulate in memory
})

# Read back when done
dt <- fread("output.csv")


dt <- data.table()

lemp <- pblapply(acts,function(x) laps(readFitFile(x)),cl = 8)
lp <- rbindlist(lemp,fill = T,use.names = T)

dim(lp)
dt1 <- fread('~/Downloads/finals_data.csv')

lp$year <- year(ymd_hms(lp$timestamp))
lp$month <- month(ymd_hms(lp$timestamp))
lp$day <- day(ymd_hms(lp$timestamp))
lp$total_distance_m <- lp$total_distance

lp$total_elapsed_time_s <- lp$total_elapsed_time
lp$avg_heart_rate_bpm <- lp$avg_heart_rate


lp$steps_per_minute <- (lp$avg_fractional_cadence + lp$avg_cadence) * 2
lp$total_ascent_m <- lp$total_ascent
lp$total_descent_m <- lp$total_descent

lp <- lp[,colnames(lp) %in% colnames(dt1),with = F]

lp <- lp[,colnames(dt1),with = F][order(timestamp),]
lp <- lp[!{steps_per_minute < 60 & lp$sport=='running'},]
fwrite(lp,file = '~/Downloads/finals_data.csv')
dim(lp)
head(dt1)
#Pace = 1609.34 / (60 × speed) = 26.8224 / speed

lp$minutes_per_mile <- 26.8224 / lp$enhanced_avg_speed
head(lp[order(-timestamp),],10)
head(lp[order(-timestamp),],10)$avg_cadence

colnames(dt1)[!colnames(dt1) %in% colnames(lp)]


dt1$total_distance_m[dt1$timestamp==dt1$timestamp[1]]
lp$total_distance[lp$timestamp==dt1$timestamp[1]]
names(dt1)


lp$sport
names(dt1)
names(lp)


dt$timestamp
act_laps <- pblapply(acts,function(x) {dt <- rbind(dt,laps(readFitFile(x)),use.names = T,fill = T)})


laps(readFitFile(acts[1]))
?FITfileR::laps

library(data.table)


