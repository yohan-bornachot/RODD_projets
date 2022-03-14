using JuMP
using CPLEX

include("read_prob.jl")
include("modelisation.jl")
include("generate_instance.jl")

function main()

    DATA_PATH = "data/"

    K = 6
    K_rares = 3
    h = 10
    w = 10
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

function study_influence_of_n()
    nb_cases = 10
    n = [5+5*i for i in 0:(nb_cases-1)]
    
    nb_iter = 10

    K = 6
    K_rares = 3
    alpha = [0.7 for i in 1:K]

    time_vec = zeros(Float64, nb_cases)
    obj_vec = zeros(Float64, nb_cases)
    feasible_instance = zeros(Float64, nb_cases)

    for i in 1:nb_cases
        println("Processing n = ",n[i])
        j = 0
        cmpt = 0
        while j < nb_iter
            cmpt += 1
            C, p = generate_instance(K, n[i], n[i], 0.8, 3, 6)

            start = time()
            x, y, obj, proba_survie = protect_species_cstrOnSurvival(p, K_rares, C, alpha)
            stop = time()

            if obj >  0 
                time_vec[i] += stop - start
                obj_vec[i] += obj
                j += 1
            end
        end
        time_vec[i] = round(time_vec[i]/nb_iter, digits = 5)
        obj_vec[i] = round(obj_vec[i]/nb_iter, digits = 5)
        feasible_instance[i] = nb_iter/cmpt
    end

    fp = open("data/answers/influence_of_nb_species.res", "w")
    println(fp, n)
    println(fp, time_vec)
    println(fp, obj_vec)
    println(fp, feasible_instance)
    close(fp)

end

function study_influence_of_K()
    nb_cases = 10
    n = 10
    
    nb_iter = 10

    K = [2+4*i for i in 0:nb_cases-1]

    time_vec = zeros(Float64, nb_cases)
    obj_vec = zeros(Float64, nb_cases)
    feasible_instance = zeros(Float64, nb_cases)

    for i in 1:nb_cases
        println("Processing K= ",K[i])
        j = 0
        cmpt = 0
        while j < nb_iter
            cmpt += 1
            C, p = generate_instance(K[i], n, n, 0.8, 3, 6)

            alpha = [0.7 for i in 1:K[i]]

            K_rares = floor(Int,K[i]/2)

            start = time()
            x, y, obj, proba_survie = protect_species_cstrOnSurvival(p, K_rares, C, alpha)
            stop = time()

            if obj >  0 
                time_vec[i] += stop - start
                obj_vec[i] += obj
                j += 1
            end
        end
        time_vec[i] = round(time_vec[i]/nb_iter, digits = 5)
        obj_vec[i] = round(obj_vec[i]/nb_iter, digits = 5)
        feasible_instance[i] = nb_iter/cmpt
    end

    fp = open("data/answers/influence_of_nb_species.res", "w")
    println(fp, K)
    println(fp, time_vec)
    println(fp, obj_vec)
    println(fp, feasible_instance)
    close(fp)

end

#main()
#study_influence_of_n()
study_influence_of_K()
