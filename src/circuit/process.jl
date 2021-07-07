function bin(x::Integer,pad::Int,id::Int)
    return (x>>(pad-id))&1
end

function bin(x::Integer,pad::Int,ids::Vector{Int})
    ret = 0
    subid = 1;subpad = length(ids)
    for id in ids
        ret+=(bin(x,pad,id)<<(subpad-subid))
        subid+=1
    end
    return ret
end

function flip(x::Integer,pad::Int,id::Int)
    return x$(1<<(pad-id))
end

function flip(x::Integer,pad::Int,ids::Vector{Int},assign::Int)
    ret = x
    n = length(ids)
    for id = 1:n
        if bin(assign,n,id)==1
            ret = flip(ret,pad,id)
        end
    end
    return ret
end

function set(x::Integer,pad::Int,ids::Vector{Int},assign::Integer)
    ret = x
    n = length(ids)
    for i = 1:n
        if bin(assign,n,i) != bin(x,n,ids[i])
            ret = flip(ret,pad,ids[i])
        end
    end
    return ret
end

function process{N}(unit::AbstractGateUnit{N},input::AbstractSparseArray)
    len = length(unit.pos)-1
    eigens = unit.gate()
    ret = spzeros(Complex,size(input)...)
    for i in rowvals(input)
        subidx = bin(i-1,len,unit.pos[2:end])
        rett = spzeros(Complex,size(input)...)
        for j = 0:(2^len-1)
            idx = set(i-1,N,unit.pos[2:end],j)
            rett[idx+1] = input[i]*eigens[subidx+1][j+1]
        end
        ret += rett
    end
    return ret
end

#################################
# Stablizer circuits processing
#################################

# the Stablizer circuit implemented algorithms in http://www.scottaaronson.com/chp/

# TODO
# function process{N}(unit::CtrlGateUnit{N},input::AbstractSparseArray)
# end

function process(unit::HadamardUnit,input::AbstractSparseArray)
  unit.pos
end

# TODO
# function process(unit::CNOTUnit,input::AbstractSparseArray)
# end

# TODO
# function process(unit::PhaseUnit,input::AbstractSparseArray)
# end

function process{N}(circuit::Circuit{N},input::AbstractSparseArray)
    ret = deepcopy(input)
    for unit in circuit.gates
        if N==bitnum(unit)
            ret = unit.gate(ret)
        else
            ret = process(unit,ret)
        end
    end
    return ret
end

export process
