import sys

def modify_instance(name):
    with open(name, "r") as f:
        data = f.readlines()
        copy_data = data.copy()

        for i,line in enumerate(data):
            for j,c in enumerate(line):
                if c == "<":
                    copy_data[i]= copy_data[i][:j]+' '+copy_data[i][j+1:]
                if c == ">":
                    copy_data[i]= copy_data[i][:j]+' '+copy_data[i][j+1:]
                if c == ",":
                    copy_data[i]= copy_data[i][:j]+' '+copy_data[i][j+1:]
                
    
    with open("modify.dat", "w") as out :
        out.writelines(copy_data)


if __name__ == "__main__":
    modify_instance(sys.argv[1])