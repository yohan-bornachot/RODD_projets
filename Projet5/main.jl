using CLPLEX
using JuMP

# Paramètres du problème
T = 12 # Horizon de temps
M = 4 # Nombre de modes
E = [3 for _ in 1:T] # Impact environnemental max
f = [10, 30, 60, 90] # Couts fixes des modes de production
e = [8, 6, 4, 2] # Impact environnementaux des modes de production
h = ones(T) # Cout de stockage unitaire (invariable au cours du temps)
p = zeros(T, M) # Cout d'approvisionnement unitaire (invariable au cours du temps et indépendant du mode)


function solve_instance(T::Int, M::Int, E::Array{Int, 1}, d::Array{Int, 1}, f::Array{Int, 1}, e::Array{Int, 1}, h::Array{Int, 1}, p::Array{Int, 2}, P::Int)
    # Initialisation du modèle
    model = Model(CPLEX.Optimizer)

    # Variables
    @variable(model, x[1:T, 1:M] >= 0)
    @variable(model, y[1:T, 1:M], Bin)
    @variable(model, s[1:T] >= 0)
    @variable(model, pol[1:T])

    # Objectif
    @objective(model, Min, sum(p[t, m]*x[t, m] + f[t]*y[t] for m in 1:M, t in 1:T) + sum(h[t]*s[t] for t in 1:T))

    # Contraintes
    @constraint(model, [t in 1:T], sum(x[t, m] - s[t] + s[t-1] for m in 1:M) == d[t])
    @constraint(model, [t in 1:T, m in 1:M], x[t, m] <= sum(d[t_prime] for t_prime in t:T)*y[t, m])
    @constraint(model, [t in 1:T], sum( sum(e[t_prime, m] - E[t_prime] for m in 1:M) for t_prime in t:min(T, t+P)) == pol[t])
    @constraint(model, [t in 1:T], pol[t] <= 0)

    optimize!(model)
    x_val = JuMP.value.(x)
    y_val = JuMP.value.(y)
    s_val = JuMP.value.(s)
    pol_val = JuMP.value.(pol)

    obj = JuMP.objective_value(m)

    return x_val, y_val, s_val, pol_val, obj
end

cout_moyen = zeros(T)
pol_moyenne = zeros(T)

nb_iter = 10
# Résolution des instances pour plusieurs périodes de temps
for P in 1:T
    # Calcul du cout moyen et de la pollution moyenne sur plusieurs tirages aleatoires de demandes
    for _ in 1:nb_iter
        d = [rand(20, 70) for _ in 1:T] # Demande suit loi uniforme
        x, y, s, pol, obj = solve_instance(T, M, E, d, f, e, h, p, P)
        cout_moyen[i] += obj
        pol_moyenne[i] += sum(pol)/T
    end
    cout_moyen[P] /= nb_iter
    pol_moyenne[P] /= nb_iter
end

fp = open("./result.csv", mode="w")
println(fp, 1:T)
println(fp, cout_moyen)
println(fp, pol_moyenne)