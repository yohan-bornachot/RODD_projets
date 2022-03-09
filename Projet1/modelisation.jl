using JuMP
using CPLEX

function protect_species_cstrOnSurvival(p::Array{Float64, 3}, K_rares::Int, c::Array{Int, 2}, alpha::Array{Float64,1})
    verbose = false

    K = size(p, 1)
    n = size(p, 2)

    # Create the model
    m = Model(CPLEX.Optimizer)
    if verbose == false 
        MOI.set(m, MOI.Silent(), true)
    end

    ### Variables
    @variable(m, x[1:n,1:n], Bin)
    @variable(m, y[1:n, 1:n], Bin)

    ### Objective
    @objective(m, Min, sum(c[i,j]*x[i,j] for i in 1:n, j in 1:n))


    ### Constraints
    @constraint(m, [k in K_rares+1:K], sum(log(1 - p[k,i,j])*x[i,j] for i in 1:n, j in 1:n) <= log(1-alpha[k]))
    @constraint(m, [i in 2:n-1, j in 2:n-1], sum( x[k,l] for k in i-1:i+1, l in j-1:j+1 ) >= 9*y[i,j] )
    @constraint(m, [k in 1:K_rares], sum(log(1 - p[k,i,j])*y[i,j] for i in 1:n, j in 1:n) <= log(1-alpha[k]))
    @constraint(m, [i in 1:n], y[i,1]==0)
    @constraint(m, [i in 1:n], y[i,n]==0)
    @constraint(m, [i in 1:n], y[1,i]==0)
    @constraint(m, [i in 1:n], y[n,i]==0)
    ### Optimization
    optimize!(m)

    value_x = JuMP.value.(x)
    value_y = JuMP.value.(y)
    obj = JuMP.objective_value(m)
    proba = zeros(Float64, K)
    for k in 1:K 
        proba[k] = 1 - prod(1 - p[k,i,j]*value_x[i,j] for i in 1:n, j in 1:n)
    end
    return value_x, value_y, obj, proba
end

function protect_species_cstrOnBudget(p::Array{Float64, 3}, K_rares::Int, c::Array{Int, 2}, Cmax::Float64)
    verbose = false

    K = size(p, 1)
    n = size(p, 2)

    # Create the model
    m = Model(CPLEX.Optimizer)
    if verbose == false 
        MOI.set(m, MOI.Silent(), true)
    end

    ### Variables
    @variable(m, x[1:n,1:n], Bin)
    @variable(m, y[1:n, 1:n], Bin)

    ### Objective
    #@objective(m, Min, sum(c[i,j]*x[i,j] for i in 1:n, j in 1:n))
    @objective(m, Min, sum(log(1-p[k,i,j])*x[i,j] for i in 1:n, j in 1:n))


    ### Constraints
    #@constraint(m, [k in K_rares+1:K], sum(log(1 - p[k,i,j])*x[i,j] for i in 1:n, j in 1:n) <= log(1-alpha[k]))
    @constraint(m, sum(c[i,j]*x[i,j] for i in 1:n, j in 1:n) <= Cmax)
    @constraint(m, [i in 2:n-1, j in 2:n-1], sum( x[k,l] for k in i-1:i+1, l in j-1:j+1 ) >= 9*y[i,j] )
    @constraint(m, [k in 1:K_rares], sum(log(1 - p[k,i,j])*y[i,j] for i in 1:n, j in 1:n) <= log(1-alpha[k]))
    @constraint(m, [i in 1:n], y[i,1]==0)
    @constraint(m, [i in 1:n], y[i,n]==0)
    @constraint(m, [i in 1:n], y[1,i]==0)
    @constraint(m, [i in 1:n], y[n,i]==0)
    ### Optimization
    optimize!(m)

    value_x = JuMP.value.(x)
    value_y = JuMP.value.(y)
    obj = JuMP.objective_value(m)
    proba = zeros(Float64, K)
    for k in 1:K 
        proba[k] = 1 - prod(1 - p[k,i,j]*value_x[i,j] for i in 1:n, j in 1:n)
    end
    return value_x, value_y, obj, proba
end

