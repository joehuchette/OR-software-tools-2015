#make sure your working directory contains flights_condensed.csv
#first we'll read in the flight data
flights = read.csv("flights_condensed.csv")

#for our purposes, we want to limit ourselves to flights between the top 20 airports
#this makes the data set smaller (examples run faster)
top20 = c("ATL","LAX","ORD","DFW","DEN","JFK","SFO","CLT","LAS","PHX","MIA","IAH","EWR","MCO","SEA","MSP","DTW","BOS","PHL","LGA")
flights = subset(flights, Origin %in% top20 & Dest %in% top20) #%in% is like is.element

###
#joins
###

#We're going to join some location data to the flights data so we can try to see the jet stream
#to do this, we need to know the change in longitude of each flight
#first we load up the airport location data
latlong = read.csv("Airport_Codes_mapped_to_Latitude_Longitude_in_the_United_States.csv",header=TRUE)
longitudes = latlong[,c(1,3)] #we only need longitudes

#now we'll do the actual join
#in base R, this is done using the merge() function
flights = merge(flights,longitudes,by.x="Origin",by.y="locationID")
#let's take a look at the data frame now
#see that the column we've just merged in is called "Longitude"
#but since we merged on origin, it's really the origin longitude.
#So we rename it:
names(flights)[match("Longitude",names(flights))]="Origin.Long"
#same for destination longitude
flights = merge(flights,longitudes,by.x="Dest",by.y="locationID")
names(flights)[match("Longitude",names(flights))]="Dest.Long"

#we'll now compute flight speeds and changes in longitude
flights$Speed = flights$Distance / flights$AirTime
summary(flights$Speed) #uhoh
#some flights have no speed (perhaps they never made it off the ground)
flights = subset(flights,AirTime>0)
flights$DiffLong = flights$Dest.Long - flights$Origin.Long

#can we see the jet stream in action?
plot(flights$DiffLong, flights$Speed,pch=".")
js.effect = cor(flights$DiffLong, flights$Speed)

###
#Joins assignment
###

# 1) Join airport latitudes to the flight data. What was the largest change in latitude for any flight?
# 2) (optional) Find a flight (may not be unique) which experienced this largest change in latitude. 
#    Hint: use the order() function to sort a data frame
# 3) (optional) Re-do the jet stream example using latitudes instead of longitudes.
#    Is there a relationship between change in latitude and flight speed?

###
#Joins with split-apply-combine
###

#Here we do a more complicated joins example
#the join is on multiple columns
#and the analysis uses split-apply-combine
#our goal is to find, for each airport, the average weather delay per .1 mm precipitation

#read data to be joined
weather = read.csv("prcp_pretty.csv")

#merge in precipitation data
#rows must match on day of month AND airport
flights = merge(flights,weather,by.x=c("Origin","DayofMonth"),by.y=c("Airport","DayOfMonth"))

#for this analysis, we only want entries with a number for weather delay (no NA)
#we also limit to days with precipitation
flights.rain = subset(flights, !is.na(WeatherDelay) & prcp>0)
flights.rain$DelayRatio = flights.rain$WeatherDelay / flights.rain$prcp

#split apply combine to find average weather delay per inch of precipitation
#first we split
#we must discard unused factors or we will get empty data frames for airports not in the top 20
flights.rain$Origin = factor(flights.rain$Origin)
flights.rain.split = split(flights.rain,flights.rain$Origin)

#define a function
process.airport = function(df){
  airport.name = df$Origin[1]
  avg.ratio = mean(df$DelayRatio)
  return(data.frame(Airport=airport.name, Avg.delay.ratio=avg.ratio))
}

flights.rain.split = lapply(flights.rain.split,process.airport)
airport.info = do.call(rbind,flights.rain.split)

#let's order the resulting data frame
airport.info = airport.info[order(airport.info$Avg.delay.ratio),]


###
#Second joins assignment
###
#Is there a relationship between airport latitude and average delay ratio?




###
#sqldf
###
#side by side examples of:
#subsetting
flights.bos = subset(flights, Dest=="BOS")
flights.bos = sqldf("select * from flights where Dest='BOS'")
#subset and only keep only selected columns
flights.fast = subset(flights, Speed>mean(flights$Speed))[,c("Origin","Dest")]
flights.fast = sqldf("select Origin, Dest from flights where Speed>(select avg(Speed) from flights)")
#inner join - note differences in columns returned
A = airport.info[,1:2] #discard location data
airport.info = sqldf("select * from A inner join latlong where A.Airport = latlong.locationID")
airport.info = merge(A,latlong,by.x="Airport",by.y="locationID")
