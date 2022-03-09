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

main()