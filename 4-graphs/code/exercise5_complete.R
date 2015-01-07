##################################################################
# Exercise 5 -- Adding communities to prediction models 
##################################################################

# Add the departure and arrival community to the regression for edge
# outcomes from Section 3. Compute communities for the whole graph (not
# just the continental U.S.) and model as two factor variables (hint:
# ?as.factor). Remember you can start with code from
# code/exercise3_complete.R.

emetrics <- data.frame(LateDep=E(g)$LateDep,
DepCommunity=as.factor(comm$membership[get.edges(g, E(g))[,1]]),
ArrCommunity=as.factor(comm$membership[get.edges(g, E(g))[,2]]),
LateArr=E(g)$LateArr,
NumFlights=E(g)$NumFlights,
EdgeBetweenness=edge.betweenness(g),
DepDegree=degree(g)[get.edges(g, E(g))[,1]],
ArrDegree=degree(g)[get.edges(g, E(g))[,2]],
DepPageRank=page.rank(g)$vector[get.edges(g, E(g))[,1]],
ArrPageRank=page.rank(g)$vector[get.edges(g, E(g))[,2]])
summary(lm(LateDep~DepCommunity+ArrCommunity+NumFlights+EdgeBetweenness+DepDegree+ArrDegree+DepPageRank+ArrPageRank, data=emetrics))
summary(lm(LateArr~DepCommunity+ArrCommunity+NumFlights+EdgeBetweenness+DepDegree+ArrDegree+DepPageRank+ArrPageRank, data=emetrics))

# Bonus: perform targeted bond percolation using communities. Compute an
# indicator for whether each edge bridges communities and order the
# removal priority first by this indicator, then by edge betweenness.
# Compare to the two targeted strategies from Exercise 4, Bonus 1.

comm1 <- comm$membership[get.edges(g, E(g))[,1]]
comm2 <- comm$membership[get.edges(g, E(g))[,2]]
ordering <- order(edge.betweenness(g) + 10000 * (comm1 != comm2))
targeted.bond.percolation3 <- function(g, phi) {
	max(c(0, clusters(subgraph.edges(g, ordering[1:(phi*ecount(g))]))$csize)) / vcount(g)
}
tb.perc3 <- data.frame(phi=phis, perc=sapply(phis, targeted.bond.percolation3, g=g))
tb.perc2$type <- "2"
tb.perc3$type <- "3"
tb.perc.compare <- rbind(tb.perc2, tb.perc3)
ggplot(tb.perc.compare, aes(x=phi, y=perc, group=type, color=type)) + geom_line()