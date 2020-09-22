function cooler!(Hs::AdiaComputer,gamma::Real,t::Real)
    # boundscheck(Hs,gamma,t)
    energy = eig(full(Hamiltonian(Hs)))[1]
    @assert -pi/2<minimum(energy)*t-gamma<pi/2 "bad cooling parameters"
    @assert -pi/2<maximum(energy)*t-gamma<pi/2 "bad cooling parameters"

    Hs.state = normalize!((Hs.state-im*exp(im*gamma)*
            trotter(-im*t*(1-Hs.location)*Hs.HB,
                -im*t*Hs.location*Hs.HP,3)*Hs.state)/2)
end

function heater!(Hs::AdiaComputer,gamma::Real,t::Real)
    # boundscheck(Hs,gamma,t)
    energy = eig(full(Hamiltonian(Hs)))[1]
    @assert -pi/2<minimum(energy)*t-gamma<pi/2 "bad cooling parameters"
    @assert -pi/2<maximum(energy)*t-gamma<pi/2 "bad cooling parameters"

    Hs.state = normalize!((Hs.state+im*exp(im*gamma)*
                trotter(-im*t*(1-Hs.location)*Hs.HB,
                    -im*t*Hs.location*Hs.HP,3)*Hs.state)/2)
end

function daemon!(
    Hs::AdiaComputer,
    gamma::Real,
    t::Real
    )
    dice = rand()
    if dice <= 0.5*(1+sin(gamma))
        #get |1> (higher energy)
        heater!(Hs,gamma,t)
        return 0.5*(1-sin(gamma))
    else
        #get |0> (lower energy)
        cooler!(Hs,gamma,t)
        return 0.5*(1+sin(gamma))
    end
end

function cooling!(
    Hs::AdiaComputer;
    n=5)

    count = 0
    gamma,t = CoolingPara(Hs)

    while count<n
        Hs.prob *= daemon!(Hs,gamma,t)
        count += 1
    end
    return Hs
end

function CoolingPara(Hs::AdiaComputer)
    Eigen = eig(full(Hamiltonian(Hs)))[1]
    maxEigen = maximum(Eigen)
    minEigen = minimum(Eigen)

    gamma = (maxEigen+minEigen)/(maxEigen-minEigen) * pi/2 * 0.1

    if (gamma-pi/2)>0
        t = 0.5*((gamma-pi/2)/minEigen + (gamma+pi/2)/maxEigen)
    else
        t = 0.5*((gamma-pi/2)/maxEigen + (gamma+pi/2)/maxEigen)
    end
    return gamma,t
end

export cooling!
