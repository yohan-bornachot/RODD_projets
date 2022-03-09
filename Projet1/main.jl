using JuMP
using CPLEX

DATA_PATH = "data/"
include("read_prob.jl")
include("modelisation.jl")

K = 6
K_rares = 3
h = 10
w = 10

function main()
    p = read_prob(DATA_PATH*"RODD-probabilites.txt", w, h, K)
    include(DATA_PATH*"cost.gr")

    for file in readdir(DATA_PATH*"/alpha/")
        include(DATA_PATH*"/alpha/"*file)
        println("Instance courante : ",file)

        # Resolution
        start = time()
        x, y, obj, proba_survie = protect_species_cstrOnSurvival(p, K_rares, C, alpha)
        stop = time()

        # Affichage des donnees
        fp = open(DATA_PATH*"answers/"*file, "w")
        println(fp, "Temps de resolution :")
        println(fp, stop-start)
        println(fp, "Valeur de l'objectif : ")
        println(fp, obj)
        println(fp, "Taux de survie des especes : ")
        println(fp, proba_survie)
        println(fp, "Tableau des zones protegees :")
        println(fp, x+y)
        println("\n")

        close(fp)
    end

end 


main()