using Documenter

# Print `@debug` statements (https://github.com/JuliaDocs/Documenter.jl/issues/955)
if haskey(ENV, "GITHUB_ACTIONS")
    ENV["JULIA_DEBUG"] = "Documenter"
end

using AbstractGPsMakie

DocMeta.setdocmeta!(
    AbstractGPsMakie, :DocTestSetup, :(using AbstractGPsMakie); recursive=true
)

makedocs(;
    modules=[AbstractGPsMakie],
    authors="David Widmann",
    repo="https://github.com/devmotion/AbstractGPsMakie.jl/blob/{commit}{path}#{line}",
    sitename="AbstractGPsMakie.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://devmotion.github.io/AbstractGPsMakie.jl",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
    #strict=true,
    checkdocs=:exports,
)

deploydocs(; repo="github.com/devmotion/AbstractGPsMakie.jl", push_preview=true)
