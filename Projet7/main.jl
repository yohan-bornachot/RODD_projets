using JuMP
using CPLEX
include("read_instance.jl")

function planification_culturale(n_parcelles::Int, T::Int, SURF::Int, lmax::Int, amax::Int, C::Array{Int, 2}, Demande::Array{Int, 2}, Sommets::Array{Sommet, 1}, Arcs::Array{Arc, 1})
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

    # Initialisation du modèle
    model = Model(CPLEX.Optimizer)

    verbose = false
    if verbose == false 
        MOI.set(model, MOI.Silent(), true)
    end

    # Variables
    @variable(model, x[1:n_parcelles, 1:T, u in 1:length(Arcs)], Bin)

    # Objectif
    sommet_init = Sommet(2, 0, 0)
    @objective(model, Min, sum(x[p, 1, u.ind] for p in 1:n_parcelles for u in arcs_sortants(sommet_init, Arcs)))

    # Contraintes:
    # Respect de la demande
    @constraint(model, [t in 1:T, c in C], sum(x[p, t, u.ind]*u.r for u in Arcs for p in 1:n_parcelles) >= Demande[c, t])
    # Initialisation du flux dans les parcelles
    @constraint(model, [p in 1:n_parcelles], sum( x[p, 1, u.ind] for u in arcs_sortants(sommet_init, Arcs) ) <= 1)
    # Conservation du flux dans les parcelles
    @constraint(model, [p in 1:n_parcelles, t in 2:T-1, sommet in Sommets], sum(x[p, t, u.ind] for u in arcs_entrants(sommet, Arcs)) == sum(x[p, t, u.ind] for u in arcs_sortants(sommet, Arcs)))
    # Impossibilité d'aller d'un sommet à un autre si paire à paire ou impaire à impaire
    @constraint(model, [p in 1:n_parcelles, t in 1:T, u in Arcs ; u.j.j==C[1+t%2] ], x[p, t, u.ind] == 0)

    optimize!(model)
    x_val = JuMP.value.(x)
    obj = JuMP.objective_value(model)

    return x_val, obj
end

function egalite_sommet(sommetA, sommetB)
    return (sommetA.l == sommetB.l && sommetA.a == sommetB.a && sommetA.j == sommetB.j)
end

function arcs_entrants(sommet::Sommet, arcs::Array{Arc, 1})
    return [arc for arc in arcs if egalite_sommet(sommet, arc.j)]
end

function arcs_sortants(sommet::Sommet, arcs::Array{Arc, 1})
    return [arc for arc in arcs if egalite_sommet(sommet, arc.i)]
end


function main()
    filename = "modify.dat"
    NbParcelles, T, SURF, lmax, amax, C, Demande, sommets, arcs = read_instance(filename)

    start = time()
    x, obj = planification_culturale(NbParcelles, T, SURF, lmax, amax, C, Demande, sommets, arcs)
    stop = time()
    taken_time = stop - start
    fp = open("./result.csv", "w")
    println(fp, "solution = ", x)
    println(fp, "objectif = ", obj )
    println(fp, "taken_time = ", taken_time)
    close(fp)
end

main()