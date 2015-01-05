##################################
# Section 1: Load and explore data frame

# First, load datasets. It's often more convenient to just keep strings as
# strings, so we pass stringsAsFactors=FALSE.
setwd("C://Users/Clark/Documents/Software Tools 2015")
flights = read.csv("On_Time_On_Time_Performance_2013_12.csv", stringsAsFactors=FALSE)

# str() and summary() are always a good way to start
str(flights)
summary(flights)

# Explore

###################################
# Section 2: tapply/table with built-in commands

# We're going to be doing a lot of tapply, so let's make sure we remember how to
# use it. [[Pretty picture of how tapply() works, in slides]]

# To ask questions about delays, we need to exclude the cancelled flights
flightsFlown = subset(flights, !is.na(flights$ArrDelayMinutes))

# What is the average arrival delay by day of month?
tapply(flightsFlown$ArrDelayMinutes, flightsFlown$DayofMonth, mean)

# What is the average arrival delay by airline? Standard Deviation of arrival delay by airline?
tapply(flightsFlown$ArrDelayMinutes, flightsFlown$Carrier, mean)
tapply(flightsFlown$ArrDelayMinutes, flightsFlown$Carrier, sd)

#################################### Do this all about cancelled flights - cancellation code
# Assignment 1 (Section 2): tapply/table with built-in commands

# What is the average departure delay by weekday (not counting early departures)?
tapply(flights$DepDelayMinutes, flights$DayOfWeek, mean)

# What is the average taxi-in time by airport (using 'Dest' column)
tapply(flights$TaxiIn, flights$Dest, mean)

# Bonus: What is the proportion of cancelled flights by airline? Which airlines have the highest and lowest proportions of cancelled flights? Hint: The average of TRUE/FALSE values is the proportion that are TRUE.
sort(tapply(flights$Cancelled, trips$start_station, mean))

#########################################
# Section 3: tapply with user-defined functions

#Here we will write a function that calculates the percentage of delays caused by different factors (weather, late plane, etc.)


# #########################
# Assignment 2 (Section 3)


##########################
# Section 4: Split-apply-combine

# We want to create a new data frame with delay information about each origin airport. 

# [[Picture of split-apply-combine; split breaks large df into smaller ones,
#    lapply converts small data frames into 1-row data frames; do.call(rbind)
#    combines them into a single data frame.]]
    
# Let's first split on the origin.
spl = split(flights, flights$Origin)
summary(spl[[1]])
summary(spl[[2]])
#spl is a list of data frames



##########################
# Assignment 3 (Section 4): Split-apply-combine
# This is still from John's last year. Will rewrite soon.
# From trips, create a data frame called bicycle.info, where each row corresponds
# to one bicycle. Include the following variables in your new data frame:
#   - bike.nr: The bicycle number of this bicycle
#   - mean.duration: Average trip duration (seconds)
#   - sd.duration: Standard deviation of trip duration (seconds)
#   - num.trips: Number of trips taken by the bicycle (Hint: ?nrow)

# Remember that you can start by creating just a few of these variables. If you
# edit your function, remember to refresh it in your R console before re-running
# lapply.

spl = split(trips, trips$bike_nr)

process.bike = function(x) {
	bike.nr = x$bike_nr[1]
	mean.duration = mean(x$duration)
	sd.duration = sd(x$duration)
	num.trips = nrow(x)
	return(data.frame(bike_nr, mean.duration, sd.duration, num.trips))
}

spl2 = lapply(spl, process.bike)
bicycle.info = do.call(rbind, spl2)

# Bonus: Add the following additional variables:
#   - multi.day: Number of trips starting and ending on a different day
#   - common.start: Most common start location (hint: length(tab) is the
#                   number of values in a table tab)
#   - common.end: Most common end location

process.bike.bonus = function(x) {
	bike_nr = x$bike_nr[1]
	mean.duration = mean(x$duration)
	sd.duration = sd(x$duration)
	num.trips = nrow(x)
	multi.day = sum(x$start_date$yday != x$end_date$yday | x$start_date$year != x$end_date$year)
	tab = sort(table(x$start_station))
	common.start = as.numeric(names(tab))[length(tab)]
	tab = sort(table(x$end_station))
	common.end = as.numeric(names(tab))[length(tab)]
	return(data.frame(bike_nr, mean.duration, sd.duration, num.trips,
	                  multi.day, common.start, common.end))
}

spl2 = lapply(spl, process.bike.bonus)
bicycle.info.bonus = do.call(rbind, spl2)
