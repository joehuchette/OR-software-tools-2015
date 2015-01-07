##################################################################
# Section 5 -- Community Detection 
##################################################################

# One of the many modularity-maximizing algorithms in spinglass.community
comm <- spinglass.community(g)
comm
str(comm)
table(comm$membership)

# Great. We'll want to plot our communities so let's actually do this
# again, limiting to the continental US. We'll take this code from the
# plotting bonus question and modify it for our needs, coloring airports
# based on their community.
g2 <- induced.subgraph(g, V(g)$Lat >= 15 & V(g)$Lat <= 50 & V(g)$Lon >= -130 & V(g)$Lon <= -60 & V(g)$Country == "United States")
comm2 <- spinglass.community(g2)
comm2

# Let's get some spiffy colors for our nodes -- we'll get a palette
# with 5 colors from RColorBrewer, which has carefully selected palettes
# where all the colors look good together.
library(RColorBrewer)
display.brewer.all()
colors <- brewer.pal(5, "Set1")
colors

# Now we can actually plot our image and check it out. We'll index within
# the colors vector when we set vertex.color. We can see the benefit of
# having vertex metadata instead of storing it outside the graph -- if
# we hadn't stored Lon, Lat, and NumFlights as metadata we would have
# needed to subset each for our continental US plot.
png("section5.png", width=960, height=480)
plot(g2, layout=cbind(V(g2)$Lon, V(g2)$Lat), edge.arrow.mode=0, vertex.label=NA, vertex.size=3, edge.color=ifelse(E(g2)$NumFlights >= 100, "black", NA), vertex.color=colors[comm2$membership], asp=0.5)
dev.off()
