function read_instance(filename::String)
    if isfile(filename)

        include(filename)
        nb_alleles_per_indiv = zeros(Int,G*A,N)
        for i in 1:size(individus,1)
            nb_alleles_per_indiv[2*(individus[i,3]-1)+individus[i,5], individus[i,1]] += 1
        end
        return nb_alleles_per_indiv,N,Nm,C,G,A,T,init
    end
end        