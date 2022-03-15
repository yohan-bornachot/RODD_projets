using JuMP
using CPLEX

function A_ij(i::Int, j::Int, n::Int, m::Int)
    l=[]
    if i>1 
        push!(l,[i-1,j])
    end
    if i<n 
        push!(l,[i+1,j])
    end
    if j>1
        push!(l,[i,j-1])
    end
    if j<m 
        push!(l,[i,j+1])
    end
    return l
end

function methode_mixte(t::Array{Int,2}, w1::Float64, w2::Float64, l::Float64, g::Float64)

    verbose = false

    n = size(t,1)
    m = size(t,2)

    # Create the model
    model = Model(CPLEX.Optimizer)
    if verbose == false 
        MOI.set(model, MOI.Silent(), true)
    end

    ### Variables
    @variable(model, x[1:n,1:m], Bin)
    @variable(model, d[1:n, 1:m]>=0)

    @objective(model, Max, w1*sum(t[i,j]*(1-x[i,j]) for i in 1:n, j in 1:m) + w2*l*g*sum(4*x[i,j]-d[i,j] for i in 1:n, j in 1:m))

    @constraint(model, [i in 1:n, j in 1:m], d[i,j] >= sum(x[v[1],v[2]] for v in A_ij(i,j,n,m))-size(A_ij(i,j,n,m),1)*(1-x[i,j]))
    @constraint(model, sum(x[i,j] for i in 1:n, j in 1:m) >= 60)

    optimize!(model)

    return JuMP.value.(x), JuMP.objective_value(model)

end

function methode_quadratique(t::Array{Int,2}, w1::Float64, w2::Float64, l::Float64, g::Float64)
    
    verbose = false

    n = size(t,1)
    m = size(t,2)

    # Create the model
    model = Model(CPLEX.Optimizer)
    if verbose == false 
        MOI.set(model, MOI.Silent(), true)
    end

    ### Variables
    @variable(model, x[1:n,1:m], Bin)
    @variable(model, y_h[1:n-1,1:m], Bin)
    @variable(model, y_v[1:n,1:m-1], Bin)
    @variable(model, S1>=0)
    @variable(model, S2>=0)
    @variable(model, S3>=0)
    @variable(model, S4>=0)

    @objective(model, Max,  w1*sum(t[i,j]*(1-x[i,j]) for i in 1:n, j in 1:m) + w2*l*g*(S1+S2+S3+S4))

    @constraint(model, sum(x[i,j] for i in 1:n, j in 1:m) >= 60)

    @constraint(model, S1 == sum(x[i,1]+x[i,m] for i in 1:n))
    @constraint(model, S2 == sum(x[1,j]+x[n,j] for j in 1:m))
    @constraint(model, S3 == sum(x[i,j]+x[i,j+1]-2*y_v[i,j] for i in 1:n, j in 1:m-1))
    @constraint(model, S4 == sum(x[i,j]+x[i+1,j]-2*y_h[i,j] for i in 1:n-1, j in 1:m))

    @constraint(model, [i in 1:n, j in 1:m-1], y_v[i,j]>=0)
    @constraint(model, [i in 1:n, j in 1:m-1], y_v[i,j]>= x[i,j] + x[i,j+1] - 1)

    @constraint(model, [i in 1:n-1, j in 1:m], y_h[i,j]>=0)
    @constraint(model, [i in 1:n-1, j in 1:m], y_h[i,j]>= x[i,j] + x[i+1,j] - 1)
    
    optimize!(model)

    return JuMP.value.(x), JuMP.objective_value(model)

end