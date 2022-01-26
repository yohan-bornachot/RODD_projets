using JuMP
using CPLEX


function protect_species(p::Array{Float, 3}, K_rares::Int)

    K = size(p, 1)
    n = size(p, 2)

    # Create the model
    m = Model(CPLEX.Optimizer)

    ### Variables
    @variable(m, x[1:n,1:n], Bin)
    @variable(m, y[1:n, 1:n], Bin)

    ### Objective
    @objective(m, Min, sum(c[i,j]*x[i,j] for i in 1:n, j in 1:n))

    ### Définition des voisinages de chaque parcelles
    V = zeros(n,n)
    V[1, :] = 0
    V[n, :] = 0
    V[:, 1] = 0
    V[:, n] = 0
    for i in 2:n-1
        for j in 2:n-1
            V[i,j] = [(k,l) for k in i-1:i+1, l in 1:n]
        end
    end

    ### Constraints
    @constraint(m, [k in 1:K_rares], sum(log(1 - p[k,i,j])*x[i,j] for i in 1:n, j in 1:n) <= log(1-alpha[k]))
    @constraint(m, [i in 2:n-1, j in 2:n-1], sum( x[k,l] for k in i-1:i+1, l in j-1:j+1 ) >= 9*y[i,j] )
    @constraint(m, [k in K_rares+1:K], sum(log(1 - p[k,i,j])*y[i,j] for i in 1:n, j in 1:n) <= log(1-alpha[k]))

    ### Optimization
    !optimize(m)

    value_x = JuMP.value.x()
    value_y = JuMP.value.y()
    return value_x, value_y
end

