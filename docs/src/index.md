```@meta
CurrentModule = AbstractGPsMakie
```

# AbstractGPsMakie

*Plots of Gaussian processes with [AbstractGPs](https://github.com/JuliaGaussianProcesses/AbstractGPs.jl) and [Makie](https://github.com/JuliaPlots/Makie.jl)*

## Quick start

This guide shows the basic functionality of AbstractGPsMakie.

First, we load a Makie plotting backend. Here we import
[CairoMakie](https://github.com/JuliaPlots/CairoMakie.jl), other available
backends are [WGLMakie](https://github.com/JuliaPlots/WGLMakie.jl) and
[GLMakie](https://github.com/JuliaPlots/GLMakie.jl).

```@example quickstart
using CairoMakie
```

We load a custom set of colors and globally set the x-axis limits.

```@example quickstart
using CairoMakie.Makie.ColorSchemes: Set1_4

set_theme!(Theme(Axis=(limits=((0, 10), nothing),)))
```

We perform a simple Gaussian process (GP) regression with
[AbstractGPs](https://github.com/JuliaGaussianProcesses/AbstractGPs.jl).
We use a squared exponential kernel for our GP.

```@example quickstart
using AbstractGPs

gp = GP(SqExponentialKernel())
nothing # hide
```

We assume that data are observed under i.i.d. Gaussian noise with
zero mean and variance 0.01. We generate some random observations.

```@example quickstart
using Random

Random.seed!(1234)

x = 10 .* rand(10)
gpx = gp(x, 0.01)
y = rand(gpx)

scatter(x, y; color=Set1_4[1])
save("data.svg", current_figure()); nothing # hide
```

![data](data.svg)

We compute the posterior.

```@example quickstart
posterior_gp = posterior(gpx, y)
nothing # hide
```

We plot the posterior with AbstractGPsMakie. The `bandscale` parameter (default: 1)
determines the amount of standard deviations from the mean that are highlighted in
the plot.

```@example quickstart
using AbstractGPsMakie

plot(0:0.01:10, posterior_gp; bandscale=3, color=Set1_4[2], bandcolor=(Set1_4[2], 0.2))
scatter!(x, y; color=Set1_4[1])
save("posterior.svg", current_figure()); nothing # hide
```

![posterior](posterior.svg)

We add 10 samples from the posterior on top.

```@example quickstart
plot(0:0.01:10, posterior_gp; bandscale=3, color=Set1_4[2], bandcolor=(Set1_4[2], 0.2))
gpsample!(0:0.01:10, posterior_gp; samples=10, color=Set1_4[3])
scatter!(x, y; color=Set1_4[1])
save("posterior_samples.svg", current_figure()); nothing # hide
```

![posterior samples](posterior_samples.svg)

We can visualize a manifold of similar samples by animating the generated samples.[^PH2013]

```@example quickstart
scene = plot(
    0:0.01:10, posterior_gp;
    bandscale=3, color=Set1_4[2], bandcolor=(Set1_4[2], 0.2),
)
samples = gpsample!(0:0.01:10, posterior_gp; samples=10, color=Set1_4[3])
scatter!(x, y; color=Set1_4[1])

record(scene, "posterior_animation.mp4", 0:0.01:4) do x
    samples.orbit[] = x
end
nothing # hide
```

![posterior animation](posterior_animation.mp4)

[^PH2013]: Philipp Hennig (2013). [Animating Samples from Gaussian Distributions](http://mlss.tuebingen.mpg.de/2013/2013/Hennig_2013_Animating_Samples_from_Gaussian_Distributions.pdf). Technical Report No. 8 of the Max Planck Institute for Intelligent Systems.
