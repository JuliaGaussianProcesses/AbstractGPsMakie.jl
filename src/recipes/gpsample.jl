"""
    gpsample([x, ]gp::FiniteGP; samples=1, orbit=0.0, kwargs...)

Plot sample(s) from the finite projection of the Gaussian process `gp` along `x`.

If `x` is not provided, it is set to `gp.x`.

The `orbit` keyword argument can be used to visualize a manifold of
similar samples.[^PH2013] Values are mapped to the interval ``[0, 1)`` which
correspond to angles in ``[0, 2\\pi)`` on the great circle of samples.

## Attributes

$(AbstractPlotting.ATTRIBUTES)

[^PH2013]: Philipp Hennig (2013). [Animating Samples from Gaussian Distributions](http://mlss.tuebingen.mpg.de/2013/2013/Hennig_2013_Animating_Samples_from_Gaussian_Distributions.pdf). Technical Report No. 8 of the Max Planck Institute for Intelligent Systems.
"""
@recipe(GPSample, x, gp) do scene
    l_theme = default_theme(scene, Lines)
    Attributes(;
        color=l_theme.color,
        colormap=l_theme.colormap,
        colorrange=get(l_theme.attributes, :colorrange, AbstractPlotting.automatic),
        linestyle=l_theme.linestyle,
        linewidth=l_theme.linewidth,
        samples=Node(1),
        orbit=Node(0.0),
    )
end

"""
    gpsample(x::AbstractVector, gp::AbstractGP; kwargs...)

Plot sample(s) from the finite projection `gp(x, 1e-9)` along `x`.
"""
gpsample(::AbstractVector, ::AbstractGP; kwargs...)

function AbstractPlotting.plot!(plot::GPSample)
    @extract plot (x, gp)

    # Compute mean of the GP and the Cholesky decomposition of its covariance matrix
    mean_cov = lift(gp) do gp
        mean, Cmat = mean_and_cov(gp)
        C = cholesky(AbstractGPs._symmetric(Cmat))
        return mean, C
    end

    # Generate standard normally distributed samples and corresponding random tangents
    # We can then swipe a great circle of equivalent samples
    u_v_scale = lift(x, plot.samples) do x, nsamples
        # Generate samples and map them to the unit sphere
        u = randn(length(x), nsamples)
        scale = permutedims(map(norm, eachcol(u)))
        u ./= scale

        # Sample orthogonal tangent directions and map them to the unit sphere
        v = randn(size(u))
        for (ui, vi) in zip(eachcol(u), eachcol(v))
            vi .-= dot(ui, vi) .* ui
            vi ./= norm(vi)
        end

        return u, v, scale
    end

    orbit = plot.orbit
    points = lift(x, mean_cov, u_v_scale, orbit) do x, (mean, C), (u, v, scale), orbit
        # Ensure that `theta` is in [0, 2) (corresponding to angles in [0, 2π))
        theta = 2 * mod(orbit, 1)

        # Compute values on the orbit between `u` and `v`
        sin2pi_theta, cos2pi_theta = @static if VERSION < v"1.6.0-DEV.292"
            sinpi(theta), cospi(theta)
        else
            sincospi(theta)
        end
        R = scale .* (cos2pi_theta .* u .+ sin2pi_theta .* v)

        # Compute points to plot (NaN required to separate lines)
        d, n = size(R)
        z = fill(Point2f0(NaN32), d + 1, n)
        zflat = reinterpret(Float32, z)

        # Fill x coordinates
        xcoords = view(zflat, 1:2:(2 * d), :)
        xcoords .= x

        # Compute y coordinates
        ycoords = view(zflat, 2:2:(2 * d), :)
        mul!(ycoords, C.U', R)
        ycoords .+= mean

        # Return vector of points
        return vec(z)
    end

    lines!(
        plot,
        points;
        color=plot.color,
        linestyle=plot.linestyle,
        linewidth=plot.linewidth,
        colormap=plot.colormap,
        colorrange=plot.colorrange,
    )

    return plot
end
