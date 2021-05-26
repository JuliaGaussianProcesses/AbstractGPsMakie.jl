using AbstractGPsMakie
using AbstractGPs
using Makie
using Random
using Test

Random.seed!(1234)

@testset "AbstractGPsMakie.jl" begin
    include("conversions.jl")
end
