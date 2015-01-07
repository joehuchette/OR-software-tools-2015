##################################################################
# Exercise 3 -- Regression models over edges
##################################################################

# Use linear regression to predict the proportion of delayed departures
# and arrivals for each edge. Predict using the number of flights on that
# edge, the edge betweenness, the degree of the departure and arrival
# airports on the edge, and the PageRank of the departure and arrival
# airports on the edge. Check for multicollinearity between the network
# metrics.

g

emetrics <- data.frame(LateDep=E(g)$LateDep,
LateArr=E(g)$LateArr,
NumFlights=E(g)$NumFlights,
EdgeBetweenness=edge.betweenness(g),
DepDegree=degree(g)[get.edges(g, E(g))[,1]],
ArrDegree=degree(g)[get.edges(g, E(g))[,2]],
DepPageRank=page.rank(g)$vector[get.edges(g, E(g))[,1]],
ArrPageRank=page.rank(g)$vector[get.edges(g, E(g))[,2]])

head(emetrics)

summary(lm(LateDep~NumFlights+EdgeBetweenness+DepDegree+ArrDegree+DepPageRank+ArrPageRank, data=emetrics))
summary(lm(LateArr~NumFlights+EdgeBetweenness+DepDegree+ArrDegree+DepPageRank+ArrPageRank, data=emetrics))

cor(emetrics)
# Looks like we have some missing data in LateArr, so let's use na.omit:
cor(na.omit(emetrics))
# Better be careful interpreting coefficients!

# Bonus: one airport has relatively low degree (<= 50) but relatively
# high betweenness centrality (>= 500). Plot these two metrics against
# each other to observe the outlier. What is the airport and why does
# it have this property? Hint: you can access neighbors with ?neighbors.

plot(degree(g), betweenness(g))
which(degree(g) <= 50 & betweenness(g) >= 5000)
airports[airports$IATA == "ANC",]
neighbors(g, "ANC")
V(g)$name[neighbors(g, "ANC")]
degree(g)[neighbors(g, "ANC")]
