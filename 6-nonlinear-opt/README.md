# Nonlinear optimization

This class covers topics in nonlinear optimization. Code will be posted before the start of the class.

## Pre-assignment:

### Install Julia and IJulia
IJulia is required for this class. See the instructions at http://www.juliaopt.org/install.pdf. Alternatively, you may use [JuliaBox](https://juliabox.org/) to complete the assignment and follow along with the class if there's any trouble with a local installation.

### Install packages
We will use the following packages:
- JuMP
- Ipopt
- Convex
- Distributions
- PyPlot
- Gadfly
- Interact
- ECOS

Install each one with ``Pkg.add("xxx")`` where ``xxx`` is the package name.

### Test the installation

In a blank IJulia notebook, paste the following code into a cell:

```julia
import Convex
x = Convex.Variable(Convex.Positive())
Convex.solve!(Convex.minimize(x))
Convex.evaluate(x)
```

and run it by pressing shift-enter. The result should be some iteration output from ECOS and then a small value that's very close to zero.

In the next cell, paste and run the following code:

```julia
import JuMP
m = JuMP.Model()
@JuMP.defVar(m, x >= 0)
@JuMP.setNLObjective(m, Min, x)
JuMP.solve(m)
JuMP.getValue(x)
```

You should see some output from Ipopt and then the result which should be a number that's exactly or very close to zero.

(Note that we use ``import JuMP`` instead of ``using JuMP`` because there are some clashes in the names used by Convex.jl and JuMP.)

Now go to ``File -> Download as -> IPython Notebook (.ipynb)`` and save the notebook file to your computer. Submit this file to Stellar.
