# Column Generation 

This class will cover column-wise modeling and column generation solution technique. Code will be posted before the start of the class.

## Preassignment


### Install Julia, IJulia and JuMP

Please see preassignment for [module 6, nonlinear optimization](https://github.com/joehuchette/OR-software-tools-2015/tree/master/6-nonlinear-opt).

### Install Gurobi and Gurobi Interface in Julia

Please see preassignment for [module 7, mixed-integer optimization](https://github.com/joehuchette/OR-software-tools-2015/blob/master/7-adv-optimization/README.md).

### Install the [Graphs](https://github.com/JuliaLang/Graphs.jl) package in Julia

Enter the following in Julia console
```jl
julia> Pkg.add("Graphs")
```

## 1. Solving a shortest path problem
Enter the following Julia code and submit the output to Stellar.

```jl
using Graphs

# construct a graph and the edge distance vector

g = simple_inclist(5)

inputs = [       # each element is (u, v, dist)
    (1, 2, 10.),
    (1, 3, 5.),
    (2, 3, 2.),
    (3, 2, 3.),
    (2, 4, 1.),
    (3, 5, 2.),
    (4, 5, 4.),
    (5, 4, 6.),
    (5, 1, 7.),
    (3, 4, 9.) ]

ne = length(inputs)
dists = zeros(ne)

for i = 1 : ne
    a = inputs[i]
    add_edge!(g, a[1], a[2])   # add edge
    dists[i] = a[3]            # set distance
end

r = dijkstra_shortest_paths(g, dists, 1)

r.parents
```

## 2. Column-wise modeling in JuMP

Enter the following JuMP code and submit the output to Stellar.
```jl
using JuMP, Gurobi

m = Model(solver=GurobiSolver())
@defVar(m, 0 <= x <= 1)
@defVar(m, 0 <= y <= 1)
@setObjective(m, Max, 5x + 1y)
@addConstraint(m, con, x + y <= 1)
solve(m)  # x = 1, y = 0
@defVar(m, 0 <= z <= 1, objective = 10.0, inconstraints = [con], coefficients = [1.0])
# The constraint is now x + y + z <= 1
# The objective is now 5x + 1y + 10z
solve(m)  # z = 1
```

## Questions?
Email chiwei@mit.edu
