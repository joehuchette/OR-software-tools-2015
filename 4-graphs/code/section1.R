##################################################################
# Section 1 -- Data Wrangling to Construct Networks in R
##################################################################

# Let's start by loading in our data. This could take a bit of time.
# We use stringsAsFactors=FALSE because it helps us avoid factor
# levels with no data when we subset our data.
dat <- read.csv("On_Time_On_Time_Performance_2014_9.csv",
                stringsAsFactors=FALSE)
head(dat)

# To get the edge information, we'll split into all unique Origin -> Dest
# pairs; using paste() is a convenient way to build a key out of two or
# more variables when splitting data with the split() function.
e.spl <- split(dat, paste(dat$Origin, dat$Dest))

# In addition to the origin and destination of an edge, we can store
# the number of flights for this pairing, the proportion of late
# departures and arrivals, and the average taxi out and in times.
# For the "apply" step of our split-apply-combine paradigm
e.spl2 <- lapply(e.spl, function(x) {
  data.frame(Origin = x$Origin[1],
             Dest = x$Dest[1],
             NumFlights = nrow(x),
             LateDep = mean(x$DepDel15, na.rm=T),
             LateArr = mean(x$ArrDel15, na.rm=T),
             TaxiOut = mean(x$TaxiOut, na.rm=T),
             TaxiIn = mean(x$TaxiIn, na.rm=T))
})

# As usual, we'll use do.call() with rbind() for the "combine" step.
edges <- do.call(rbind, e.spl2)

# We can put the whole split-apply-combine into a single line of code when
# computing the vertex information, which limits the number of variables
# we have floating around.
vertices <- do.call(rbind, lapply(split(dat, dat$Origin), function(x) {
  data.frame(Origin = x$Origin[1],
             NumFlights = nrow(x),
             LateDep = mean(x$DepDel15, na.rm=T),
             LateArr = mean(x$ArrDel15, na.rm=T),
             TaxiOut = mean(x$TaxiOut, na.rm=T),
             TaxiIn = mean(x$TaxiIn, na.rm=T))
}))

# Let's also load in the locations of the airports by merging with our
# dataset of airport locations, making sure we didn't lose any
# airports in the process of the merge.
airports <- read.csv("../data/airports.csv", stringsAsFactors=FALSE)
head(airports)
dim(vertices)
vertices <- merge(vertices, airports, by.x="Origin", by.y="IATA")
dim(vertices)

# Now we can construct our graph with graph.data.frame() from igraph.
library(igraph)
g <- graph.data.frame(edges, TRUE, vertices)

# The first line says we have a directed graph (D) with named vertices (N).
# The attributes list shows all vertex and edge attributes. The first
# entry in ()'s is whether vertex (v) or edge (e) attribute, and the second
# is the type of attribute: character (c) or numeric (n).
g

# Easy to access vertex and edge sequences and metadata
head(V(g))
head(V(g)$Lat)
head(E(g))
head(E(g)$LateDep)

# Let's compute some basic properties of the network (more metrics coming
# later in the module)
ecount(g)
vcount(g)
graph.density(g)
