"""
    symband(x, y, Δy; bandscale=1.0, kwargs...)
    symband(xy, Δy; bandscale=1.0, kwargs...)

Plot a symmetric band of radius `bandscale * Δy` around `(x, y)`.

## Attributes

$(Makie.ATTRIBUTES)
"""
@recipe(SymBand, xy, Δy) do scene
    b_theme = default_theme(scene, Band)
    l_theme = default_theme(scene, Lines)
    Attributes(;
        color=l_theme.color,
        colormap=l_theme.colormap,
        colorrange=get(l_theme.attributes, :colorrange, AbstractPlotting.automatic),
        linestyle=l_theme.linestyle,
        linewidth=l_theme.linewidth,
        bandcolor=b_theme.color,
        bandcolormap=b_theme.colormap,
        bandcolorrange=b_theme.colorrange,
        bandscale=Node(1.0),
    )
end

function Makie.plot!(plot::SymBand)
    @extract plot (xy, Δy)
    lower_upper = lift(xy, Δy, plot.bandscale) do xy, Δy, scale
        return (
            Point2f0.(first.(xy), last.(xy) .- abs.(scale .* Δy)),
            Point2f0.(first.(xy), last.(xy) .+ abs.(scale .* Δy)),
        )
    end
    lower = lift(first, lower_upper)
    upper = lift(last, lower_upper)

    band!(
        plot,
        lower,
        upper;
        color=plot.bandcolor,
        colormap=plot.bandcolormap,
        colorrange=plot.bandcolorrange,
    )
    lines!(
        plot,
        xy;
        color=plot.color,
        linestyle=plot.linestyle,
        linewidth=plot.linewidth,
        colormap=plot.colormap,
        colorrange=plot.colorrange,
    )

    return plot
end

Makie.convert_arguments(::Type{<:SymBand}, x, y, Δy) = (map(Point2f0, x, y), Δy)
