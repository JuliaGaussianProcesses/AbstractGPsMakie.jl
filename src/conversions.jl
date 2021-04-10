# `SymBand` for `FiniteGP`
function AbstractPlotting.convert_arguments(
    ::Type{P}, x::AbstractVector, gp::FiniteGP
) where {P<:SymBand}
    y, var = mean_and_var(gp)
    Δy = sqrt.(var)
    return convert_arguments(P, x, y, Δy)
end

# `GPSample` for `FiniteGP`
function AbstractPlotting.convert_arguments(
    ::Type{<:GPSample}, x::AbstractVector, gp::FiniteGP
)
    return (x, gp)
end

# Default fallback: plot mean of GP
function AbstractPlotting.convert_arguments(
    P::AbstractPlotting.PlotFunc, x::AbstractVector, gp::FiniteGP
)
    return convert_arguments(P, x, mean(gp))
end

# Fallback for `band`/`band!`: plot band of 3 SD around mean of GP
# attributes not available, therefore no scaling possible :(
# https://github.com/JuliaPlots/Makie.jl/issues/837
function AbstractPlotting.convert_arguments(
    ::Type{P}, x::AbstractVector, gp::FiniteGP
) where {P<:Band}
    y, var = mean_and_var(gp)
    scale = 3
    return (Point2f0.(x, y .- scale .* sqrt.(var)), Point2f0.(x, y .+ scale .* sqrt.(var)))
end

# default conversions for `FiniteGP` and `AbstractGP`
function AbstractPlotting.convert_arguments(
    P::AbstractPlotting.PlotFunc, x::AbstractVector, gp::AbstractGPs.AbstractGP
)
    return convert_arguments(P, gp(x, 1e-9))
end
function AbstractPlotting.convert_arguments(P::AbstractPlotting.PlotFunc, gp::FiniteGP)
    return convert_arguments(P, gp.x, gp)
end
