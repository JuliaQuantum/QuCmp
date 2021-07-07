function realtimeop!(Hs::AdiaComputer)
    Hs.state = trotter(-im*(1-Hs.location)*Hs.HB,-im*Hs.location*Hs.HP,3)*Hs.state
    Hs.location += Hs.dt/Hs.maxtime
end

function next_timestep!(Hs::AdiaComputer;evopercentage::Real=1/3,nev=6)
    @assert (0<=Hs.location+evopercentage)&&( Hs.location+evopercentage-1<0.1) "evolutoin percentage out of bounds(should be in [0,1])"

    const evotime = Hs.maxtime
    const dt      = Hs.dt

    # calculate eigen values
    for i=Hs.location*evotime:dt:(Hs.location+evopercentage)*evotime
        realtimeop!(Hs)
        Hs.eigens = [Hs.eigens;eigs(Hamiltonian(Hs),nev=nev,which=:SM)[1].']
    end

    return Hs
end

export next_timestep!
