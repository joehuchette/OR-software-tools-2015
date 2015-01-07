## Intermediate R Pre-Assignment

Download http://www.transtats.bts.gov/Download/On_Time_On_Time_Performance_2013_12.zip 

Extract the CSV file to your Intermediate R directory.

Fire up R, change your working directory to the Intermediate R directory, and run the following (could take a few minutes):

--------------------------


flights.raw = read.csv("On_Time_On_Time_Performance_2013_12.csv")

keep = c("DayofMonth","DayOfWeek","FlightDate","Carrier","TailNum","FlightNum","Origin","OriginCityName","OriginStateFips","OriginStateName","Dest","DestCityName","DestStateFips","DestStateName","CRSDepTime","DepTime","DepDelay","DepDelayMinutes","DepDel15","DepartureDelayGroups","DepTimeBlk","TaxiOut","WheelsOff","WheelsOn","TaxiIn","CRSArrTime","ArrTime","ArrDelay","ArrDelayMinutes","ArrDel15","ArrivalDelayGroups","ArrTimeBlk", "Cancelled","CancellationCode","CRSElapsedTime","ActualElapsedTime","AirTime","Flights","Distance","DistanceGroup","CarrierDelay","WeatherDelay","NASDelay","SecurityDelay","LateAircraftDelay")

flights = flights.raw[,keep]

write.csv(flights,"flights.csv")

install.packages("sqldf")

library(sqldf)

flights.bos = sqldf("select * from 'flights' where Origin='BOS'")

--------------------------

Question 1: what is the most common day of the week for departures in the full data set?

Question 2: what is the least common day of the week for departures from Boston?

Hint: use the table() function

When you're done, you can delete the file On_Time_On_Time_Performance_2013_12.csv. Keep the csv file written during the homework.

## Questions?

Please email efields@mit.edu
