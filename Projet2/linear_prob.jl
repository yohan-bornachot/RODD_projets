using JuMP
using CPLEX

function linear_prob(C::Array{Int, 2}, d::Array{Float64, 4}, A_min::Int, A_max::Int, B::Int, lambda::Float64)
    verbose = false

    n = size(C,1)

    # Create the model
    m = Model(CPLEX.Optimizer)
    if verbose == false 
        MOI.set(m, MOI.Silent(), true)
    end

    ### Variables
    @variable(m, x[1:n,1:n], Bin)
    @variable(m, z[1:n, 1:n, 1:n, 1:n], Bin)

    @variable(m, num >= 0)
    @variable(m, den >= 0)

    @objective(m, Max, -num-lambda*den)

    @constraint(m, sum( d[i,j,k,l]*z[i,j,k,l] for i in 1:n, j in 1:n, k in 1:n, l in 1:n) == num)
    @constraint(m, sum( x[i,j] for i in 1:n, j in 1:n) == den)
    @constraint(m, A_min <= den)
    @constraint(m, den <= A_max)
    @constraint(m, sum(C[i,j]*x[i,j] for i in 1:n, j in 1:n) <= B)
    @constraint(m, [i in 1:n, j in 1:n, k in 1:n, l in 1:n], z[i,j,k,l] <= x[k,l])
    @constraint(m, [i in 1:n, j in 1:n], sum(z[i,j,k,l] for k in 1:n, l in 1:n) == x[i,j])
    @constraint(m, [i in 1:n, j in 1:n], z[i,j,i,j] == 0)

    optimize!(m)
    if JuMP.termination_status(m) != JuMP.OPTIMAL
        return -1, -1, -1, -1
    end

    return JuMP.value.(num), JuMP.value.(den), JuMP.value.(x), JuMP.objective_value(m)
end