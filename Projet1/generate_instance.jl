function generate_instance(nb_species::Int, n::Int, m::Int, p::Float64, min_cost::Int, max_cost::Int)

    cost = zeros(Int, n, m)
    for i in 1:n
        for j in 1:m
            cost[i,j] = mod(rand(Int),max_cost-min_cost) + min_cost
        end
    end

    proba_survie = rand(nb_species, n, m)

    for k in 1:nb_species
        for i in 1:n 
            for j in 1:m
                if proba_survie[k,i,j]>p
                    proba_survie[k,i,j] = rand()
                else
                    proba_survie[k,i,j] = 0
                end
            end
        end
    end

    return cost, proba_survie
    

end