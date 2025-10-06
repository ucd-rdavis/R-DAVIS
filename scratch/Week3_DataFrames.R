
# Part 2: Starting with Spreadsheets in R

## Presentation of the Survey Data

### Presentation of the survey data
# 
# We are studying the species repartition and weight of animals caught in plots in our study
# area. The dataset is stored as a comma separated value (CSV) file.
# Each row holds information for a single animal, and the columns represent:
#   
#   | Column           | Description                        |
#   |------------------|------------------------------------|
#   | record\_id       | Unique id for the observation      |
#   | month            | month of observation               |
#   | day              | day of observation                 |
#   | year             | year of observation                |
#   | plot\_id         | ID of a particular plot            |
#   | species\_id      | 2-letter code                      |
#   | sex              | sex of animal ("M", "F")           |
#   | hindfoot\_length | length of the hindfoot in mm       |
#   | weight           | weight of the animal in grams      |
#   | genus            | genus of animal                    |
#   | species          | species of animal                  |
#   | taxon            | e.g. Rodent, Reptile, Bird, Rabbit |
#   | plot\_type       | type of plot                       |
#   
  ## Loading the Data
  
  # Your current R project should already have a `data` folder with the surveys data CSV file in it. We can read it into R and assign it to an object by using the `read.csv()` function. The first argument to `read.csv()` is the path of the file you want to read, in quotes. This path will be relative to your current **working directory**, which in our case is the R Project folder. So from there, we want to access the "data" folder, and then the name of the CSV file. `read.csv()` also works with urls (if you have an internet connection, of course). The url below links to a csv stored on the course github page. You can call `read.csv()` directly on the url: 
  

surveys_url <- 'https://raw.githubusercontent.com/ucd-rdavis/R-DAVIS/refs/heads/main/data/surveys.csv'
surveys <- read.csv(file = surveys_url)

# or you can download the file and then load from your local computer. Note that the `destfile` is a relative location, it assumes there is a subdirectry called `data` in your working directory, and then saves a file called `portal_data_joined.csv` in that subdirectory.

download.file(url = surveys_url,destfile = 'data/portal_data_joined.csv')
surveys <- read.csv('data/portal_data_joined.csv')

surveys
class(surveys)


#Wow, printing a data frame gives us quite a bit of output. This is a lot more data than the small vectors we worked with last lesson, but the basic principles remain the same.

#Data frames are really just a collection of vectors: every column is a vector with a single data type, and every column is the exact same length. You can make a data frame "by hand", but they're usually created when you import some sort of tabular data into R using a function like `read.csv()`.



## Inspecting `data.frame` Objects

#When working with a large data frame, it's usually impractical to try to look at it all at once, so we'll need to arm ourselves with a series of tools for inspecting them. Here is a non-exhaustive list of some common functions to do this:
# 
# * Size:
#     * `nrow(surveys)` - returns the number of rows
#     * `ncol(surveys)` - returns the number of columns

length(surveys)
nrow(surveys)
ncol(surveys)

# 
# * Content:
#     * `head(surveys)` - shows the first 6 rows
head(surveys,n = 2)
#     * `tail(surveys)` - shows the last 6 rows
tail(surveys,n = 2)
#     * `View(surveys)` - opens a new tab in RStudio that shows the entire data frame. Useful at times, but you shouldn't become overly reliant on checking data frames by eye, it's easy to make mistakes
View(surveys)
# * Names:
#     * `colnames(surveys)` - returns the column names
colnames(surveys)
#     * `rownames(surveys)` - returns the row names
rownames(surveys)
# 
# * Summary:
#     * `str(surveys)` - structure of the object and information about the class, length and
str(surveys)
# 	   content of  each column
#     * `summary(surveys)` - summary statistics for each column

summary(surveys)

## Indexing and subsetting data frames


#When we wanted to extract particular values from a vector, we used square brackets and put index values in them. Since data frames are made out of vectors, we can use the square brackets again, but with one change. Data frames are 2-dimensional, so we need to specify **row** and **column** indices. Row numbers come first, then a comma, then column numbers. Leaving the row number blank will return **all** rows, and the same thing applies to column numbers.

#One thing to note is that the different ways you write out these indices can give you back either a data frame or a vector.


# first element in the first column of the data frame (as a vector)
surveys[1, 1]   
head(surveys,n = 1)

# first element in the 6th column (as a vector)
surveys[1, 6]  

# first column of the data frame (as a vector)
surveys[, 1]   
surveys[,1]
surveys[1,]

# first column of the data frame (as a data.frame)
surveys[c(1,2)]      

