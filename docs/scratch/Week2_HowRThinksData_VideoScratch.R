

#- [How R thinks about data (vectors)]()
#- [How R thinks about data (subsetting)]()
#- [How R thinks about data (vector math)]()
#- [How R thinks about data (missing values)]()
#- [How R thinks about data (not-vectors)]()
  
  # How R Thinks About Data
  
## Why Learn This Stuff?
  

## Vectors and data types

###### VIDEO 1 VECTORS ######

### Vectors and data types

#Vectors are the most basic way that R deals with data. A vector is made up of a series of values, which could be numbers or characters. Remember when we learned how to assign values to objects, like `x <- 5`? Once we do that, x is a vector with a length of 1. Basically everything in R will be a vector or a bunch of vectors bound together in some way, so knowing how vectors work is crucial to working with more complex data structures.

#We can bind together a series of values into a vector using
#the `c()` function. For example we can create a vector of animal weights and assign
#it to a new object `weight_g`:
  
?c
c()
weight_g <- c(50, 60, 65, 82)
weight_g
c(50,60,65,82)

#A vector can also contain characters:
  
"mouse"
animals <- c("mouse", "rat", "dog")
animals

c("mouse","rat","dog")
#The quotes around "mouse", "rat", etc. are essential here. Without the quotes R
#will assume there are objects called `mouse`, `rat` and `dog`. As these objects
#don't exist in R's memory, there will be an error message. You can use either single `'` or double `"` quotes for characters.

#There are many functions that allow you to inspect the content of a
#vector. `length()` tells you how many elements are in a particular vector:

length(weight_g)
length(weight_g)
length(animals)

#An important feature of a vector is that all of the elements are the same type of data.
#The function `class()` indicates the class (the type of element) of an object:
  
class(weight_g)
class(animals)
c(50,65,'moose','whale')

#The function `str()` provides an overview of the structure of an object and its
#elements. It is a useful function when working with large and complex
#objects.
?str
str(weight_g)
str(animals)

#A vector can be modified, adding values to the start or end of it. You can use the `c()` function to add other elements to your vector:
### NOTE -- MODIFICATION DOES NOT HAPPEN IN PLACE
c(weight_g, 90) 
weight_g
weight_g <- c(weight_g, 90) 
weight_g
# add to the end of the vector
weight_g <- c(30, weight_g) # add to the beginning of the vector
weight_g

#In the first line, we take the original vector `weight_g`,
#add the value `90` to the end of it, and save the result back into
#`weight_g`. Then we add the value `30` to the beginning, again saving the result
#back into `weight_g`.

#An **atomic vector** is the simplest R **data structure** and is a linear vector of a single type. Above, we saw 
#2 of the main **atomic vector** types  that R
#uses: `"character"` and `"numeric"` (or `"double"`), which are numbers that can include decimals. 
#These are the basic building blocks that all R objects are built from. 
#There are 2 other **atomic vector** types that you'll often encounter:
TRUE
FALSE
#* `"logical"` for `TRUE` and `FALSE` (the boolean data type)
#* `"integer"` for integer numbers (e.g., `2L`, the `L` indicates to R that it's an integer)
2L
10L - 2L
10-2
#There are some other types, like `complex` and `raw` but you'll rarely, if ever, encounter them, so we won't go into them further.

#You can check the type of your vector using the `typeof()` function and inputting your vector as the argument. `typeof()` is similar to `class()`, but it digs even deeper down to the bare bones of how R thinks about data. The difference is less important now, but we'll come back around to it.

###### VIDEO 2 SUBSETTING ######
## Subsetting vectors
  
#If we want to extract one or several values from a vector, we must provide one
#or several indices in square brackets.

animals <- c("mouse", "rat", "dog", "cat")

animals[2]
animals[4]
animals[2] # could be read as "return the second value in animals"
animals[c(3, 2)] # could be read as "return the third and second values in animals"


#We can also repeat the indices to create an object with more elements than the
#original one:
  
animals[c(1, 2, 3, 2, 1, 4)]
animals[c(1,1,1,1,1,1,1)]

animals[-5]

#R indices start at 1. Programming languages like Fortran, MATLAB, Julia, and R start
#counting at 1, because that's what human beings typically do. Languages in the C
#family (including C++, Java, Perl, and Python) count from 0 because that's
#simpler for computers to do.

# CONDITIONAL SUBSETTING

#Another common way of subsetting is by using a logical vector. `TRUE` will
#select the element with the same index, while `FALSE` will not:

weight_g <- c(21, 34, 39, 54, 55)
weight_g[c(TRUE, FALSE, TRUE, TRUE, FALSE)] # could be read as "give me the first value, not the second value, etc."


#Typically, these logical vectors are not typed by hand, but are the output of
#other functions or logical tests. For instance, if you wanted to select only the
#values above 50:
  weight_g
weight_g > 50    # will return logicals with TRUE for the indices that meet the condition
## so we can use this to select only the values above 50
weight_g[weight_g > 50]


