# Iteration, Iteration, Iteration, Iter
# 
# Learning objectives:
# * Understand when and why to iterate code
# * Be able to start with a single use and build up to iteration
# * Use for loops and apply functions to iterate
# * Be able to write functions to cleanly iterate code

library(tidyverse)

x <- 1:10
log(x)

# The log() function already knows we want to take the log of each element in x, 
# and it returns a vector that's the same length as x. If a vectorized function 
# already exists to do what you want, use it! It's going to be faster and cleaner 
# than trying to iterate everything yourself.
#
# However, we may want to do more complex iterations, which brings us to our first 
# main iterating concept.

# For Loops
#
# A for loop will repeat some bit of code, each time with a new input value. 
# Here's the basic structure:

for(u in 1:10) {
  print(u)
}

# You'll often see i used in for loops, you can think of it as the iteration value. 
# For each i value in the vector 1:10, we'll print that index value. You can use 
# the i value more than once in a loop:

for (i in 1:10) {
  print(i)
  print(i^2)
  print(i^3)
}

# What's happening is the value of i gets inserted into the code block, the block 
# gets run, the value of i changes, and the process repeats. For loops can be a 
# way to explicitly lay out fairly complicated procedures, since you can see 
# exactly where your i value is going in the code.
#
# You can also use the i value to index a vector or dataframe, which can be very 
# powerful!

letters

for (i in 1:10) {
  print(letters[i])
  print(mtcars$wt[i])
}

# Here we printed out the first 10 letters of the alphabet from the letters vector, 
# as well as the first 10 car weights from the mtcars dataframe.
#
# If you want to store your results somewhere, it is important that you create an 
# empty object to hold them BEFORE you run the loop. If you grow your results 
# vector one value at a time, it will be much slower. Here's how to make that 
# empty vector first. We'll also use the function seq_along to create a sequence 
# that's the proper length, instead of explicitly writing out something like 1:10.

results <- rep(NA, nrow(mtcars))


for (i in seq_along(mtcars$wt)) {
  results[i] <- mtcars$wt[i] * 1000
}
results

# apply Functions
#
# For loops are very handy and important to understand, but they can involve 
# writing a lot of code and can generally look fairly messy. Base R includes a 
# family of functions called the apply functions that provide a more concise way 
# to iterate operations across data structures.
#
# The apply family of functions all do the same basic thing: take a data structure 
# and apply a function to parts of it. The different functions in the family are 
# designed for different data structures and different ways of applying functions.

# apply()
#
# The apply() function is designed for matrices and data frames. It applies a 
# function over the rows or columns of a matrix or data frame. The basic syntax is:
#
# apply(X, MARGIN, FUN, ...)
#
# - X is the data (matrix or data frame)
# - MARGIN tells it whether to apply the function over rows (1) or columns (2) 
# - FUN is the function to apply
# - ... allows you to pass additional arguments to the function
#
# Let's try some examples with the mtcars dataset:

# Apply mean function to each column (MARGIN = 2)
mtcars
apply(X = mtcars, MARGIN = 2, FUN = mean)

# Apply mean function to each row (MARGIN = 1) 
head(apply(mtcars, 1, mean))

# Apply a function with additional arguments
apply(mtcars, 2, FUN = mean, na.rm = T)

# lapply() and sapply()
#
# While apply() works on matrices and data frames, lapply() and sapply() work on 
# lists and vectors. 
#
# - lapply() always returns a list
# - sapply() tries to simplify the result to a vector or matrix when possible

# lapply returns a list
lapply(mtcars, mean)

# sapply simplifies to a named vector
sapply(mtcars, mean,simplify = F)


# Handling Missing Values
#
# You can pass additional arguments to functions using the apply family, just like 
# with for loops:

# Create some missing data
mtcars2 <- mtcars
mtcars2[3, c(1,6,8)] <- NA
head(mtcars2)

# This returns NA for columns with missing values
sapply(mtcars2, mean)

# Use na.rm = TRUE to handle missing values
sapply(mtcars2, mean, na.rm = TRUE)

# mapply()
#
# mapply() is the multivariate version of sapply(). It can apply a function to 
# multiple lists or vectors in parallel:

# Create a sentence using car names and mpg values
car_sentences <- mapply(
  #here are the input names that become index values
  function(name, mpg) 
  #here is what to do with those values
  paste(name, "gets", mpg, "miles per gallon"), 
  #here are the actual values to index/iterate with
  rownames(mtcars), mtcars$mpg)


head(car_sentences)

# Writing Custom Functions Inside Apply
#
# One of the powerful features of the apply functions is that you can write custom 
# functions directly inside the apply call. This is useful when you need to do 
# something specific that doesn't have a pre-existing function.

# Write a custom function inside sapply to calculate coefficient of variation
sapply(mtcars, FUN = function(x) sd(x) / mean(x))

# Write a custom function inside apply to find the range of each column
apply(mtcars, 2,FUN = function(x) max(x) - min(x))

