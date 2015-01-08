Intermediate R: Data Wrangling

##################################
# Section 1: Load data frame

# First, load datasets. It's often more convenient to just keep strings as
# strings, so we pass stringsAsFactors=FALSE.
flights = read.csv("flights.csv", stringsAsFactors=FALSE)

# Let's familiarize ourselves a bit with the data
str(flights)

###################################
# Section 2: tapply/table with built-in commands

# We're going to be doing a lot of tapply, so let's make sure we remember how
# to use it.
# [[Pretty picture of how tapply() works, in slides]]

# Let's look at the ArrDelayMinutes column
summary(flights$ArrDelayMinutes)

# Why the NAs?
table(flights$Cancelled,is.na(flights$ArrDelayMinutes))

# To ask questions about delays, we need to exclude the NAs
flightsFlown = subset(flights, !is.na(flights$ArrDelayMinutes))

# There are some huge outliers
hist(flightsFlown$ArrDelayMinutes)
flightsFlown = subset(flightsFlown, flights$ArrDelayMinutes < 1000)

# What is the average arrival delay by day of month?
tapply(flightsFlown$ArrDelayMinutes, flightsFlown$DayofMonth, mean)

# What is the average arrival delay by airline?
# What about standard deviation of arrival delay by airline?
tapply(flightsFlown$ArrDelayMinutes, flightsFlown$Carrier, mean)
tapply(flightsFlown$ArrDelayMinutes, flightsFlown$Carrier, sd)

####################################
# Assignment 1 (Section 2): tapply/table with built-in commands

# What is the average departure delay by weekday (not counting early
# departures)?
tapply(flightsFlown$DepDelayMinutes, flightsFlown$DayOfWeek, mean)

# What is the maximum taxi-in time by airport (using 'Dest' column)?
# Hint: R has a 'max' function.
tapply(flightsFlown$TaxiIn, flightsFlown$Dest, max)

# Extra question: What is the proportion of cancelled flights by airline?
# Hint: The average of TRUE/FALSE values is the proportion that are TRUE.
# Which airlines have the highest and lowest proportions of cancelled flights? 
sort(tapply(flights$Cancelled, flights$Carrier, mean))

#########################################
# Section 3: tapply with user-defined functions

# Often we need to write our own functions to answer specific questions we have 
# about the data. We will write a function that finds the most common origin  
# airport over a data set of flights.

# Let's look at how frequently each origin appears in the data set
tab = sort(table(flights$Origin))

# Reminder: names function
names(tab)

# Writing a function that returns the most common origin given a data set
most.common = function(x) {
	tab = sort(table(x), decreasing = TRUE)
	common.origin = names(tab)[1]
	return(common.origin)
}

# Apply most.common to each carrier using tapply
tapply(flights$Origin,flights$Carrier,most.common)

# #########################
# Assignment 2 (Section 3)

# One simple way to measure the “skew level” of a distribution is 
# to subtract the median from the mean Write a function that calculates 
# this measure of skew for arrival delays (ArrDelayMinutes) and use
# tapply to calculate it for each carrier.
# Hint: use the 'median' function.

shift = function(x) {
	mean(x) - median(x)
}

tapply(flightsFlown$ArrDelayMinutes, flightsFlown$Carrier, shift)

# Extra: What is the most common Origin-Destination pair for
# each carrier? (Hint: use the paste() function. What would you
give as the first argument for tapply?)

tapply(paste(flights$Origin,flights$Dest), flights$Carrier, most.common)

##########################
# Section 4: Split-apply-combine

# We want to create a new data frame with delay information about each origin 
# airport. Some of the data (about 150,000 entries) has information about 
# causes of the delays. We'll take one more subset of the data to exclude 
# all entries without delay type information.

# Which entries to delete?
summary(flights$WeatherDelay)
summary(flights$CarrierDelay)
flightsDelayInfo = subset(flights, !is.na(flights$WeatherDelay))

# Is the total of the delay columns equal to departure or arrival delay?
summary(flightsDelayInfo$LateAircraftDelay + flightsDelayInfo$NASDelay +
flightsDelayInfo$CarrierDelay + flightsDelayInfo$WeatherDelay + 
flightsDelayInfo$SecurityDelay == flightsDelayInfo$ArrDelayMinutes)

# [[Picture of split-apply-combine; split breaks large df into smaller ones,
#    lapply converts small data frames into 1-row data frames; do.call(rbind)
#    combines them into a single data frame.]]

# Let's first split by origin.
spl = split(flightsDelayInfo, flightsDelayInfo$Origin)
str(spl[[1]])
str(spl[[2]])
# spl is a list of data frames

# Re-writing the delay proportion function and expanding to include more delay categories:
delay.prop.df = function(x) {
	prop.carrier = sum(x$CarrierDelay)/sum(x$ArrDelayMinutes)
	prop.weather = sum(x$WeatherDelay)/sum(x$ArrDelayMinutes)
	prop.nas = sum(x$NASDelay)/sum(x$ArrDelayMinutes)
	prop.security = sum(x$SecurityDelay)/sum(x$ArrDelayMinutes)
	prop.late = sum(x$LateAircraftDelay)/sum(x$ArrDelayMinutes)
	return(data.frame(Origin = x$Origin[1], prop.carrier = prop.carrier, prop.weather = prop.weather, prop.nas = prop.nas, prop.security = prop.security, prop.late = prop.late))
} 

#Testing on a few split up data frames
delay.prop.df(spl[[1]])
c(sum(spl[[1]]$CarrierDelay)/sum(spl[[1]]$ArrDelayMinutes),sum(spl[[1]]$WeatherDelay)/sum(spl[[1]]$ArrDelayMinutes),sum(spl[[1]]$NASDelay)/sum(spl[[1]]$ArrDelayMinutes),sum(spl[[1]]$SecurityDelay)/sum(spl[[1]]$ArrDelayMinutes),sum(spl[[1]]$LateAircraftDelay)/sum(spl[[1]]$ArrDelayMinutes))

# Use lapply (apply a function to a list) to convert elements of spl to 1-row summary 
# data frames.
spl2 = lapply(spl, delay.prop.df)
spl2[[1]]
spl2[[2]]

# Last step is to combine everything together. We could manually combine with
# rbind:
rbind(spl2[[1]], spl2[[2]], spl2[[3]])

# do.call is a nifty function that passes all of the elements of its second
# argument to its first argument, which is a function
flights.delay.info = do.call(rbind, spl2)
head(flights.delay.info)

# What are the airports with the highest proportion of weather delays?
flights.delay.info[order(flights.delay.info$prop.weather),]

# How about carrier delays?
flights.delay.info[order(flights.delay.info$prop.carrier),]

##########################
# Assignment 3 (Section 4): Split-apply-combine

# From the flightsFlown data frame, create a data frame called carrier.info, where each row corresponds
# to one carrier (airline). Include the following variables in your new data frame:
#   - carrier: The carrier code
#   - mean.arr.delay: Average arrival delay time (using ArrDelayMinutes)
#   - longest.delay: Longest flight delay for the month 
#   - most.common.origin: most common origin for the carrier

spl = split(flightsFlown, flightsFlown$Carrier)

process.carrier = function(x) {
	carrier = x$Carrier[1]
	mean.arr.delay = mean(x$ArrDelayMinutes)
	longest.delay = max(x$ArrDelayMinutes)
	most.common.origin = most.common(x$Origin)
	return(data.frame(carrier,mean.arr.delay,longest.delay,most.common.origin))
}

spl2 = lapply(spl, process.carrier)
carrier.info = do.call(rbind, spl2)
