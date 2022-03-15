using JuMP
using CPLEX

include("read_instance.jl")

function create_instance(G::Int, A::Int, N::Int)
    nb_alleles_per_indiv = zeros(Int,G*A,N)
    for indiv in 1:N
        for gene in 1:G 
            gene1 = mod(rand(Int),A)+1
            gene2 = mod(rand(Int),A)+1
            nb_alleles_per_indiv[(gene-1)*A+gene1,indiv] += 1
            nb_alleles_per_indiv[(gene-1)*A+gene2,indiv] += 1
        end
    end
    return nb_alleles_per_indiv
end

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
    @constraint(m, [theta in thetas, i in 1:p], log(theta)+(1/theta)*(y[i]-theta)  >= -log(2)*sum(N[j] for j in 1:n if nb_alleles_per_indiv[i,j]==1))
    #@constraint(m, [j in 1:n], N[j]<=3)
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

function study_influence_of_N()
    nb_cases = 8
    nb_iter = 10

    N = [6*i for i in 1:nb_cases]
    println(N)
    G = 20
    A = 2
    
    T = 50
    init = 0.001
    thetas = [init^((T-r)/(T-1)) for r in 1:T]

    t_vec = zeros(Float64, nb_cases)
    obj_vec = zeros(Float64, nb_cases)

    
    for i in 1:nb_cases
        println("Processing N = ",N[i])
        Nm = floor(Int,N[i]/2)
        for j in 1:nb_iter
            nb_alleles_per_indiv = create_instance(G, A, floor(Int,N[i]))
            start = time()
            _, obj = save_diversity(nb_alleles_per_indiv, Nm, thetas)
            stop = time()
            t = stop - start
            t_vec[i] += t
            obj_vec[i] += obj
        end
        t_vec[i] = round(t_vec[i]/nb_iter, digits = 3)
        obj_vec[i] = round(obj_vec[i]/nb_iter, digits = 5)
    end

    fp = open("res/study_influence_of_N.res", "w")
    println(fp, N)
    println(fp, t_vec)
    println(fp, obj_vec)
    close(fp)
end

function study_influence_of_G()
    nb_cases = 20
    nb_iter = 10

    N = 10
    Nm = 5
    G = [10+5*i for i in 1:nb_cases]
    A = 2
    
    T = 50
    init = 0.001
    thetas = [init^((T-r)/(T-1)) for r in 1:T]

    t_vec = zeros(Float64, nb_cases)
    obj_vec = zeros(Float64, nb_cases)

    
    for i in 1:nb_cases
        println("Processing G = ",G[i])
        for j in 1:nb_iter
            nb_alleles_per_indiv = create_instance(G[i], A, N)
            start = time()
            _, obj = save_diversity(nb_alleles_per_indiv, Nm, thetas)
            stop = time()
            t = stop - start
            t_vec[i] += t
            obj_vec[i] += obj
        end
        t_vec[i] = round(t_vec[i]/nb_iter, digits = 3)
        obj_vec[i] = round(obj_vec[i]/nb_iter, digits = 5)
    end

    fp = open("res/study_influence_of_G.res", "w")
    println(fp, G)
    println(fp, t_vec)
    println(fp, obj_vec)
    close(fp)
end

function study_influence_of_A()
    nb_cases = 8
    nb_iter = 10

    N = 8
    Nm = 4
    G = 10
    A = [1+i for i in 1:nb_cases]
    
    T = 50
    init = 0.001
    thetas = [init^((T-r)/(T-1)) for r in 1:T]

    t_vec = zeros(Float64, nb_cases)
    obj_vec = zeros(Float64, nb_cases)

    
    for i in 1:nb_cases
        println("Processing A = ",A[i])
        for j in 1:nb_iter
            nb_alleles_per_indiv = create_instance(G, A[i], N)
            start = time()
            _, obj = save_diversity(nb_alleles_per_indiv, Nm, thetas)
            stop = time()
            t = stop - start
            t_vec[i] += t
            obj_vec[i] += obj
        end
        t_vec[i] = round(t_vec[i]/nb_iter, digits = 3)
        obj_vec[i] = round(obj_vec[i]/nb_iter, digits = 5)
    end

    fp = open("res/study_influence_of_A.res", "w")
    println(fp, A)
    println(fp, t_vec)
    println(fp, obj_vec)
    close(fp)
end

function study_influence_of_theta()
    nb_cases = 6
    nb_iter = 10

    N = 8
    Nm = 4
    G = 10
    A = 4
    
    T = [10+20*i for i in 0:(nb_cases-1)]
    init = 0.001

    t_vec = zeros(Float64, nb_cases)
    obj_vec = zeros(Float64, nb_cases)

    
    for i in 1:nb_iter
        println("Iter : ",i, " sur ",nb_iter)
        nb_alleles_per_indiv = create_instance(G, A, N)
        
        for j in 1:nb_cases
            thetas = [init^((T[j]-r)/(T[j]-1)) for r in 1:T[j]]    
            start = time()
            _, obj = save_diversity(nb_alleles_per_indiv, Nm, thetas)
            stop = time()
            t = stop - start
            t_vec[j] += t
            obj_vec[j] += obj
        end
        
    end

    for j in 1:nb_cases
        t_vec[j] = round(t_vec[j]/nb_iter, digits = 3)
        obj_vec[j] = round(obj_vec[j]/nb_iter, digits = 5)
    end

    fp = open("res/study_influence_of_theta.res", "w")
    println(fp, T)
    println(fp, t_vec)
    println(fp, obj_vec)
    close(fp)
end


#main()
#study_influence_of_N()
#study_influence_of_G()
#study_influence_of_A()
study_influence_of_theta()