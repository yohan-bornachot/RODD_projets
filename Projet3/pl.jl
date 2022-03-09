using JuMP
using CPLEX

include("read_instance.jl")

function save_diversity(nb_alleles_per_indiv::Array{Int,2}, Nm::Int, thetas::Array{Float64,1})
    n = size(nb_alleles_per_indiv,2)
    p = size(nb_alleles_per_indiv,1)

    verbose = false
    m = Model(CPLEX.Optimizer)
    if verbose == false 
        MOI.set(m, MOI.Silent(), true)
    end

    ### Variables
    @variable(m, N[1:n], Int)
    @variable(m, z[1:p]>=0)
    @variable(m, y[1:p]>=0)

    @objective(m, Min, sum(z[i] for i in 1:p))

    @constraint(m, [i in 1:n], N[i]>=0)
    @constraint(m, [i in 1:p], y[i] - sum(N[j] for j in 1:n if nb_alleles_per_indiv[i,j]==2) <= z[i])
    @constraint(m, [theta in thetas, i in 1:p], log(theta)+(1/theta)*(y[i]-theta) + log(2) >= sum(N[j] for j in 1:n if nb_alleles_per_indiv[i,j]==1))

    @constraint(m, sum(N[j] for j in 1:Nm) == n)
    @constraint(m, sum(N[j] for j in Nm+1:n) == n)

    optimize!(m)

    return JuMP.value.(N), JuMP.objective_value(m)
end

function main()
    nb_alleles_per_indiv, N, Nm, C, T, init = read_instance("DivGenetique_julia.dat")
    thetas = [init^((T-r)/(T-1)) for r in 1:T]
    N, obj = save_diversity(nb_alleles_per_indiv, Nm, thetas)
    display(N)
    println("\nValeur de l'objectif : ",obj)


end

main()