#You can combine multiple tests using `&` (both conditions are true, AND) or `|`
#(at least one of the conditions is true, OR):
weight_g
weight_g < 30 | weight_g > 50
weight_g[weight_g < 30 | weight_g > 50]
weight_g[weight_g >= 30 & weight_g == 21]
weight_g >= 30 & weight_g == 21

#Here, `<` stands for "less than", `>` for "greater than", `>=` for "greater than
#or equal to", and `==` for "equal to". The double equal sign `==` is a test for
#numerical equality between the left and right hand sides, and should not be
#confused with the single `=` sign, which performs variable assignment (similar to `<-`).

#A common task is to search for certain strings in a vector.  One could use the
#"or" operator `|` to test for equality to multiple values, but this can quickly
#become tedious. The function `%in%` allows you to test if any of the elements of
#a search vector are found:
  
animals <- c("mouse", "rat", "dog", "cat")
animals[animals == "cat" | animals == "rat"] # returns both rat and cat

animals %in% c("rat", "cat", "dog", "duck", "goat")
animals[animals %in% c("rat", "cat", "dog", "duck", "goat")]


###### VIDEO 3 VECTOR MATH ######
  ### Vector Math and Recycling
  
#You can do basic mathematical operations with vectors in R. 
#We won't get into this too deeply, but you should be aware of how R approaches these operations.

#You can add a number to a vector of numbers like this:

x <- 1:10
x
x + 3

#Or multiply all the values in a vector by a number:
x * 10
x / 10

#By default, R will do value-by-value math. 
#So if you add together two vectors of equal length, 
#R will return a vector of the 1st value of each added together, 
#then the 2nd value of each added together, etc. Let's take a look here:
  
y <- 100:109
length(x)
x
length(y)
y
x + y


#As you can see, the first entry we get back is 1 + 100, 
#the second is 2 + 101, and so on. 
#What happens if we try to add two vectors that aren't the same length?

z <- 1:2

x + z

x + c(rep(z,5))

1 + 1
2 + 2
3 + 1
4 + 2
5 + 1
6 + 2
7 + 1
8 + 2
9 + 1
10 + 2

#Whoa... what happened here? R does something called **recycling**. 
#It adds together the first values of each vector, then the second values, 
#but then it runs out of values in vector z. It then **recycles** the values of z, so it will add the 3rd value of x to the 1st value of z, then the 4th value of x to the 2nd value of z, and so on. Essentially, it recycles z from `1,2` into `1,2,1,2,1,2,1,2,1,2`, then does the addition.

#We actually already saw this behavior: when we added 3 to x, 
#3 gets recycled into a vector of 3s that is the same length as x.

#Since the length of x is 10, it is a multiple of the length of z, 
#which is 2. What happens if the longer vector isn't a multiple of the shorter one?

z <- 1:3
z
x + z

1 + 1
2 + 2
3 + 3
4 + 1
5 + 2
6 + 3
7 + 1
8 + 2
9 + 3
10 + 1

a <- x + z


#R warns us about this! However, if you try to assign this result to an object, we get the warning, 
#but the assignment works. z will get recycled until it reaches the length of x. 
#So z gets recycled from being `1,2,3` to being `1,2,3,1,2,3,1,2,3,1`, 
#then gets added to x. This can give you unexpected results if you're 
#doing math with vectors and you're not paying attention to what's going on.

#Recycling also happens with logical vectors:

c(TRUE, FALSE)

x[c(TRUE, FALSE)]

x[c(TRUE, FALSE, FALSE)]


#As mentioned earlier, logical vectors are often generated as intermediate steps when we're subsetting. If you're not careful about the lengths of these intermediate logical vectors, you can get some funky results without even noticing how they happened.

###### VIDEO 4 MISSING DATA######
## Missing data

#As R was designed to analyze datasets, it includes the concept of missing data
#(which is uncommon in other programming languages). Missing data are represented
#in vectors as `NA`.

# When doing operations on numbers, most functions will return `NA` if the data
# you are working with include missing values. This feature
# makes it harder to overlook the cases where you are dealing with missing data.
# You can add the argument `na.rm=TRUE` to calculate the result while ignoring
# the missing values.

NA
heights <- c(2, 4, 4, NA, 6)
heights - 2
?mean
mean(heights)
max(heights)
mean(heights, na.rm = T)
max(heights, na.rm = F)

c(F,T,F,T) + 0

TRUE - 1
TRUE == 1
TRUE - FALSE
1 - 0

# If your data include missing values, you may want to become familiar with the
# functions `is.na()`, `na.omit()`, and `complete.cases()`. See below for
# examples.

heights[!is.na(heights)]

na.omit(heights)

## Extract those elements which are not missing values.

is.na(heights) # this returns a logical vector with TRUE where there is an NA
!is.na(heights) # the ! means "is not", so now we get a logical vector with FALSE for NAs
heights[!is.na(heights)] # now we put that logical vector in, and it will NOT return the entries with NA

