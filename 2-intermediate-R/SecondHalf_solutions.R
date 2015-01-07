###
#Joins assignment - solutions
###

# 1) Join airport latitudes to the flight data. What was the largest change in latitude for any flight?
flights = merge(flights,latlong[,1:2],by.x="Origin",by.y="locationID")
#let's take a look at the data frame now
#see that the column we've just merged in is called "Latitude"
#but since we merged on origin, it's really the origin latitude.
#So we rename it:
names(flights)[match("Latitude",names(flights))]="Origin.Lat"
#same for destination latitude
flights = merge(flights,latlong[,1:2],by.x="Dest",by.y="locationID")
names(flights)[match("Latitude",names(flights))]="Dest.Lat"
flights$DiffLat = flights$Dest.Lat - flights$Origin.Lat
biggest.lat.change = max(abs(flights$DiffLat))
# 2) (optional) Find a flight (may not be unique) which experienced this largest change in latitude. 
#    Hint: use the order() function to sort a data frame
flights = flights[order(abs(flights$DiffLat),decreasing=TRUE),]
flights[1,]
# 3) (optional) Re-do the jet stream example using latitudes instead of longitudes.
#    Is there a relationship between change in latitude and flight speed?
plot(flights$DiffLat, flights$Speed,pch=".")
lat.effect = cor(flights$DiffLat, flights$Speed)


###
#Optional joins assignment
###
#Is there a relationship between airport latitude and average delay ratio?
airport.info = merge(airport.info, latlong[,1:2],by.x="Airport",by.y="locationID")
plot(airport.info$Latitude,airport.info$Avg.delay.ratio)
cor(airport.info$Latitude,airport.info$Avg.delay.ratio)
