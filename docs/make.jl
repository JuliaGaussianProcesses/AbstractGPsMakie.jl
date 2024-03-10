using Documenter

# Print `@debug` statements (https://github.com/JuliaDocs/Documenter.jl/issues/955)
if haskey(ENV, "GITHUB_ACTIONS")
    ENV["JULIA_DEBUG"] = "Documenter"
end

using AbstractGPsMakie

DocMeta.setdocmeta!(
    AbstractGPsMakie,
    :DocTestSetup,
    :(using AbstractGPsMakie);
    recursive=true
)

makedocs(;
    sitename="AbstractGPsMakie.jl",
    authors="David Widmann",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    modules=[AbstractGPsMakie],
    pages=["Home" => "index.md", "api.md"],
    warnonly=true,
    checkdocs=:exports,
)

deploydocs(;
    repo="github.com/JuliaGaussianProcesses/AbstractGPsMakie.jl",
    push_preview=true,
    devbranch="main",
)
