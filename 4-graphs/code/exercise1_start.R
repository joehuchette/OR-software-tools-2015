# Split the data by the carrier; this creates a list.
spl <- split(dat, dat$Carrier)

# Using lapply, we will call a function on each subset of dat that
# builds a graph using the exact same split-apply-combine code we used
# before.
carrier.graphs <- lapply(spl, function(dat) {
	# Compute "edges" by splitting on Origin/Dest pairs, computing a 1-row
	# data frame for each, and then combining with do.call and rbind.

	# Compute "vertices" by splitting on Origin, computing a 1-row data
	# frame for each, and then combining with do.call and rbind.

	# Compute and return a graph g using graph.data.frame()
})

