include("linear_prob.jl")

include("MinFragmentation_julia.dat")
C = 10*C

function dinkelbach(C::Array{Int, 2}, d::Array{Float64, 4}, A_min::Int, A_max::Int, B::Int)
    lambda = 1
    num = 10
    den = 1
    x = 0

    i = 0

    eps = 0.00001
    while (abs(-num - lambda*den)> eps)
        i = i + 1
        lambda = -num/den
        num, den, x, obj = linear_prob(C, d, A_min, A_max, B, lambda)

    end

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
        x, ddpmv, nb_it = dinkelbach(C, d, A_min, A_max, B)
        stop = time()
        println("Time : ", stop-start)
        println("Nb_it : ", nb_it)
        println("DDPMV : ", ddpmv)
        print_grid(x)
        println(" ")
    end
end


main()