# first three elements in the 7th column (as a vector)
surveys[1:3, 7] 
1:3

# the 3rd row of the data frame (as a data.frame)
surveys[3, ]    
# equivalent to head_surveys <- head(surveys)
head_surveys <- surveys[1:6, ] 

surveys[1:6,]

#You can also exclude certain indices of a data frame using the "`-`" sign:

surveys[, -1] 
surveys[,-c(1:2)]

-c(1:2)

# The whole data frame, except the first column
surveys[-c(7:34786), ] # Equivalent to head(surveys)
-c(7:34786)

head(-c(7:34786))

#Data frames can be subset by calling indices (as shown previously), but also by calling their column names directly:

surveys["species_id"]    # Result is a data.frame
class(surveys[, "species_id"])    # Result is a vector
surveys[["species_id"]]     # Result is a vector
surveys$species_id          # Result is a vector
surveys$hindfoot_length

#In general, when you're working with data frames, you should make sure you know whether your code returns a data frame or a vector, as we see that different methods yield different results. Sometimes you get a data frame with one column, sometimes you get one vector.

#You will probably end up using the `$` subsetting quite a bit. What's nice about it is that it supports tab-completion! Type out your data frame name, then a dollar sign, then hit tab to get a list of the column names that you can scroll through.


  
  ## Base R vs. `tidyverse`
  
#Almost every time you work in R, you will be using different "packages" to work with data. A package is a collection of functions used for some common purpose; there are packages for manipulating data, plotting, interfacing with other programs, and much much more.

#All of the stuff we've covered so far has been using R's "base" functionality, the built in functions and techniques that come with R by default. There is a new-ish set of packages called the `tidyverse` which does a lot of the same stuff as base R, plus much much more. The `tidyverse` is what we will focus on primarily from here on out, as it is a very powerful set of tools with a philosophy that focuses on being readable and intuitive when working with data. There are a few reasons we've taught you a bunch of base R stuff so far:

#For example, using `[]` to subset data and using `read.csv()` are base R ways of doing things, but we'll show you `tidyverse` ways of doing them as well.

#In R, there are almost always several ways of accomplishing the same task. Showing you every single way of getting a job done seems like a waste of time, but we also don't want you to feel lost when you come across some base R code, so that's why there might be a bit of redundancy.

## Loading Packages

#Almost every time you work in R, you will be using different "packages" to work with data. A package is a collection of functions used for some common purpose; there are packages for manipulating data, plotting, interfacing with other programs, and much much more.

#For much of this course, we'll be working with a series of packages collectively referred to as the `tidyverse`. They are packages designed to help you work with data, from cleaning and manipulation to plotting. They are all designed to work together nicely, and share a lot of similar principles. They are increasingly popular, have large user bases, and are generally very well-documented. You can install the core set of `tidyverse` packages with the `install.packages()` function:


install.packages("tidyverse")

dplyr::filter()
stats::filter()

#It is usually recommended that you do **NOT** write this code into a script, or the package will be reinstalled every time you run the script. Instead, just run it once in your console, and it will be permanently installed so you can use it any time.

#Once a package has been installed on your computer, you can load it in order to use it:

library(tidyverse)


#Loading the `tidyverse` package actually loads a whole bunch of commonly used tidyverse packages at once, which is pretty convenient.

#A common feature of `tidyverse` functions is that they use underscores in the name. For example, the `tidyverse` function for reading a CSV file is `read_csv()` instead of `read.csv()`. Let's try it:
  

t_surveys <- read_csv("data/portal_data_joined.csv")


#Now let's take a look at how  prints and check the class:

t_surveys
class(t_surveys)

#Ooh, doesn't that print out nicely? It only prints 10 rows by default, NAs are now colored red, and under the name of each column is the type of data! One important thing to notice is that the column types are only `double` and `character`, no factors here. By default, `read_csv()` keeps character data as `character` columns, which would be like setting `stringsAsFactors=FALSE` in `read.csv()`.

#Also, `class()` returned multiple things! You'll notice one of them is `data.frame`, but there are things like `tbl_df` as well. The `tidyverse` has a special type of `data.frame` called a "tibble". Tibbles are the same as data frames, but they print nicely as we just saw, and they usually return a tibble when you're using bracket subsetting. As always, just be sure to check whether you're getting a tibble or a vector back.


surveys[,1] # gives a vector back
t_surveys[,1] # gives a tibble back


#This lesson is adapted from the Data Carpentry: R for Data Analysis and Visualization of Ecological Data 
#[Starting With Data materials](https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html).