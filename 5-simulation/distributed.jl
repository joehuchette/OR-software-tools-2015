# Start up multiple processors
# addprocs(8)

# can also start up via command line, ie julia -p 4

# View the running worker processors
workers()

# Run a simple job on a worker
ref = @spawn rand()

# ref contains a reference to the data:
#   -- ref.where contains proc id of where the data is stored
#   -- ref.whence contains the master proc's id
#   -- ref.id is a unique ID

# To see the result locally, run fetch:
fetch(ref)

# If we want to specify the proc the code runs on
ref = @spawnat 3 rand()

# Suppose we define a our own function 
function estimatePi(n)
	count = 0;
	for i in 1:n
		if rand()^2 + rand()^2 < 1
			count += 1
		end
	end
	return count
end


# Works fine locally
n = 1000
piEst = 4 * estimatePi(n)/1000
println("Pi is approximately $piEst")

# What happens here?
# @spawnat 2 estimatePi(1000)

# To run code on all workers, use @everywhere
@everywhere function estimatePi(n)
	count = 0;
	for i in 1:n
		if rand()^2 + rand()^2 < 1
			count += 1
		end
	end
	return count
end

# Now it works
n = 1000
piEst = 4/n * remotecall_fetch(2,estimatePi,n) # spawn f on proc 2 and fetch results

# Assignment: Write a function that runs the simulation in bank_11.jl and returns how long it
# took to process all the customers. Run this function on a different core

	# Hint: After the simulation is run, sim.time contains the time of the last scheduled event





# Using all cores

# We want each processsor to run some simulations, and then return its results

# Could do it manually:

nCpus = length(workers())
totalSims = 8 * 10^7
sims_per_cpu = div(totalSims,nCpus) # integer arithmatic

results = cell(nCpus)
for i in 1:nCpus
	results[i] = @spawnat i estimatePi(sims_per_cpu)
end
for i in 1:length(results)
	results[i] = fetch(results[i]);
end
total = 0
for i in 1:nCpus
	total += results[i]
end
piEst = 4 * total / totalSims
println("Pi is approximately $piEst")

# Julia also has a built-in method to help us 
help("map") # like apply in R

input = sims_per_cpu * ones(nCpus)
results = map(estimatePi,input)

help("pmap")
results = pmap(estimatePi,input)

total = 0
for i in 1:nCpus
	total += results[i]
end
piEst = 4 * total / totalSims
println("Pi is approximately $piEst")

function benchmark(n)
	input = sims_per_cpu * ones(nCpus)
	@time map(estimatePi,input)
	@time pmap(estimatePi,input)
	return
end

benchmark(10)
benchmark(10^2)
benchmark(10^7)

# Assignment 2: Use PMAP to run bank_11.jl in parallel to estimate the mean time to process all the customers
	# Hint: define a function that takes the random seed as the input and returns the time








# When doesn't pmap scale well? 

# pmap must send input to each proc, and get output <- lots of communication
# Okay if few, big jobs, but not good for many small jobs

# Solution: MapReduce
# Send "batches" to each proc (Map)
# Each proc runs batch and creates batch summary (reduce)
# Each proc returns batch summary 
# Master proc compiles summary files from batch summaries (reduce)

# Syntax:
# @parallel [reducer] for ...
# [code]
# end

# Adds a whole bunch of random numbers together
@parallel (+) for i in 1:10^8
	rand()
end

# Easier than our pmap example above
count = @parallel (+) for i in totalSims
	estimatePi(1)
end

estPi = 4 * count / totalSims
println("Pi is approximately $piEst")

## How to write a custom reducer

# Reducer takes in two arguments of the same type, and returns that same type
# e.g. the "+" method takes in two real numbers and returns a real number

# Suppose we want to numerically estimate the mean and standard error of our distribution
# E[x] = 1/n sum x_i
# E[x^2] = 1/n sum x_i^2
# var[x] = E[x^2] - E^2[x]

@everywhere type Results
	estimate
	estimateSq
end
@everywhere Results(x) = Results(x,x^2)

# And then modify our simulate function to return Results...
@everywhere function runSims(n)
	count = estimatePi(n)
	piEst = 4 * count / n
	return Results(piEst)
end

# And now we can write our reducer

@everywhere function myReduce(a::Results,b::Results)
	return Results(a.estimate + b.estimate, 
		           a.estimateSq + b.estimateSq)
end

# Now we can do our MapReduce!
n = 10^3
results = @parallel myReduce for i in 1:n
	runSims(1000)
end

# And now to process our results
function process(results::Results, n)
	mean = results.estimate / n
	stdev = sqrt(results.estimateSq / n - mean^2)

	println("Grand mean: $mean")
	println("Std  Error: $stdev")
end

process(results,n)

# Assignment: Write your own MapReduce implementation to calculate the mean and standard devation
# of the time to process all the customers in bank_11.jl








	