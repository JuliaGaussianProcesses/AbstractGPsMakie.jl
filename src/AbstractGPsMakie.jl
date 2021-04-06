module AbstractGPsMakie

using AbstractGPs
using LinearAlgebra
using AbstractPlotting

using AbstractGPs: AbstractGP, FiniteGP

export gpsample, gpsample!

include(joinpath("recipes", "symband.jl"))
include(joinpath("recipes", "gpsample.jl"))

include("conversions.jl")

# default plot type
AbstractPlotting.plottype(::AbstractVector, ::FiniteGP) = SymBand
AbstractPlotting.plottype(::FiniteGP) = SymBand
AbstractPlotting.plottype(::AbstractVector, ::AbstractGP) = SymBand

end
