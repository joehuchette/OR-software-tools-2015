##################################################################
# Exercise 4 -- Bond percolation
##################################################################
# Perform uniform random bond percolation, randomly retaining proportion
# phi of edges (hint: ?subgraph.edges). As before, test a range of phi
# values and compute the normalized size of the largest component.
random.bond.percolation <- function(g, phi, reps) {
	mean(replicate(reps, max(c(0, clusters(subgraph.edges(g, eids=sample(ecount(g), phi*ecount(g))))$csize)))) / vcount(g)
}
rb.perc <- data.frame(phi=phis, perc=sapply(phis, random.bond.percolation, g=g, reps=100))
plot(rb.perc)

# Perform targeted bond percolation, comparing the following strategies:
# 1) Remove edges with largest minimum degree of endpoints (hint: ?pmin)
# 2) Remove edges with largest edge betweenness
targeted.bond.percolation1 <- function(g, phi) {
	ordering <- order(pmin(degree(g)[get.edges(g, E(g))[,1]], degree(g)[get.edges(g, E(g))[,2]]))
	max(c(0, clusters(subgraph.edges(g, head(ordering, phi*ecount(g))))$csize)) / vcount(g)
}
tb.perc1 <- data.frame(phi=phis, perc=sapply(phis, targeted.bond.percolation1, g=g))
plot(tb.perc1)

targeted.bond.percolation2 <- function(g, phi) {
	ordering <- order(edge.betweenness(g))
	max(c(0, clusters(subgraph.edges(g, head(ordering, phi*ecount(g))))$csize)) / vcount(g)
}
tb.perc2 <- data.frame(phi=phis, perc=sapply(phis, targeted.bond.percolation2, g=g))
plot(tb.perc2)

# Compare targeted site percolation of the Delta (DL) and Southwest (WN)
# networks.
ts.delta <- data.frame(phi=phis, carrier="Delta", perc=sapply(phis, targeted.site.percolation, g=carrier.graphs$DL))
ts.sw <- data.frame(phi=phis, carrier="Southwest", perc=sapply(phis, targeted.site.percolation, g=carrier.graphs$WN))
ggplot(rbind(ts.delta, ts.sw), aes(x=phi, y=perc, group=carrier, color=carrier)) + geom_line()
