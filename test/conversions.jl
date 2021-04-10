@testset "conversions.jl" begin
    gp = GP(SqExponentialKernel())
    x = rand(10)
    f = gp(x, 1e-9)
    mu, var = mean_and_var(f)
    z = rand(10)

    # `SymBand`
    @test convert_arguments(SymBand, z, f) == (map(Point2f0, z, mu), map(sqrt, var))

    # `GPSample`
    @test convert_arguments(GPSample, z, f) == (z, f)

    # Default fallback
    for P in (Lines, LineSegments, Scatter)
        @test convert_arguments(P, z, f) == convert_arguments(P, z, mu)
    end

    # Fallback for `Band`
    lower = mu .- 3 .* sqrt.(var)
    upper = mu .+ 3 .* sqrt.(var)
    @test convert_arguments(Band, z, f) == (map(Point2f0, z, lower), map(Point2f0, z, upper))

    # Fallback for `AbstractGP` and `FiniteGP`
    for P in (Lines, LineSegments, Scatter, Band, SymBand, GPSample)
        @test convert_arguments(P, x, gp) == convert_arguments(P, x, f)
        @test convert_arguments(P, f) == convert_arguments(P, x, f)
    end
end
