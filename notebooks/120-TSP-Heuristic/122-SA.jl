### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 51bfede6-1436-11ec-0cc6-bfff507e0e99
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add(
        [
            Pkg.PackageSpec("Plots")
            Pkg.PackageSpec("ImageShow")
            Pkg.PackageSpec("ImageIO")
            Pkg.PackageSpec("PNGFiles")
        ],
    )
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 879c42ee-f980-42e9-bb81-2f27672aecbf
using Plots

# ╔═╡ 5c248fc4-a398-4e3c-bce0-3f01260beec3
using ImageShow

# ╔═╡ 1d0c4acf-2636-4058-b96d-a5d66b1b0ce2
using PNGFiles

# ╔═╡ 5724ac80-d48f-434d-9c57-51bb2d655ea9
using Random

# ╔═╡ 327ab33d-2286-4916-abee-82c8d647582a
include(joinpath(@__DIR__, "120-functions.jl"))

# ╔═╡ bc810e37-4517-4a2c-84fb-338ba446915e
md"""
# Traveling Salesman Problem
"""

# ╔═╡ c7c9a12f-f3ab-4251-888d-d1ac9b87aa60
md"""
## Vecindarios
"""

# ╔═╡ e44f264e-e87d-4498-b89a-cdd8519eddd1
function tspSwapSA(tour::Array{Int,1}, dist::Array{Float64,2})
    n, _ = size(dist)

    besti = rand(2:n-1)
    bestj = rand(besti+1:n)

    newtour = copy(tour)
    newtour[besti], newtour[bestj] = newtour[bestj], newtour[besti]
    return newtour
end

# ╔═╡ 8572781c-d545-4229-ab20-1fbd84678c7e
function tspInsSA(tour::Array{Int,1}, dist::Array{Float64,2})
    n, _ = size(dist)

    besti = rand(2:n-1)
    bestj = rand(besti+2:n+1)

    newtour = copy(tour)
    insert!(newtour, bestj, newtour[besti])
    deleteat!(newtour, besti)

    return newtour
end

# ╔═╡ 64cdae57-1a43-4300-9c35-16e94104280f
function tsp2OptSA(tour::Array{Int,1}, dist::Array{Float64,2})
    n, _ = size(dist)

    besti = rand(2:n-1)
    bestj = rand(besti+1:n)

    return reverse(tour, besti, bestj)
end

# ╔═╡ d049dd39-4736-4ff0-b2b0-981c61ee3296
md"""
## Simulated Annealing
"""

# ╔═╡ fab77d3b-203d-4033-bdd0-6ee1ff3cc572
function mhSA(tour::Array{Int,1}, dist::Array{Float64,2}, nbh::Array{Function,1})
    n, _ = size(dist)
    ctour = copy(tour)
    besttour = copy(tour)

    temp = 1_000.0
    temp_alpha = 0.9753
    maxiter = 50 * n

    busqueda0 = [tspDist(dist, ctour)] # actual ztour
    busqueda1 = copy(busqueda0)        # mejor  ztour
    busquedat = [temp]                 # actual temp
    busquedafn = ["base"]              # actual fn

    for _ in 1:maxiter
        nh = rand(nbh)
        newtour = nh(ctour, dist)
        newtourz = tspDist(dist, newtour)

        delta = newtourz - busqueda0[end]
        acepta = delta < 0.0 ? true : rand() < exp(-delta / temp)
        if acepta
            ctour = newtour
            push!(busqueda0, newtourz)
        else
            push!(busqueda0, busqueda0[end])
        end

        if newtourz < busqueda1[end]
            besttour = newtour
            push!(busqueda1, newtourz)
        else
            push!(busqueda1, busqueda1[end])
        end

        temp = temp_alpha * temp
        push!(busquedat, temp)
        push!(busquedafn, string(nh))
        @show busqueda0[end], nh
    end

    plot(busqueda0)
    plot!(busqueda1)

    savefig(joinpath(@__DIR__, "tsp-plot-SAz.png"))
    savefig(plot(busquedat), joinpath(@__DIR__, "tsp-plot-SAt.png"))

    return besttour
end

# ╔═╡ b03019d3-0270-45d8-ab5e-fcfb8d20dbc6
md"""
### Ejemplo de Programa
"""

# ╔═╡ 3f648c67-e281-406e-8953-28c6f138280c
begin
    X, Y = tspXYRand(10)
    dist = distEuclidean(X, Y)
    tour = tspRND(dist)
end

# ╔═╡ 526a7132-103b-4c0b-9bf5-7125de50320e
# nbh::Array{Function,1} = [tspInsSA]
# nbh::Array{Function,1} = [tspSwapSA]
# nbh::Array{Function,1} = [tsp2OptSA]
# nbh::Array{Function,1} = [tspInsSA, tspSwapSA, tsp2OptSA]
# nbh::Array{Function,1} = [tsp2OptSA, tspSwapSA, tspInsSA]
nbh::Array{Function,1} = [tspSwapSA, tspInsSA, tsp2OptSA]

# ╔═╡ fe14fe38-c519-4103-bf59-207cfd2eb402
tourMH = mhSA(tour, dist, nbh)

# ╔═╡ f5050494-1975-4558-9a1f-2a44b388b3dd
tspPlot(X, Y, tourMH)

# ╔═╡ 1e099701-6fd7-42d3-a76e-0077c4c8a174
PNGFiles.load(joinpath(@__DIR__, "tsp-plot-SAz.png"))

# ╔═╡ 0c85af3d-16bc-493c-a4e2-43af9a61026c
PNGFiles.load(joinpath(@__DIR__, "tsp-plot-SAt.png"))

# ╔═╡ Cell order:
# ╟─51bfede6-1436-11ec-0cc6-bfff507e0e99
# ╠═879c42ee-f980-42e9-bb81-2f27672aecbf
# ╠═5c248fc4-a398-4e3c-bce0-3f01260beec3
# ╠═1d0c4acf-2636-4058-b96d-a5d66b1b0ce2
# ╠═5724ac80-d48f-434d-9c57-51bb2d655ea9
# ╟─bc810e37-4517-4a2c-84fb-338ba446915e
# ╠═327ab33d-2286-4916-abee-82c8d647582a
# ╟─c7c9a12f-f3ab-4251-888d-d1ac9b87aa60
# ╠═e44f264e-e87d-4498-b89a-cdd8519eddd1
# ╠═8572781c-d545-4229-ab20-1fbd84678c7e
# ╠═64cdae57-1a43-4300-9c35-16e94104280f
# ╟─d049dd39-4736-4ff0-b2b0-981c61ee3296
# ╠═fab77d3b-203d-4033-bdd0-6ee1ff3cc572
# ╟─b03019d3-0270-45d8-ab5e-fcfb8d20dbc6
# ╠═3f648c67-e281-406e-8953-28c6f138280c
# ╠═526a7132-103b-4c0b-9bf5-7125de50320e
# ╠═fe14fe38-c519-4103-bf59-207cfd2eb402
# ╠═f5050494-1975-4558-9a1f-2a44b388b3dd
# ╠═1e099701-6fd7-42d3-a76e-0077c4c8a174
# ╠═0c85af3d-16bc-493c-a4e2-43af9a61026c
