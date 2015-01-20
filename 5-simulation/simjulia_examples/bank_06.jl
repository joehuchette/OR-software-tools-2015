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

end

# Experiment data

num_customer = 5
end_time = 400.0
mean_time_between_arrivals = 10.0
theseed = 99999
srand(theseed)

# Model/Experiment

sim = Simulation(uint(16))
# define source here

run(sim, end_time)
