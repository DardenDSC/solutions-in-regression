
# This script is available online at: 
#   https://github.com/DardenDSC/solutions-in-regression/blob/master/script.R

# If you want to run the code below, then use the cursor to highlight the lines 
# you would like to run and then press CRTL+ENTER (CMD+ENTER if using a Mac).


# How to install a package (only need to install packages once) -------------

# Run `install.packages("PACKAGE_NAME_HERE")` to install an R package
# You should only run this command the first time you want to install a package.
# A package is a collection of R functions that make it easier to write your own code. 

# For example, the readxl package is a set of functions that make it 
# easier to read and write data stored in Excel files. You could write your own code 
# to do this, but why do that if someone else has already done that!
install.packages('readxl')


# How to load a package (need to load each new R session) -------------------

# Run `library(PACKAGE_NAME)` to load a package. You must load the package every 
# time that you open up R (start a new session) so that the functions become available
# for use to use during the session. 
library(readxl)


# Reading in data -----------------------------------------------------------

# Read the Excel file called "Problems in Regression QA-0416 data.xls" from our project folder
# The file contains multiple sheets (one for each problem), so we should specify which 
# sheet and cells to read into R. 

# The command "read.xlsx()" will read cells A3:B18 on the first worksheet and assign 
# it to an object called "prob1_data".
prob1_data <- read_excel("Problems in Regression QA-0416 data.xls", 
                         sheet = 1, 
                         range = "A3:B18")
# The " <- " operator means take the result from the right-hand side and put it into a 
# variable by the name of what is on the left-hand side of the operator.

# You don't always have to assign data to a variable. If you don't include the 
# assignment operator, the result will just print it in the Console window.
prob1_data


# Figuring out the rows and columns of a dataset ----------------------------

# R is typically used to store data in a "tabular" format. In other words, a format 
# that keeps the data in a rectangle shape of rows and columns. There are functions 
# in R specifically designed to measure the data.
# For example, "nrow(OBJECT_NAME_HERE))" will tell you the number of rows in your data
nrow(prob1_data)
# "ncol(OBJECT_NAME_HERE))" will tell you the number of columns
ncol(prob1_data)
# "dim(OBJECT_NAME_HERE)" will tell you the dimensions (rows and columns!)
dim(prob1_data)

# The "View()" function lets you view your data like you would in a spreadsheet.
View(prob1_data)

 
# Problem 1 -----------------------------------------------------------------

# We believe that there is a relationship between MSF and HOURS. The `lm()` function 
# stands for "linear model". This will create a regression for us based on the data 
# stored in our variable called "prob1_data". 
trenton_regression <- lm(HOURS ~ MSF, data=prob1_data)

# Now that we've created the regression, we can view it using `summary()`. 
summary(trenton_regression)

# The `summary()` function is cool because it allows us to get components of the 
# regression, like the standard error and keep it in a new variable like this: 
regression_standard_error <- summary(trenton_regression)$sigma
regression_standard_error

# If you create a regression, then you can make predictions using it. All you need 
# to do is create a dataset and pass it to the `predict()` function along with your model. 
# Here is an example where we create a dataset with the numbers given in the problem to 
# calculate the predicted number of hours using the regression.
preds <- predict(trenton_regression, newdata = data.frame(MSF=c(157.3, 64.7)))
preds

# Now that we know the predicted time, then we can use a normal probability distribution 
# to figure out the probability of the time being above or below a certain threshold, 
# like 8 hours. The `pnorm()` function calculates that probability for us. It works 
# just like the `NORMDIST()` function in Excel.
pnorm(8, mean=preds, sd=regression_standard_error)


# Getting help -------------------------------------------------------------

# Wait! How did we know that the `pnorm()` function even existed?. You can Google 
# them how to do these things and see examples of other people's code which is a 
# good step, but if you need a quick reminder on the definition of a function and 
# you already know the name, then you can find the documentation for it by typing 
# a question mark before the function name and running that in the console like this: 
?pnorm


# Problem 2 -----------------------------------------------------------------

# Problem 2 wants us to calculate the weight of a pile using its diameters on 
# top and bottom along with the height. You can create a regression just like this: 
prob2_data <- read_excel("Problems in Regression QA-0416 data.xls", 
                         sheet = "Prob 2",
                         range = "A3:D13")
wales_regression1 <- lm(W ~ D + h + d, data=prob2_data)

# You may remember that regressions need to meet some basic assumptions like 
# linearity and constant-variance, normally distributed residuals. You can create 
# basic plot by using the `plot()` function and saying which datapoints should 
# go on the X and Y-axes.
plot(x=fitted(wales_regression1), y=residuals(wales_regression1))

# You'll notice in the plot that the residuals do not really have constant-variance. 
# We can easily put a square term in the regression by using the `poly()` function 
# and specifying it as the 2nd order (square term). 
wales_regression2 <- lm(W ~ poly(D, 2) + h + poly(d, 2), data=prob2_data)

# Now look at the residuals with a horizontal line at zero to help gauge it
plot(x=fitted(wales_regression2), y=residuals(wales_regression2))
abline(h=0, col="red")


# Problem 4 -----------------------------------------------------------------

# Problem 4 wants us create a regression for expenditure based on income and family 
# size. This is easy, just specify the regression like we have been doing and use 
# the `summary()` function to examine the coefficients of the regression.
prob4_data <- read_excel("Problems in Regression QA-0416 data.xls", 
                         sheet = "Prob 4", 
                         range = "A3:C13")
consumer_regression <- lm(C ~ I + F, data=prob4_data)
summary(consumer_regression)


# Problem 5 -----------------------------------------------------------------

# Problem 5 wants us create a regression for participation based on the left and 
# right-hand side of the classroom. The data comes in format that is a little wierd 
# and not conducive to running a regression. We are trying to model participation 
# and regressions need all the participation data in one column and the explanatory 
# variables (which side of the room in this case) to be in another column. Here 
# we will read in the data and then create that dataset. 

prob5_data <- read_excel("Problems in Regression QA-0416 data.xls", 
                         sheet = "Prob 5", 
                         range = "A3:B13")

prob5_data_reformatted <- data.frame(y = c(prob5_data$`Left Side`, 
                                           prob5_data$`Right Side`), 
                                     x = rep(c(0,1), each = nrow(prob5_data)))
View(prob5_data_reformatted)

participation_regression <- lm(y~x, data=prob5_data_reformatted)
summary(participation_regression)


# read R For Data Science ------------------------------------------------------

# The most prolific R programmer, Hadley Wickham, has released a book for free 
# that describes for beginners how to approach data science using R. The book 
# is easy to use and reference. I highly recommend you read it if you intend on 
# learning more on how to code in R. The link is: http://r4ds.had.co.nz
