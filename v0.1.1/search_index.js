var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/#Symmetric-band","page":"API","title":"Symmetric band","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"symband","category":"page"},{"location":"api/#AbstractGPsMakie.symband","page":"API","title":"AbstractGPsMakie.symband","text":"symband(x, y, Δy; bandscale=1.0, kwargs...)\nsymband(xy, Δy; bandscale=1.0, kwargs...)\n\nPlot a symmetric band of radius bandscale * Δy around (x, y).\n\nAttributes\n\nAvailable attributes and their defaults for AbstractPlotting.Combined{AbstractGPsMakie.symband, T} where T are: \n\n  bandcolor       RGBA{Float32}(0.0f0,0.0f0,0.0f0,0.2f0)\n  bandcolormap    :viridis\n  bandcolorrange  AbstractPlotting.Automatic()\n  bandscale       1.0\n  color           :black\n  colormap        :viridis\n  colorrange      AbstractPlotting.Automatic()\n  linestyle       \"nothing\"\n  linewidth       1.0\n\n\n\n\n\n","category":"function"},{"location":"api/#Example","page":"API","title":"Example","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"using AbstractGPsMakie\nusing CairoMakie\nusing Random: Random # hide\nRandom.seed!(1) # hide\n\nx = 1:10\ny = rand(10)\nΔy = rand(10)\nsymband(x, y, Δy; color=:blue, bandcolor=(:blue, 0.3), bandscale=2.5)\nsave(\"symband_example.svg\", current_figure()); nothing # hide","category":"page"},{"location":"api/","page":"API","title":"API","text":"(Image: symband example)","category":"page"},{"location":"api/#Samples","page":"API","title":"Samples","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"gpsample\ngpsample(::AbstractVector, ::AbstractGPsMakie.AbstractGP)","category":"page"},{"location":"api/#AbstractGPsMakie.gpsample","page":"API","title":"AbstractGPsMakie.gpsample","text":"gpsample([x, ]gp::FiniteGP; samples=1, orbit=0.0, kwargs...)\n\nPlot sample(s) from the finite projection of the Gaussian process gp along x.\n\nIf x is not provided, it is set to gp.x.\n\nThe orbit keyword argument can be used to visualize a manifold of similar samples.[PH2013] Values are mapped to the interval 0 1) which correspond to angles in 0 2pi) on the great circle of samples.\n\nAttributes\n\nAvailable attributes and their defaults for AbstractPlotting.Combined{AbstractGPsMakie.gpsample, T} where T are: \n\n  color       :black\n  colormap    :viridis\n  colorrange  AbstractPlotting.Automatic()\n  linestyle   \"nothing\"\n  linewidth   1.0\n  orbit       0.0\n  samples     1\n\n[PH2013]: Philipp Hennig (2013). Animating Samples from Gaussian Distributions. Technical Report No. 8 of the Max Planck Institute for Intelligent Systems.\n\n\n\n\n\ngpsample(x::AbstractVector, gp::AbstractGP; kwargs...)\n\nPlot sample(s) from the finite projection gp(x, 1e-9) along x.\n\n\n\n\n\n","category":"function"},{"location":"api/#AbstractGPsMakie.gpsample-Tuple{AbstractVector{T} where T, AbstractGPs.AbstractGP}","page":"API","title":"AbstractGPsMakie.gpsample","text":"gpsample(x::AbstractVector, gp::AbstractGP; kwargs...)\n\nPlot sample(s) from the finite projection gp(x, 1e-9) along x.\n\n\n\n\n\n","category":"method"},{"location":"api/#Example-2","page":"API","title":"Example","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"using AbstractGPs\nusing AbstractGPsMakie\nusing CairoMakie\nusing Random: Random # hide\nRandom.seed!(1) # hide\n\ngp = GP(Matern32Kernel())\ngpsample(0:0.01:10, gp; samples=10, color=:red)\nsave(\"gpsample_example.svg\", current_figure()); nothing # hide","category":"page"},{"location":"api/","page":"API","title":"API","text":"(Image: gpsample example)","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = AbstractGPsMakie","category":"page"},{"location":"#AbstractGPsMakie","page":"Home","title":"AbstractGPsMakie","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Plots of Gaussian processes with AbstractGPs and Makie","category":"page"},{"location":"#Quick-start","page":"Home","title":"Quick start","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This guide shows the basic functionality of AbstractGPsMakie.","category":"page"},{"location":"","page":"Home","title":"Home","text":"First, we load a Makie plotting backend. Here we import CairoMakie, other available backends are WGLMakie and GLMakie.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using CairoMakie","category":"page"},{"location":"","page":"Home","title":"Home","text":"We load a custom set of colors and globally set the x-axis limits.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using CairoMakie.AbstractPlotting.ColorSchemes: Set1_4\n\nset_theme!(Theme(Axis=(limits=((0, 10), nothing),)))","category":"page"},{"location":"","page":"Home","title":"Home","text":"We perform a simple Gaussian process (GP) regression with AbstractGPs. We use a squared exponential kernel for our GP.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using AbstractGPs\n\ngp = GP(SqExponentialKernel())\nnothing # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"We assume that data are observed under i.i.d. Gaussian noise with zero mean and variance 0.01. We generate some random observations.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Random\n\nRandom.seed!(1234)\n\nx = 10 .* rand(10)\ngpx = gp(x, 0.01)\ny = rand(gpx)\n\nscatter(x, y; color=Set1_4[1])\nsave(\"data.svg\", current_figure()); nothing # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: data)","category":"page"},{"location":"","page":"Home","title":"Home","text":"We compute the posterior.","category":"page"},{"location":"","page":"Home","title":"Home","text":"posterior_gp = posterior(gpx, y)\nnothing # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"We plot the posterior with AbstractGPsMakie. The bandscale parameter (default: 1) determines the amount of standard deviations from the mean that are highlighted in the plot.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using AbstractGPsMakie\n\nplot(0:0.01:10, posterior_gp; bandscale=3, color=Set1_4[2], bandcolor=(Set1_4[2], 0.2))\nscatter!(x, y; color=Set1_4[1])\nsave(\"posterior.svg\", current_figure()); nothing # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: posterior)","category":"page"},{"location":"","page":"Home","title":"Home","text":"We add 10 samples from the posterior on top.","category":"page"},{"location":"","page":"Home","title":"Home","text":"plot(0:0.01:10, posterior_gp; bandscale=3, color=Set1_4[2], bandcolor=(Set1_4[2], 0.2))\ngpsample!(0:0.01:10, posterior_gp; samples=10, color=Set1_4[3])\nscatter!(x, y; color=Set1_4[1])\nsave(\"posterior_samples.svg\", current_figure()); nothing # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: posterior samples)","category":"page"},{"location":"","page":"Home","title":"Home","text":"We can visualize a manifold of similar samples by animating the generated samples.[PH2013]","category":"page"},{"location":"","page":"Home","title":"Home","text":"scene = plot(\n    0:0.01:10, posterior_gp;\n    bandscale=3, color=Set1_4[2], bandcolor=(Set1_4[2], 0.2),\n)\nsamples = gpsample!(0:0.01:10, posterior_gp; samples=10, color=Set1_4[3])\nscatter!(x, y; color=Set1_4[1])\n\nrecord(scene, \"posterior_animation.mp4\", 0:0.01:4) do x\n    samples.orbit[] = x\nend\nnothing # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: posterior animation)","category":"page"},{"location":"","page":"Home","title":"Home","text":"[PH2013]: Philipp Hennig (2013). Animating Samples from Gaussian Distributions. Technical Report No. 8 of the Max Planck Institute for Intelligent Systems.","category":"page"}]
}
