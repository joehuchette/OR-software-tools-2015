using Distributions
using SimJulia

# Model components

# process method for customers
function visit(customer::Process, time_in_bank::Float64) 
	@printf("%7.4f %s: Here I am\n", now(customer), customer)
	hold(customer, time_in_bank)
	@printf("%7.4f %s: I must leave\n", now(customer), customer)
end

# process method for source
function generate(source::Process, number::Int64, mean_time_between_arrivals::Float64) 
	d = Exponential(mean_time_between_arrivals)
    for i = 1:number
		c = Process(simulation(source), @sprintf("Customer%02d", i))
		activate(c, now(source), visit, 12.0)
		t = rand(d) # sample inter-arrival time "t"
		hold(source, t) # suspend source for "t" time units
	end
end

# Experiment data

num_customer = 5
end_time = 400.0
mean_time_between_arrivals = 10.0
theseed = 99999
srand(theseed)

# Model/Experiment

sim = Simulation(uint(16))
s = Process(sim, "Source")
activate(s, 0.0, generate, num_customer, mean_time_between_arrivals)
run(sim, end_time)
