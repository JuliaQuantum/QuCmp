using QuCmp
using QuBase

n = 5

ins,ans = generate(n)
pH = QuArray(pHamilton(ins,n),(ComputBasis(n),ComputBasis(n)))

@show typeof(pH)<: QuBase.AbstractQuArray

aqc = AQC(pH,n;maxtime=100)

state = QuArray(convert(Array{Complex128,1},[1/sqrt(2^n) for i=1:2^n]),ComputBasis(n))

@time for (t,psi) in aqc
    state = psi
end


print("p: $(norm(aqc.state[ans[1]+1])^2)\n")
