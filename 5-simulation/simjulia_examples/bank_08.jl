using Distributions
using SimJulia

# Model components

function visit(customer::Process, time_in_bank::Float64, clerk::Resource)
    
end

function generate(source::Process, number::Int64, mean_time_between_arrivals::Float64, mean_time_in_bank::Float64, clerk::Resource)
	d_tba = Exponential(mean_time_between_arrivals)
	d_tib = Exponential(mean_time_in_bank)
    # generate customers
end

# Experiment data

max_number = 5
max_time = 400.0
mean_time_between_arrivals = 10.0
mean_time_in_bank = 12.0
theseed = 99999
srand(theseed)

# Model/Experiment

sim = Simulation(uint(16))
# create resource "k"
s = Process(sim, "Source")
activate(s, 0.0, generate, max_number, mean_time_between_arrivals, mean_time_in_bank, k)
run(sim, max_time)
