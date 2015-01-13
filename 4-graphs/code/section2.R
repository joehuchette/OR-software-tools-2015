##################################################################
# Section 2 -- Network Visualization
##################################################################

# Let's start out by seeing what exactly is returned when we run a
# graph layout algorithm. Of course, we have longitude/latitude information
# for airports, so we're doing this more as an exercise in looking at
# graph layout algorithms. Later in the section we'll layout nodes based on
# geography.
layout1 <- layout.fruchterman.reingold(g)
dim(layout1)
head(layout1)

# It's just a set of 2-d points, one for each vertex. We could get a
# higher-dimensional layout with the "dim" parameter. Force-directed
# layouts are typically optimized from a random starting location, so
# we would expect a different layout if we ran it again (this is one of
# the complaints people have with these sorts of layouts). We could use
# set.seed() to ensure the same value for multiple runs of the algorithm.
layout1 <- layout.fruchterman.reingold(g)
head(layout1)

# We can plot with our selected layout with the plot() function.
plot(g, layout=layout1)  # Can cancel with escape key

# It takes a long time to plot the graph to the R display, so we can
# instead plot it to a file and then open the file.
png("plot1.png")
plot(g, layout=layout1)
dev.off()

# Most first attempts at plotting a graph look pretty bad. We need to
# do the following:
# 1) Remove the vertex names
# 2) Make the vertices smaller
# 3) Remove the arrowheads (almost all edges will be bidirectional)
# We'll need to look at ?igraph.plotting to figure out how to do this
?igraph.plotting
png("plot2.png")
plot(g, layout=layout1, vertex.size=3, edge.arrow.mode=0, vertex.label=NA)
dev.off()

# So far we set all the plotting properties vertex.size, vertex.label,
# and edge.arrow.mode to single values, meaning that value applied for
# all vertices/edges. We can also set values dynamically based on
# vertex/edge metadata, providing one value for each node or edge.
# First, let's use a color gradient based on metadata. We'll make vertices
# darker gray if they have more volume and lighter gray if they have less.

# colorRamp returns a function that will convert values between 0
# and 1 into colors between our color endpoints. It returns a matrix
# the three columns are red, green, and blue; we can convert this into
# a vector with the rgb() function.
grad.fxn <- colorRamp(c("lightgray", "black"))
grad.fxn
grad.fxn(c(0, .2, .5, 1))
rgb(grad.fxn(c(0, .2, .5, 1)), max=255)
color.mat <- grad.fxn(V(g)$NumFlights / max(V(g)$NumFlights))
head(color.mat)
dim(color.mat)
vertex.colors <- rgb(color.mat, max=255)
head(vertex.colors)
length(vertex.colors)

png("plot3.png")
plot(g, layout=layout.lgl(g), vertex.size=3, edge.arrow.mode=0, vertex.label=NA, vertex.color=vertex.colors)
dev.off()

# One difficulty with plotting graphs is there being a mass of edges. One
# approach would be to remove low-volume edges or diminish their width
# (we'll do this in a bit); another is to change color and transparency to
# draw attention to important edges. Here, we'll make edges red if at least
# 50% of departures on this link are late and transparent light gray
# otherwise.

# A convenient way to specify colors is with hexidecimal (we just saw this
# when outputting vertex.colors). A standard color would be something like
# #00FF80, which means hexidecimal 00 (0) for red, FF (255) for green, and
# 80 (128) for blue. Because transparency is not specified it is assumed to
# be non-transparent. If we add a pair of hexidecimal digits at the end
# they represent the transparency proportion. #00FF80FF is non-transparent,
# #00FF8080 is partially transparent, and #00FF8000 is fully transparent
# aka invisible. Our light gray color will be #EEEEEE22, which is mostly
# transparent.

# We now want different colors conditional on the value of E(g)$LateDep.
# This is typically done with the ifelse() function.
head(E(g)$LateDep)
head(ifelse(E(g)$LateDep >= 0.5, "red", "#EEEEEE22"))
edge.colors <- ifelse(E(g)$LateDep >= 0.5, "red", "#EEEEEE22")
table(edge.colors)
png("plot4.png")
plot(g, layout=layout.lgl(g), vertex.size=3, edge.arrow.mode=0, vertex.label=NA, vertex.color=vertex.colors, edge.color=edge.colors)
dev.off()
