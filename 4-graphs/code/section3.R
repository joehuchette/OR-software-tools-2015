##################################################################
# Section 3 -- Network Metrics
##################################################################

# Let's start out by computing some global network metrics.
graph.density(g)
reciprocity(g)
assortativity.degree(g)

# Now let's look at the distribution of some of the vertex and edge
# metrics.
hist(degree(g))
head(sort(degree(g), decreasing=TRUE))
hist(closeness(g))
head(sort(closeness(g), decreasing=TRUE))
hist(betweenness(g))
table(betweenness(g) == 0)
head(sort(betweenness(g), decreasing=TRUE))
page.rank(g)
hist(page.rank(g)$vector)
head(sort(page.rank(g)$vector, decreasing=TRUE))
hist(transitivity(g, "local"))
head(sort(transitivity(g, "local"), decreasing=TRUE))

# transitivity() doesn't return a named vector, so we'll need to do a bit
# more work to figure out the airports with the largest transitivity.
# sort() returns the largest transitivities, but we will instead use
# order(), which returns the indices of the nodes with the largest
# transitivities.
head(order(transitivity(g, "local"), decreasing=TRUE))
transitivity(g, "local")[93]
transitivity(g, "local")[265]

# We can use the indices from order() to look up node names or degrees.
V(g)$name[head(order(transitivity(g, "local"), decreasing=TRUE))]
degree(g)[head(order(transitivity(g, "local"), decreasing=TRUE))]

# Edge betweenness is one of the most important edge metrics
hist(edge.betweenness(g))

# One really common thing to do with vertex or edge metrics is to add
# them to a regression model that predicts some feature of the vertices
# or edges. The igraph network metric functions return vectors containing
# the metric so we can build a data frame with all the metrics we need
# as well as our outcome data that we've stored as vertex and edge
# metadata.

# We'll try to predict two outcomes for vertices -- the prop. of late
# departures and the taxi out time. We'll include two metrics that capture
# the volume of traffic at the airport -- the total number of flights and
# the degree of the airport in the network. We'll also use closeness
# centrality, which is how close this airport is to all others. We might
# hypothesize that airports with high volume or near the center of the
# network are overloaded and have more delays or that they have invested
# in robust systems/procedures and will have fewer delays.

# Let's remind ourselves of our vertex attributes
g

# Now we can build the data frame
metrics <- data.frame(Origin=V(g)$name,
LateDep=V(g)$LateDep,
TaxiOut=V(g)$TaxiOut,
NumFlights=V(g)$NumFlights,
degree=degree(g),
closeness=closeness(g))

head(metrics)

# Now we can build our models; we'll use simple linear regression but
# clearly any regression model you learned in Module 1 could be used.
summary(lm(LateDep~NumFlights+degree+closeness, data=metrics))
summary(lm(TaxiOut~NumFlights+degree+closeness, data=metrics))
