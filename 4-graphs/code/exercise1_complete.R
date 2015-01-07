##################################################################
# Exercise 1 -- Carrier-Specific Flight Networks
##################################################################
# 
# We have computed the network for all airlines combined, but we might
# be interested in the network for each separate carrier. Create a list
# of graphs for each carrier, which can be constructed by limiting the
# set of all flights to just those from that carrier and then
# constructing the graph in the same way that we constructed the full
# graph. The carrier can be found in the Carrier variable.

spl <- split(dat, dat$Carrier)
carrier.graphs <- lapply(spl, function(dat) {
	e.spl <- split(dat, paste(dat$Origin, dat$Dest))
	e.spl2 <- lapply(e.spl, function(x) {
  data.frame(Origin = x$Origin[1],
             Dest = x$Dest[1],
             NumFlights = nrow(x),
             LateDep = mean(x$DepDel15, na.rm=T),
             LateArr = mean(x$ArrDel15, na.rm=T),
             TaxiOut = mean(x$TaxiOut, na.rm=T),
             TaxiIn = mean(x$TaxiIn, na.rm=T))
    })
	edges <- do.call(rbind, e.spl2)
vertices <- do.call(rbind, lapply(split(dat, dat$Origin), function(x) {
  data.frame(Origin = x$Origin[1],
             NumFlights = nrow(x),
             LateDep = mean(x$DepDel15, na.rm=T),
             LateArr = mean(x$ArrDel15, na.rm=T),
             TaxiOut = mean(x$TaxiOut, na.rm=T),
             TaxiIn = mean(x$TaxiIn, na.rm=T))
}))
	g <- graph.data.frame(edges, TRUE, vertices)
	return(g)
})

# Now we can look at qualitative differences between the carriers
carriers <- do.call(rbind, lapply(carrier.graphs, function(g) {
	data.frame(airports=vcount(g), density=graph.density(g))
}))
carriers$name <- names(carrier.graphs)
carriers

# We can plot to get a better sense of this data
library(ggplot2)
ggplot(carriers, aes(x=airports, y=density, label=name)) + geom_text()
