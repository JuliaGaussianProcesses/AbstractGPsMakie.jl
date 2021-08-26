# `SymBand` for `FiniteGP`
function Makie.convert_arguments(
    ::Type{P}, x::AbstractVector, gp::FiniteGP
) where {P<:SymBand}
    y, var = mean_and_var(gp)
    Δy = sqrt.(var)
    return convert_arguments(P, x, y, Δy)
end

# `GPSample` for `FiniteGP`
Makie.convert_arguments(::Type{<:GPSample}, x::AbstractVector, gp::FiniteGP) = (x, gp)

# Default fallback: plot mean of GP
function Makie.convert_arguments(P::Makie.PlotFunc, x::AbstractVector, gp::FiniteGP)
    return convert_arguments(P, x, mean(gp))
end

# `Band` with scaling for `FiniteGP`
Makie.used_attributes(::Type{<:Band}, ::AbstractVector, ::FiniteGP) = (:bandscale,)
function Makie.convert_arguments(
    ::Type{<:Band}, x::AbstractVector, gp::FiniteGP; bandscale=1
)
    y, var = mean_and_var(gp)
    Δy = bandscale .* sqrt.(var)
    return (Point2f.(x, y .- Δy), Point2f.(x, y .+ Δy))
end

# default conversions for `FiniteGP` and `AbstractGP`
function Makie.convert_arguments(
    P::Makie.PlotFunc, x::AbstractVector, gp::AbstractGPs.AbstractGP
)
    return convert_arguments(P, gp(x, 1e-9))
end
function Makie.convert_arguments(P::Makie.PlotFunc, gp::FiniteGP)
    return convert_arguments(P, gp.x, gp)
end
