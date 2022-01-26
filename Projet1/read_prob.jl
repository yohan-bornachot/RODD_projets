function read_prob(filename :: String, w :: Int, h :: Int, K :: Int)
    prob = zeros(Float32, K, w, h)
    if isfile(filename)
        # L’ouvrir
        myFile = open(filename)
        data = readlines(myFile) #Retourne un tableau de String
        for line in data
            elem_lines = split(line," ")
            if size(elem_lines,1) == 4
                k = parse(Int, elem_lines[1])
                i = parse(Int, elem_lines[2])
                j = parse(Int, elem_lines[3])
                p = parse(Float32, elem_lines[4])
                prob[k,i,j] = p
            end
        end
        # Fermer le fichier
        close(myFile)
    end
    return prob
end