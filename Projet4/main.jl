include("pl.jl")

function print_grid(x::Array{Float64, 2})
    n = size(x,1)
    m = size(x,2)
    for i in 1:n
        for j in 1:m
            if x[i,j]>0.5
                print("x ")
            else
                print(". ")
            end
        end
        println(" ")
    end
end

function create_instance(n::Int, m::Int, t_min::Int, t_max::Int)
    t = zeros(Int,n,m)
    for i in 1:n
        for j in 1:m 
            t[i,j] = mod(rand(Int),t_max-t_min)+t_min
        end
    end
    return t
end

function main()
    # Inclure t
    include("ExplForet_jl.dat")
    println("Méthode mixte.")
    start = time()
    x,obj = methode_mixte(t,w1,w2,l,g)
    stop = time()
    println("Time : ",stop-start,", obj : ",obj)
    print_grid(x)

    println("Méthode quadratique avec linéarisation.")
    start = time()
    x, obj = methode_quadratique(t,w1,w2,l,g)
    stop = time()
    println("Time : ",stop-start,", obj : ",obj)
    print_grid(x)

end

function evaluate_influence_of_n()
    nb_cases = 10
    n = [10+5*i for i in 0:nb_cases-1]

    nb_iter = 10
    
    w1 = 1.
    w2 = 1.

    l = 4.
    g = 5.

    vec_time_m1 = zeros(Float64, nb_cases)
    vec_time_m2 = zeros(Float64, nb_cases)
    vec_obj_m1 = zeros(Float64, nb_cases)
    vec_obj_m2 = zeros(Float64, nb_cases)

    for i in 1:nb_cases
        println("Processing n = ", n[i])
        for _ in 1:nb_iter
            t = create_instance(n[i],n[i],60,90)
            start = time()
            _,obj = methode_mixte(t,w1,w2,l,g)
            stop = time()

            vec_time_m1[i] += stop - start 
            vec_obj_m1[i] += obj

            start = time()
            _,obj = methode_quadratique(t,w1,w2,l,g)
            stop = time()

            vec_time_m2[i] += stop - start 
            vec_obj_m2[i] += obj
        end

        vec_obj_m1[i] = round(vec_obj_m1[i]/nb_iter, digits = 4)
        vec_obj_m2[i] = round(vec_obj_m2[i]/nb_iter, digits = 4)
        vec_time_m1[i] = round(vec_time_m1[i]/nb_iter, digits = 4)
        vec_time_m2[i] = round(vec_time_m2[i]/nb_iter, digits = 4)
    end

    fp = open("res/influence_of_n.res", "w")

    println(fp, n)
    println(fp, vec_time_m1)
    println(fp, vec_obj_m1)
    println(fp, vec_time_m2)
    println(fp, vec_obj_m2)
    close(fp)

end

main()
#evaluate_influence_of_n()
