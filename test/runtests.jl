using AbstractGPsMakie
using AbstractGPs
using AbstractPlotting
using Random
using Test

Random.seed!(1234)

@testset "AbstractGPsMakie.jl" begin
    include("conversions.jl")
end
