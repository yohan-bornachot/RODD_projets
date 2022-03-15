using CPLEX
using JuMP

# Paramètres du problème
T = 30 # Horizon de temps
M = 4 # Nombre de modes
E = [3 for _ in 1:T] # Impact environnemental max
f = [10, 30, 60, 90] # Couts fixes des modes de production
e = [8, 6, 4, 2] # Impact environnementaux des modes de production
h = ones(Int, T) # Cout de stockage unitaire (invariable au cours du temps)
p = zeros(Int, T, M) # Cout d'approvisionnement unitaire (invariable au cours du temps et indépendant du mode)


function solve_instance(T::Int, M::Int, E::Array{Int, 1}, d::Array{Int, 1}, f::Array{Int, 1}, e::Array{Int, 1}, h::Array{Int, 1}, p::Array{Int, 2}, P::Int)
    # Initialisation du modèle
    model = Model(CPLEX.Optimizer)

    verbose = false

    if verbose == false 
        MOI.set(model, MOI.Silent(), true)
    end

    # Variables
    @variable(model, x[1:T, 1:M] >= 0)
    @variable(model, y[1:T, 1:M], Bin)
    @variable(model, s[1:T+1] >= 0)

    # Objectif
    @objective(model, Min, sum(p[t, m]*x[t, m] + f[m]*y[t, m] for m in 1:M, t in 1:T) + sum(h[t]*s[t+1] for t in 1:T))

    # Contraintes
    @constraint(model, s[1]==0)
    @constraint(model, [t in 1:T], sum(x[t, m] - s[t+1] + s[t] for m in 1:M) == d[t])
    @constraint(model, [t in 1:T, m in 1:M], x[t, m] <= sum(d[t_prime] for t_prime in t:T)*y[t, m])
    @constraint(model, [t in 1:T],  sum( (e[m] - E[t_prime])*x[t_prime, m] for m in 1:M, t_prime in t:min(T, t+P)) <= 0)

    #println(JuMP.constraints_string(REPLMode, model))

    optimize!(model)
    x_val = JuMP.value.(x)
    y_val = JuMP.value.(y)
    s_val = JuMP.value.(s)

    pol_val = sum(e[m]*x_val[t, m] for m in 1:M, t in 1:T)/T

    obj = JuMP.objective_value(model)

    return x_val, y_val, s_val, pol_val, obj
end

cout_moyen = zeros(T)
pol_moyenne = zeros(T)
pol_var = zeros(T)

nb_iter = 20
# Résolution des instances pour plusieurs périodes de temps
for i in 1:nb_iter
    print("\rActuellement : ",i,"/",nb_iter," itérations effectuées")
    d = [mod(rand(Int),70-20)+20 for _ in 1:T] # Demande suit loi uniforme
    for P in 1:T
        x, y, s, pol, obj = solve_instance(T, M, E, d, f, e, h, p, P)
        cout_moyen[P] += obj
        pol_moyenne[P] += pol
    end
    
end
for P in 1:T
    cout_moyen[P] = round(cout_moyen[P]/nb_iter, digits = 3)
    pol_moyenne[P] = round(pol_moyenne[P]/nb_iter, digits = 3)
end

fp = open("./result.csv", "w")
println(fp, T)
println(fp, cout_moyen)
println(fp, pol_moyenne)
close(fp)
