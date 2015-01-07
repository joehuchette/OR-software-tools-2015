##################################################################
# Exercise 2 -- Manipulating visual properties
##################################################################
# 
# 1)  Plot the Delta Airlines network (IATA code DL) with the node size
#     scaled by the square root of the number of flights from an airport.
#     Color the Atlanta airport (ATL) red and other airports black.
# B1) Plot the full network with nodes positioned based on their
#     latitude/longitude instead of using a layout algorithm. Adjust
#     edge.color to only plot edges with 100 or more flights, and mark
#     the top five airports by volume (ATL, ORD, DFW, DEN, LAX) as red
#     and the other as light gray.
# B2) Replicate B1, limiting to the continental United States. You can
#     do this by limiting the longitude range to [-130, -60], limiting
#     the latitude range to [15, 50], and limiting the country to
#     "United States". Plot with a 2:1 width:height ratio and the
#     appropriate asp value for plot. Hint: ?induced.subgraph.

png("exercise2_1.png")
dl <- carrier.graphs$DL
plot(dl, layout=layout.lgl(dl), edge.arrow.mode=0, vertex.label=NA, vertex.size=sqrt(V(dl)$NumFlights)/5, vertex.color=ifelse(V(dl)$name == "ATL", "red", "black"))
dev.off()

png("exercise2_b1.png")
plot(g, layout=cbind(V(g)$Lon, V(g)$Lat), edge.arrow.mode=0, vertex.label=NA, vertex.size=3, edge.color=ifelse(E(g)$NumFlights >= 100, "black", NA), vertex.color=ifelse(V(g)$name %in% c("ATL", "ORD", "DFW", "DEN", "LAX"), "red", "lightgray"))
dev.off()

png("exercise2_b2.png", width=960, height=480)
g2 <- induced.subgraph(g, V(g)$Lat >= 15 & V(g)$Lat <= 50 & V(g)$Lon >= -130 & V(g)$Lon <= -60 & V(g)$Country == "United States")
plot(g2, layout=cbind(V(g2)$Lon, V(g2)$Lat), edge.arrow.mode=0, vertex.label=NA, vertex.size=3, edge.color=ifelse(E(g2)$NumFlights >= 100, "black", NA), vertex.color=ifelse(V(g2)$name %in% c("ATL", "ORD", "DFW", "DEN", "LAX"), "red", "lightgray"), asp=0.5)
dev.off()