## Extract those elements which are complete cases. The returned object is an atomic vector of type `"numeric"` (or `"double"`).
heights[complete.cases(heights)]

complete.cases(heights)
# Recall that you can use the `typeof()` function to find the type of your atomic vector.


###### VIDEO 5 OTHER DATA STRUCTURES ######
## Other Data Structures

# Vectors are one of the many **data structures** that R uses. Other important
# ones are lists (`list`), data frames (`data.frame`), matrices (`matrix`), arrays (`array`), and 
# factors (`factor`). These are all built from combinations of vectors, so much of what you learned about vectors will be important when working with these data structures.

### Lists
# 
# Lists are the most fundamental way that R works with multiple vectors. A list is simply a bunch of vectors put together. The vectors can be different data types, so a list could hold a character vector with the names of your sampling sites as well as a numeric vector with their percent tree cover.
# 
# Lists are extremely flexible, and you'll come across them a lot in various shapes and sizes. We'll talk about them a bit more in later lessons.

my_list <- list(1, c('mouse','cat','rat'),c(TRUE,FALSE))
my_list[2]

### Data Frames
# 
# Data frames are the most common way we work with tabular data in R. Data frames at their core are just picky lists. A data frame is a list where every vector has to be the same length, which is akin to every column having the same number of rows. This means a data frame is rectangular, which is why it matches up with tabular data we're used to working with. A list could have one vector that has 5 values and one vector that has a thousand.
# 
# ### Matrices and Arrays
# 
# Matrices (2D) and Arrays (3D or more) are similar to dataframes and lists, but they are a little more barebones. Matrices and arrays must be made of a single type of data, no mixing types across different columns like in a dataframe. We won't work with these much, but you might encounter them if you do something like population modeling in R. If you remember your basics of vectors, you should be pretty well equipped to tackle matrices and arrays.

vector[x]
matrix[x,y]
array[x,y,z]

### Factors
# 
# Factors are a bit funky, and they can be equally useful and frustrating. Factors look a lot like 1-dimensional character vectors, but they behave a bit differently.
# 
# Factors are used to represent categorical data. Let's make one to play around with:
#   

sex <- factor(c("male", "female", "female", "male"))
class(sex)


# If we ask for the class of sex, we see that it's a factor. Let's try using `typeof()`, which goes a little deeper:
  
typeof(sex)
as.numeric(sex)
# 
# An integer???
#   
#   Factors are really just integer vectors with character labels attached to them. 
# 
# Once created, factors can only contain a pre-defined set of values, known as *levels*. By default, R always sorts levels in alphabetical order. For instance, in our `sex` factor, R will assign the integer `1` to the level `"female"` and `2` to the level `"male"` (because`f` comes before `m`, even though the first value in `sex` is `"male"`). You can see this by using the function `levels()` and you can find thenumber of levels using `nlevels()`:
#   

levels(sex)
nlevels(sex)

# 
# Sometimes, the order of the factors does not matter, other times you might want
# to specify the order because it is meaningful (e.g., "low", "medium", "high"),
# it improves your visualization, or it is required by a particular type of
# analysis. Here, one way to reorder our levels in the `sex` vector would be:
#   

sex # current order
sex <- factor(sex, levels = c("male", "female"))
sex # after re-ordering
# 
# 
# In R's memory, these factors are represented by integers (1, 2, 3), but are more
# informative than integers because factors are self describing: `"female"`,
# `"male"` is more descriptive than `1`, `2`. Which one is "male"?  You wouldn't
# be able to tell just from the integer data. Factors, on the other hand, have
# this information built in. It is particularly helpful when there are many levels
# (like the species names in our example dataset).

#### Converting factors
# 
# If you need to convert a factor to a character vector, you use
# `as.character(x)`.

as.character(sex)

# 
# Converting factors where the levels appear as numbers (such as concentration
#                                                        levels, or years) to a numeric vector is a little trickier. The `as.numeric()` 
# function returns the index values of the factor, not its levels, so it will 
# result in an entirely new (and unwanted in this case) set of numbers. 
# One method to avoid this is to convert factors to characters, and then to numbers.  


year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct)               # Wrong! And there is no warning...
as.numeric(as.character(year_fct)) # This does the trick


#### Renaming factors

# You can rename the levels using the `levels()` function


levels(sex)
levels(sex)[1]
levels(sex)[1] <- "MALE"
sex
levels(sex) <- c("MALE", "FEMALE")
sex


  #### Why Factors?
#   
#   Factors can be convenient at times, and they will pop up pretty frequently, 
#but in most circumstances, character strings will give you fewer hassles. 
# It's usually best to start with character vectors, and convert them explicitly to 
# factors if you need to.
# 
# Some functions in R will automatically convert character strings to factors. For instance, `read.csv()` run in older versions R will turn any character data into factors, while in newer versions this has been changed to keep them as characters. If you aren't sure, you can use the argument `stringsAsFactors=FALSE` in `read.csv()` to make sure your character strings as character strings.
