
mutable struct Sommet
    l::Int # age de la jachere
    a::Int # age de la culture
    j::Int # culture ou jachere en cours
end

mutable struct Arc
    i::Sommet # initial
    j::Sommet # final
    r::Int # rendement
end

function read_instance(name::String)
    include(name)
    n_sommets = size(Sommets,1)
    n_arcs = size(Arcs,1)

    sommets = Vector{Sommet}(undef,n_sommets)
    arcs = Vector{Arc}(undef,n_arcs)
    for i in 1:n_sommets
        sommets[i] = Sommet(Sommets[i,1],Sommets[i,2],Sommets[i,3])
    end
    for i in 1:n_arcs
        arcs[i] = Arc(Sommet(Arcs[i,1],Arcs[i,2],Arcs[i,3]), Sommet(Arcs[i,4],Arcs[i,5],Arcs[i,6]), Arcs[i,7])
    end

    return NbParcelles, T, SURF, lmax, amax, C, Demande, sommets, arcs
end