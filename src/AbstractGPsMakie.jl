module AbstractGPsMakie

using AbstractGPs
using LinearAlgebra
using Makie

using AbstractGPs: AbstractGP, FiniteGP

export gpsample, gpsample!

include(joinpath("recipes", "symband.jl"))
include(joinpath("recipes", "gpsample.jl"))

include("conversions.jl")

# default plot type
Makie.plottype(::AbstractVector, ::FiniteGP) = SymBand
Makie.plottype(::FiniteGP) = SymBand
Makie.plottype(::AbstractVector, ::AbstractGP) = SymBand

end
