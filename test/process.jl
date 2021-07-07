using QuCmp

cc = Circuit(2)

addgate!(cc,X,1,1)

t = process(cc,sparsevec([1,0,0,0]))
@show t
@show full(t)
