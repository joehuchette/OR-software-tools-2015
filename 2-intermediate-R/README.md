## Intermediate R Pre-Assignment

__Note that ``sqldf`` requires a relatively recent version of R (at least 3.1.0). Make sure your version is up-to-date.__

1. Download <http://www.transtats.bts.gov/Download/On_Time_On_Time_Performance_2013_12.zip>
2. Extract the CSV file to your Intermediate R directory.
3. Fire up R, change your working directory to the Intermediate R directory, and run the following (could take a few minutes):

--------------------------

```R
flights.raw = read.csv("On_Time_On_Time_Performance_2013_12.csv")

keep = c("DayofMonth","DayOfWeek","FlightDate","Carrier","TailNum","FlightNum","Origin","OriginCityName","OriginStateFips","OriginStateName","Dest","DestCityName","DestStateFips","DestStateName","CRSDepTime","DepTime","DepDelay","DepDelayMinutes","DepDel15","DepartureDelayGroups","DepTimeBlk","TaxiOut","WheelsOff","WheelsOn","TaxiIn","CRSArrTime","ArrTime","ArrDelay","ArrDelayMinutes","ArrDel15","ArrivalDelayGroups","ArrTimeBlk", "Cancelled","CancellationCode","CRSElapsedTime","ActualElapsedTime","AirTime","Flights","Distance","DistanceGroup","CarrierDelay","WeatherDelay","NASDelay","SecurityDelay","LateAircraftDelay")

flights = flights.raw[,keep]

write.csv(flights,"flights.csv")

install.packages("sqldf")

library(sqldf)

flights.bos = sqldf("select * from 'flights' where Origin='BOS'")
```
--------------------------

__Question 1:__ what is the most common day of the week for departures in the full data set?

__Question 2:__ what is the least common day of the week for departures from Boston?

Hint: use the table() function

When you're done, you can delete the file On_Time_On_Time_Performance_2013_12.csv. Keep the csv file written during the homework.

## Questions?

Please email efields@mit.edu

The completed flights.csv is too big for the github repo but can be downloaded from https://dl.dropboxusercontent.com/u/1877897/flights.csv
