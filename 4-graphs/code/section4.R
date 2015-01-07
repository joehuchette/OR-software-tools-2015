##################################################################
# Section 4 -- Network Resilience 
##################################################################

# Any theories about the behavior of uniform random site percolation and
# targeted site percolation in our network?

# First we'll compute a random sample of a proportion phi of the nodes
phi <- 0.8
vcount(g)
sample(vcount(g), phi*vcount(g))

# We can compute subgraphs of a network in which we only keep the
# indicated nodes and edges connected to them with the induced.subgraph()
# function.
induced.subgraph(g, sample(vcount(g), phi*vcount(g)))

# We want to compute the size of the biggest cluster, so let's first use
# the clusters() function to get all the cluster memberships.
clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))

# We can access the "csize" element of the list and compute its maximum
max(clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))$csize)

# A problem with this is when we delete all the vertices. Then csize will
# be blank, causing a warning with our code.
phi <- 0
max(clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))$csize)

# Let's fix it by adding 0 to csize. This will make max return 0 when
# there are no vertices and return the maximum component size when there
# are vertices.
max(c(0, clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))$csize))
phi <- 0.8
max(c(0, clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))$csize))

# Because this is random we want to replicate the computation and take
# the average across the replications, which we can do with replicate()
# and mean(). You'll see more sophisticated simulation in the simulation
# module.
reps <- 100
replicate(reps, max(c(0, clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))$csize)))
mean(replicate(reps, max(c(0, clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))$csize))))

# Let's normalize by the original size of the graph
mean(replicate(reps, max(c(0, clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))$csize)))) / vcount(g)

# Finally, let's make a function with our code.
random.site.percolation <- function(g, phi, reps) {
	mean(replicate(reps, max(c(0, clusters(induced.subgraph(g, sample(vcount(g), phi*vcount(g))))$csize)))) / vcount(g)
}

# Now we can build a data frame that contains the size of the giant
# component after random site percolation with different phi values.
# We'll sample a grid from 0 to 1 and use sapply to run for each.
phis <- seq(0, 1, .01)
rs.perc <- data.frame(phi=phis, perc=sapply(phis, random.site.percolation, g=g, reps=100))
head(rs.perc)

# Now we can plot our results along with a line indicating the maximum
# possible size of the giant component, which would be achieved if g were
# a complete graph.
plot(rs.perc)
abline(0, 1)

# Now we want to model an adversarial situation in which the nodes with
# the highest degree are removed first. We'll do this by taking the degree
# ordering of the nodes in the original graph g and using it throughout,
# though another approach would be to recompute the degrees each time you
# remove the highest-degree node. The first step is to sort the
# nodes in the network by degree using the order() function. This returns
# indices in the vertex list, sorted by degree.
order(degree(g))

# This will have ordered in increasing order, so we can check that the
# last few indices are airports we recognize:
degree(g)[20]
degree(g)[221]

# We want to keep phi proportion of the airports, limiting to the ones
# with smallest degree. We can get this by taking the first phi
# proportion of the ordered vertices
head(order(degree(g)), phi*vcount(g))

# As before we can compute the normalized size of the giant component.
# There's no need for replication because we didn't use any random
# selection in the procedure.
max(c(0, clusters(induced.subgraph(g, head(order(degree(g)), phi*vcount(g))))$csize)) / vcount(g)

# Finally we can create our function that does the targeted percolation.
targeted.site.percolation <- function(g, phi) {
	max(c(0, clusters(induced.subgraph(g, head(order(degree(g)), phi*vcount(g))))$csize)) / vcount(g)
}

# As before we can compute the targeted rates and plot the survivability.
ts.perc <- data.frame(phi=phis, perc=sapply(phis, targeted.site.percolation, g=g))
head(ts.perc)

plot(ts.perc)
abline(0, 1)
