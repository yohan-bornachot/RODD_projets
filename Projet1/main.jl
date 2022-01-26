using JuMP
using CPLEX

DATA_PATH = "data/"
include(read_prob)

function main()
    prob = read_prob(DATA_PATH*"RODD-probabilities.txt")
    println(prob)
    include(DATA_PATH*"cost.gr")

    for file in readdir(DATA_PATH*"/alpha/")
        include(DATA_PATH*"/alpha/"*file)

        

end 


main()