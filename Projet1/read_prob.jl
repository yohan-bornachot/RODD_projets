function read_prob(filename :: String, w :: Int, h :: Int, K :: Int)
    prob = zeros(Float32, K, w, h)
    if isfile("./data/test.txt")
        # L’ouvrir
        myFile = open("./data/test.txt")
        data = readlines(myFile) #Retourne un tableau de String
        for line in data
            elem_lines = split(line," ")
            if size(elem_lines,1) == 4
                k = convert(Int, elem_lines[1])
                i = convert(Int, elem_lines[2])
                j = convert(Int, elem_lines[3])
                p = convert(Float32, elem_lines[4])
                prob[k,i,j] = p
        end
        # Fermer le fichier
        close(myFile)
    end
    return prob
end