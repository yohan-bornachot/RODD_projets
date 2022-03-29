using JuMP
using CPLEX
include("read_instance.jl")

function planification_culturale(n_parcelles::Int, T::Int, lmax::Int, amax::Int, C::Array{Int, 1}, Demande::Array{Int, 2}, Sommets::Array{Int, 2}, Arcs::Array{Int, 2})
    """
    n_parcelles : nombre de parcelles
    T : horizon de temps
    lmax : nombre max de semestres de jachères successifs
    amax : nombre max de semestres de production successifs
    C : C = C1 U C2 où C1 --> ensemble des cultures possibles semestres impairs (C2 ... pairs)
    Demande : Matrice (n_cultures,T) donnant la production demandee pour chaque culture chaque semestre
    Sommets : Etats du graphe --> (l, a, j) --> matrice 
    Arcs : Transitions du graphe Rp(l, a, i, j) --> matrice (n_etats, n_etats)
    donnant les rendements de l'état d'arrivée (l, a, j) quand la culture précédente était i
    """

    n_etats = size(Sommets, 1)
    n_arcs = size(Arcs, 1)

    # Initialisation du modèle
    model = Model(CPLEX.Optimizer)

    verbose = false
    if verbose == false 
        MOI.set(model, MOI.Silent(), true)
    end

    # Variables
    @variable(model, x[1:n_parcelles, 1:T, u in 1:length(Arcs)], Bin)

    # Objectif
    @objective(model, Min, sum(x[p, 1, u] for p in 1:n_parcelles for u in 1:length(Arcs)))

    # Contraintes:
    # Respect de la demande
    @constraint(model, [t in 1:T, c in 1:n_cultures], sum(x[p, t, u]*arc.r for arc in Arcs for p in 1:n_parcelles) >= Demande[c, t])
    # Initialisation du flux dans les parcelles
    sommet_init = Sommet(2, 0, 0)
    @constraint(model, [p in 1:n_parcelles], sum(x[p, 1, u] for u in arcs_sortants(sommet_init)) <= 1)
    # Conservation du flux dans les parcelles
    @constraint(model, [p in 1:n_parcelles, t in 1:T, sommet in Sommets], sum(x[p, t, u] for u in arcs_entrants(sommet)) == sum(x[p, t, u] for u in arcs_sortants(sommet)))
    # Impossibilité d'aller d'un sommet à un autre si paire à paire ou impaire à impaire
    @constraint(model, [p in 1:n_parcelles, t in 1:T, u in Arcs ; u.f.j == C[1+t%2] ], x[p, t, u] == 0)

    optimize!(model)
    x_val = JuMP.value.(x)
    obj = JuMP.objective_value(model)

    return x_val, obj
end

function arcs_entrants(sommet::Sommet)
    return [arc for arc in Arcs if sommet == arc.i]
end

function arcs_sortants(sommet::Sommet)
    return [arc for arc in Arcs if sommet == arc.j]
end

function main()
    filename = "CROPRODD.dat"
    n_parcelles, T, lmax, amax, C, Demande, Sommets, Arcs = read_instance(filename)

    x, obj = planification_culturale(n_parcelles, T, lmax, amax, C, Demande, Sommets, Arcs)
    
    fp = open("./result.csv", "w")
    println(fp, x)
    println(fp, obj)
    close(fp)
end

