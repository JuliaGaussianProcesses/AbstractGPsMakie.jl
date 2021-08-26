@testset "conversions.jl" begin
    gp = GP(SqExponentialKernel())
    x = rand(10)
    f = gp(x, 1e-9)
    mu, var = mean_and_var(f)
    z = rand(10)

    # `SymBand`
    @test convert_arguments(SymBand, z, f) == (map(Point2f, z, mu), map(sqrt, var))

    # `GPSample`
    @test convert_arguments(GPSample, z, f) == (z, f)

    # Default fallback
    for P in (Lines, LineSegments, Scatter)
        @test convert_arguments(P, z, f) == convert_arguments(P, z, mu)
    end

    # Fallback for `Band`
    lower = mu .- sqrt.(var)
    upper = mu .+ sqrt.(var)
    @test convert_arguments(Band, z, f) ==
          (map(Point2f, z, lower), map(Point2f, z, upper))
    scale = rand()
    lower = mu .- scale .* sqrt.(var)
    upper = mu .+ scale .* sqrt.(var)
    @test convert_arguments(Band, z, f; bandscale=scale) ==
          (map(Point2f, z, lower), map(Point2f, z, upper))

    # Fallback for `AbstractGP` and `FiniteGP`
    for P in (Lines, LineSegments, Scatter, Band, SymBand, GPSample)
        @test convert_arguments(P, x, gp) == convert_arguments(P, x, f)
        @test convert_arguments(P, f) == convert_arguments(P, x, f)
    end
end
