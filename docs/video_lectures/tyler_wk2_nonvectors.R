# list
?list

my_list <- list(1:10,c('a','b','c','d'))

str(my_list)


# data.frame
?data.frame


my_dataframe <- data.frame('letters' = c('a','c','d'),'numbers' = 1:3)
class(my_dataframe$letters)
class(my_dataframe)


# matrices/matrix and arrays
?matrix


# factor
?factor
class(c("male", "female", "female", "male"))
sex <- factor(c("male", "female", "female", "male"))
class(sex)
typeof(sex)

levels(sex)

sex <- factor(sex, levels = c("male", "female"))
sex # after re-ordering

as.character(sex)

year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
year_fct
as.numeric(as.character(year_fct))       