# More complex example: standardize each column (subtract mean, divide by sd)
standardized_data <- apply(mtcars, 2, function(x) (x - mean(x)) / sd(x))
head(standardized_data)

# You can also write more complex custom functions with multiple steps:

# Custom function that returns summary statistics for each column
summary_stats <- sapply(mtcars, function(x) {
  c(mean = mean(x),
    median = median(x),
    sd = sd(x),
    min = min(x),
    max = max(x))
})

# This returns a matrix where each column is a variable and each row is a statistic
summary_stats[, 1:3]  # Show first 3 columns

# When to Use Each Apply Function
#
# - apply(): For matrices/data frames when you want to apply a function to rows or columns
# - lapply(): For lists/vectors when you want the result as a list
# - sapply(): For lists/vectors when you want simplified output (vector/matrix)
# - mapply(): For applying a function to multiple lists/vectors in parallel
#
# The apply functions are generally faster than for loops and often more concise, 
# making them a popular choice for many iteration tasks in R.


# Complete Workflow
#
# Let's try working through a complete example of how you might iterate a more 
# complex operation across a dataset. This will follow 3 basic steps:
#
# 1. Write code that does the thing you want once
# 2. Generalize that code into a function that can take different inputs
# 3. Apply that function across your data

# Starting With a Single Case
#
# The first thing we'll do is figure out if we can do the right thing once! We 
# want to rescale a vector of values to a 0-1 scale. We'll try it out on the 
# weights in mtcars. Our heaviest vehicle will have a scaled weight of 1, and our 
# lightest will have a scaled weight of 0. We'll do this by taking our weight, 
# subtracting the minimum car weight from it, and dividing this by the range of 
# the car weights (max minus min). We'll have to be careful about our order of 
# operations...

(mtcars$wt[1] - min(mtcars$wt, na.rm = T)) /
  (max(mtcars$wt, na.rm = T) - min(mtcars$wt, na.rm = T))

# Great! We got a scaled value out of the deal. Because we're working with base 
# functions like max, min, and /, we can vectorize. This means we can give it the 
# whole weight vector, and we'll get a whole scaled vector back.

mtcars$wt_scaled <- (mtcars$wt - min(mtcars$wt, na.rm = T)) /
  diff(range(mtcars$wt, na.rm = T))

mtcars$wt_scaled

# Generalizing
#
# Now let's replace our reference to a specific vector of data with something 
# generic: x. This code won't run on its own, since x doesn't have a value, but 
# it's just showing how we would refer to some generic value.

# x_scaled <- (x - min(x, na.rm = T)) /
#   diff(range(x, na.rm = T))

# Making it a Function
#
# Now that we've got a generalized bit of code, we can turn it into a function. 
# All we need is a name, function, and a list of arguments. In this case, we've 
# just got one argument: x.

rescale_0_1 <- function(x) {
  (x - min(x, na.rm = T)) /
    diff(range(x, na.rm = T))
}

rescale_0_1(mtcars$mpg) # it works on one of our columns

# Iterating with Apply Functions!
#
# Now that we've got a function that'll rescale a vector of values, we can use 
# one of the apply functions to iterate across all the columns in a dataframe, 
# rescaling each one. We'll use sapply since we want simplified output, and we're 
# working with a dataframe.

# Apply our rescale function to each column
rescaled_data <- sapply(mtcars, rescale_0_1)
head(rescaled_data)

# You can also use lapply if you want the result as a list
rescaled_list <- lapply(mtcars, rescale_0_1)

# There you have it! We went from some code that calculated one value to being 
# able to iterate it across any number of columns in a dataframe using base R's 
# apply functions. It can be tempting to jump straight to your final iteration 
# code, but it's often better to start simple and work your way up, verifying 
# that things work at each step, especially if you're trying to do something even 
# moderately complex.


# Other Iteration Options: purrr from the Tidyverse
#
# While we've focused on base R's apply functions, it's worth mentioning that 
# there are other approaches to iteration available in R. The tidyverse includes 
# a package called purrr that provides the map family of functions. These functions 
# are very similar to the apply functions, but with a more consistent syntax and 
# some additional features.
#
# The purrr functions include map(), map_dbl(), map_chr(), and others that 
# explicitly specify the output type. For example:

# library(purrr)
# mtcars %>% map_dbl(mean)  # Returns a numeric vector

# If you want to learn more about purrr, check out Jenny Bryan's tutorial at:
# https://jennybc.github.io/purrr-tutorial/
# 
# You might come across purrr functions in tidyverse-focused code, but the base R 
# apply functions we've learned will handle most iteration needs effectively.
#
# This lesson was contributed by Michael Culshaw-Maurer, with ideas from Mike 
# Koontz and Brandon Hurr's D-RUG presentation:
# http://d-rug.github.io/blog/2017/Brandon-Hurr-on-using-map-and-walk