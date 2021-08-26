"""
    symband(x, y, Δy; bandscale=1.0, kwargs...)
    symband(xy, Δy; bandscale=1.0, kwargs...)

Plot a symmetric band of radius `bandscale * Δy` around `(x, y)`.

## Attributes

$(Makie.ATTRIBUTES)
"""
@recipe(SymBand, xy, Δy) do scene
    Attributes(;
        bandscale=Node(1.0),
        color=theme(scene, :patchcolor),
        colormap=theme(scene, :colormap),
        colorrange=Makie.automatic,
        linecolor=Makie.automatic,
        linestyle=theme(scene, :linestyle),
        linewidth=theme(scene, :linewidth),
        cycle=[:color => :patchcolor],
        inspectable=theme(scene, :inspectable),
    )
end

function Makie.plot!(plot::SymBand)
    @extract plot (xy, Δy)
    lower_upper = lift(xy, Δy, plot.bandscale) do xy, Δy, scale
        return (
            Point2f.(first.(xy), last.(xy) .- abs.(scale .* Δy)),
            Point2f.(first.(xy), last.(xy) .+ abs.(scale .* Δy)),
        )
    end
    lower = lift(first, lower_upper)
    upper = lift(last, lower_upper)

    linecolor = lift(plot.color, plot.linecolor) do color, linecolor
        linecolor === Makie.automatic || return linecolor
        c = to_color(color)
        return Makie.RGB(Makie.red(c), Makie.green(c), Makie.blue(c))
    end

    band!(
        plot,
        lower,
        upper;
        color=plot.color,
        colormap=plot.colormap,
        colorrange=plot.colorrange,
    )
    lines!(
        plot,
        xy;
        color=linecolor,
        linestyle=plot.linestyle,
        linewidth=plot.linewidth,
        colormap=plot.colormap,
        colorrange=plot.colorrange,
    )

    return plot
end

Makie.convert_arguments(::Type{<:SymBand}, x, y, Δy) = (map(Point2f, x, y), Δy)
