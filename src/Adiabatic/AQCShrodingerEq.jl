import QuDynamics: QuStateEvolution,operator,propagate

function eigenvector(index::Integer,n::Integer)
    res = 1
    for i in bin(index,n)
        if i=='0'
            res = kron(res,1/sqrt(2)*[1,1])
        elseif i=='1'
            res = kron(res,1/sqrt(2)*[1,-1])
        end
    end
    return res
end

immutable AQCShrodingerEq{H<:QuBase.AbstractQuMatrix} <: QuEquation{1}
    HB::H
    HP::H
    T::Real

    function AQCShrodingerEq(HP::H,maxtime::Real=1)
        n = size(HP)[1]|>log2|>Int
        HB = n|>bHamilton

        # Similar Matrix
        P = eigenvector(0,n)
        for i=1:2^n-1
            P = [P eigenvector(i,n)]
        end
        invP = inv(P)

        HB = QuArray(P*HB*invP,(ComputBasis(n),ComputBasis(n)))

        # @show HP
        # @show size(HP)
        new(HB,HP,maxtime)
    end
end

AQCShrodingerEq{H<:QuBase.AbstractQuMatrix}(HP::H,maxtime::Real=1) = AQCShrodingerEq{H}(HP,maxtime)

QuStateEvolution{QPM<:QuDynamics.QuPropagatorMethod, QV<:QuBase.AbstractQuVector}(eq::AQCShrodingerEq, init_state::QV, tlist, method::QPM) = QuStateEvolution{QPM,QV,AQCShrodingerEq}(eq, init_state, tlist, method)

function operator(eq::AQCShrodingerEq,current_t::Real)
    return (1-current_t/eq.T)*eq.HB+current_t/eq.T*eq.HP
end

# For ODE solvers

for (qu_ode_type,ode_solver) in QuDynamics.type_to_method_ode
    @eval begin
        function propagate(prob::$qu_ode_type, eq::AQCShrodingerEq, t, current_t, current_qustate)
            op = operator(eq,current_t)
            dims = size(current_qustate)
            # Convert the current_qustate to complex as it might result in a Inexact Error. After complex is in QuBase.jl (PR #38)
            # we could just do a complex(vec(current_qustate)) avoiding the coeffs(coeffs(vec(current_qustate))).
            next_state = $ode_solver((t,y)-> -im*coeffs(op)*y, complex(coeffs(vec(current_qustate))), [current_t, t], points=:specified,
                                  reltol = get(prob.options, :reltol, 1.0e-5), abstol = get(prob.options, :abstol, 1.0e-8))[2][end]
            CQST = QuBase.similar_type(current_qustate)
            return CQST(reshape(next_state, dims), bases(current_qustate))
        end
    end
end

# For Expm solvers

function propagate(prob::QuExpokit, eq::AQCShrodingerEq, t, current_t, current_qustate)
    dt = t - current_t
    dims = size(current_qustate)
    next_state = Expokit.expmv(dt, -im*coeffs(operator(eq,current_t)), coeffs(vec(current_qustate)), m = get(prob.options, :m, 30), tol = get(prob.options, :tol, 1e-7))
    CQST = QuBase.similar_type(current_qustate)
    return CQST(reshape(next_state, dims), bases(current_qustate))
end

function propagate(prob::QuExpmV, eq::AQCShrodingerEq, t, current_t, current_qustate)
    dt = t - current_t
    dims = size(current_qustate)
    # @show coeffs(operator(eq,current_t))
    next_state = ExpmV.expmv(im*dt, -coeffs(operator(eq,current_t)), coeffs(vec(current_qustate)), M = get(prob.options, :M, []), prec = get(prob.options, :prec, "double"),
                            shift = get(prob.options, :shift, false), full_term = get(prob.options, :full_term, false))
    CQST = QuBase.similar_type(current_qustate)
    return CQST(reshape(next_state, dims), bases(current_qustate))
end
