include("linear_prob.jl")

function generate_instance(n::Int, m::Int, Cmin::Int, Cmax::Int)
    C = zeros(Int,n,m)
    for i in 1:n 
        for j in 1:m 
            C[i,j] = mod(rand(Int),Cmax-Cmin)+Cmin
        end
    end
    area = n*m 
    tot = sum(C)
    B = floor(Int, 0.4*tot*(rand()+1))
    A_min = floor(Int, area*(0.6*rand()+0.2))
    A_max = mod(rand(Int), area-A_min)+A_min

    return C, A_min, A_max, B
end

function dinkelbach(C::Array{Int, 2}, d::Array{Float64, 4}, A_min::Int, A_max::Int, B::Int, time_limit::Int)
    start = time()
    lambda = 1
    num = 10
    den = 1
    x = 0

    i = 0

    eps = 0.00001
    while (abs(-num - lambda*den)> eps) && (time() - start < time_limit)
        i = i + 1
        lambda = -num/den
        num, den, x, obj = linear_prob(C, d, A_min, A_max, B, lambda)
        if obj == -1
            return -1, -1, -1
        end
    end

    if time() - start >= time_limit 
        return -1, -1, -2
    end
    println("num = ",num," , den = ",den)
    ddpmv = num/den
    return x, ddpmv, i

end

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



function main()

    C = [
    7 3 10 10 2 8 6 4 5 5;
    7 7 10 5 2 8 6 3 9 9;
    7 3 4 6 3 2 4 9 7 8;
    6 2 7 6 4 7 5 10 7 8;
    2 4 3 4 9 6 4 9 8 4;
    7 5 2 9 8 9 5 6 10 10;
    5 2 3 7 9 9 4 9 6 3;
    5 2 9 4 2 8 6 9 3 4;
    9 6 5 4 5 6 8 9 6 6;
    8 8 7 7 3 5 8 3 9 9
    ]
    C = 10*C
    
    display(C)
    println(" ")

    n = size(C,1)
    d = [sqrt((i-k)*(i-k)+(j-l)*(j-l)) for i in 1:n, j in 1:n, k in 1:n, l in 1:n]

    display(d[1,1,:,:])
    println(" ")


    for file in readdir("instances/")
        include("instances/"*file)
        println("Processing instace : ", file)
        start = time()
        x, ddpmv, nb_it = dinkelbach(C, d, A_min, A_max, B, 60)
        stop = time()
        println("Time : ", stop-start)
        println("Nb_it : ", nb_it)
        println("DDPMV : ", ddpmv)
        print_grid(x)
        println(" ")
    end
end

function study_influence_of_n()
    nb_cases = 7
    n = [2+2*i for i in 1:nb_cases]

    nb_iter = 10

    time_limit = 30

    time_vec = zeros(Float64, nb_cases)
    it_vec = zeros(Float64, nb_cases)
    ddpmv_vec = zeros(Float64, nb_cases)

    had_enough_time = zeros(Int, nb_cases)


    for i in 1:nb_cases
        println("Computing case n = ",n[i])
        d = [sqrt((i-k)*(i-k)+(j-l)*(j-l)) for i in 1:n[i], j in 1:n[i], k in 1:n[i], l in 1:n[i]]
        j = 0
        not_enough_time = 0 
        while j<nb_iter
            
            C, A_min, A_max, B = generate_instance(n[i], n[i], 40, 90)
            start = time()
            x, ddpmv, nb_it = dinkelbach(C, d, A_min, A_max, B, time_limit)
            stop = time()

            if nb_it > 0
                time_vec[i] += stop-start
                it_vec[i] += nb_it
                ddpmv_vec[i] += ddpmv
                j+=1
            end

            if nb_it == -2
                time_vec[i] += time_limit
                j += 1
                not_enough_time += 1 
            end

        end

        time_vec[i] = round(time_vec[i]/nb_iter, digits = 5)
        had_enough_time[i] = nb_iter - not_enough_time
        if nb_iter - not_enough_time > 0
            it_vec[i] = round(it_vec[i]/(nb_iter-not_enough_time), digits = 5)
            ddpmv_vec[i] = round(ddpmv_vec[i]/(nb_iter-not_enough_time), digits = 5)
        end
        
    end

    fp = open("res/influence_of_n.res", "w")
    println(fp, time_vec)
    println(fp, it_vec)
    println(fp, ddpmv_vec)
    println(fp, had_enough_time)
    close(fp)
end

#main()
study_influence_of_n()