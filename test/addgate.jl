using QuCmp

cc = Circuit(3)

addgate!(cc,X,2,3)
addgate!(cc,X,1,2)

@show cc
