function bind_sherlock_procs()

    home = ENV["HOME"]

     # find out what cluster we are on
    node_file_name = ENV["PE_HOSTFILE"]

    # read PBS_NODEFILE
    filestream = open(node_file_name)
    seekstart(filestream)
    node_file = readlines(filestream)

    # get number of workers on each node
    procs = Dict{ASCIIString,Int}()
    for line in node_file
        line_parts = split(line," ")
        procs[line_parts[1]] = int(line_parts[2])
    end

    println("names of compute nodes and number of workers:")
    println(procs)

    # add processes on master itself
    master = ENV["HOSTNAME"]

    if procs[master] > 1
        addprocs(procs[master]-1)
        println("added $(procs[master]-1) processes on master itself")
    end

    # # get a machine file for other hosts
    # machines = ASCIIString[]
    # for i in 1:length(node_file)
    #     if node_file[i] != master
    #         push!(machines,node_file[i])
    #     end
    # end

    # add procs on other machines
    for (k,v) in procs
        wrker = 0
        if k!=master
            while wrker < v
                addprocs([k], dir= JULIA_HOME)
                # println("addprocs($k)")
                wrker += 1
            end
            println("added $wrker processes on machine $k")
        end
    end

    println("done")
end

function bind_sherlock_procs(ppn::Int)

    # add only ppn processes per node

    home = ENV["HOME"]

    node_file_name = ENV["PE_HOSTFILE"]

    # read PBS_NODEFILE
    filestream = open(node_file_name)
    seekstart(filestream)
    node_file = readlines(filestream)

    # strip eol
    node_file = map(x->strip(x,['\n']),node_file)

    # get number of workers on each node
    procs = Dict{ASCIIString,Int}()
    for n in node_file
        procs[n] = get(procs,n,0) + 1
    end

    println("name of compute nodes and number of workers:")
    println(procs)

    # add processes on master itself
    master = ENV["HOSTNAME"]

    wrker = 0
    while wrker < ppn
        addprocs(1)
        wrker += 1
    end
    println("added $wrker processes on master itself")

    # add procs on other machines
    for (k,v) in procs
        wrker = 0
        if k!=master
            while wrker < ppn
                addprocs([k], dir= JULIA_HOME)
                # println("addprocs($k)")
                wrker += 1
            end
            println("added $wrker processes on machine $k")
        end
    end

    println("done")
end

