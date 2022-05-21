### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 413d6f34-d13a-47dd-b711-98d81f50f55e
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

# ╔═╡ 51bfede6-1436-11ec-0cc6-bfff507e0e99
using Plots

# ╔═╡ 8728c4f5-f299-49b0-afbe-95e2b82e377b
using ImageShow

# ╔═╡ 73c9aa55-3d14-4b7c-8702-5d6a06424408
using PNGFiles

# ╔═╡ 03fcd07b-99d5-4e2d-bc7f-9e00909139c6
using Random

# ╔═╡ dbdc9bce-31fb-4e07-84fa-a9bfb6a62829
include(joinpath(@__DIR__, "120-functions.jl"))

# ╔═╡ bc810e37-4517-4a2c-84fb-338ba446915e
md"""
# Traveling Salesman Problem
"""

# ╔═╡ b03019d3-0270-45d8-ab5e-fcfb8d20dbc6
md"""
### Ejemplo de Programa
"""

# ╔═╡ 3f648c67-e281-406e-8953-28c6f138280c
begin
    X, Y = tspXYRand(10)
    dist = distEuclidean(X, Y)
    nothing
end

# ╔═╡ 1f47d25b-69b6-4c18-a1c1-5ce8ef922611
# tour = tspRND(dist)
# tour = tspNN(dist)
# tour = tspCI(dist)
# tour = tspCWs(dist)
# tour = tspCWp(dist)

tour = tspRND(dist)

# ╔═╡ 4a1c0d9a-f99d-4402-ac9f-c341d04164de
tspDist(dist, tour)

# ╔═╡ 8d24ee93-ab92-49f6-bcfe-10a491f0a9d9
tspPlot(X, Y, tour)

# ╔═╡ c7c9a12f-f3ab-4251-888d-d1ac9b87aa60
md"""
## Busquedas Locales - Vecindarios
"""

# ╔═╡ e44f264e-e87d-4498-b89a-cdd8519eddd1
function tspSwap(tour::Array{Int,1}, dist::Array{Float64,2}, sf::Bool)
    n, _ = size(dist)

    besti = 0
    bestj = 0
    bestd = 0.0
    for i in 2:n-1, j in i+2:n
        dd = 0.0
        dd += dist[tour[i-1], tour[j]] + dist[tour[j], tour[i+1]]
        dd += dist[tour[j-1], tour[i]] + dist[tour[i], tour[j+1]]
        dd -= dist[tour[i-1], tour[i]] + dist[tour[i], tour[i+1]]
        dd -= dist[tour[j-1], tour[j]] + dist[tour[j], tour[j+1]]
        if dd < bestd - eps(Float16)
            besti = i
            bestj = j
            bestd = dd
            if sf
                break
            end
        end
    end

    if besti == 0 || bestj == 0
        return nothing
    end

    newtour = copy(tour)
    newtour[besti], newtour[bestj] = newtour[bestj], newtour[besti]
    return newtour
end

# ╔═╡ 8572781c-d545-4229-ab20-1fbd84678c7e
function tspIns(tour::Array{Int,1}, dist::Array{Float64,2}, sf::Bool)
    n, _ = size(dist)

    besti = 0
    bestj = 0
    bestd = 0.0
    for i in 2:n-1, j in i+2:n+1
        dd = 0.0
        dd -= dist[tour[i-1], tour[i]] + dist[tour[i], tour[i+1]]
        dd += dist[tour[i-1], tour[i+1]]
        dd -= dist[tour[j-1], tour[j]]
        dd += dist[tour[j-1], tour[i]] + dist[tour[i], tour[j]]
        if dd < bestd - eps(Float16)
            besti = i
            bestj = j
            bestd = dd
            if sf
                break
            end
        end
    end

    if besti == 0 || bestj == 0
        return nothing
    end

    newtour = copy(tour)
    insert!(newtour, bestj, newtour[besti])
    deleteat!(newtour, besti)

    return newtour
end

# ╔═╡ 64cdae57-1a43-4300-9c35-16e94104280f
function tsp2Opt(tour::Array{Int,1}, dist::Array{Float64,2}, sf::Bool)
    n, _ = size(dist)

    besti = 0
    bestj = 0
    bestd = 0.0
    for i in 2:n-1, j in i+1:n
        dd = dist[tour[i-1], tour[j]] + dist[tour[i], tour[j+1]] - dist[tour[i-1], tour[i]] - dist[tour[j], tour[j+1]]
        if dd < bestd - eps(Float16)
            besti = i
            bestj = j
            bestd = dd
            if sf
                break
            end
        end
    end

    if besti == 0 || bestj == 0
        return nothing
    end

    return reverse(tour, besti, bestj)
end

# ╔═╡ d049dd39-4736-4ff0-b2b0-981c61ee3296
md"""
## Busquedas Locales - Algoritmos
"""

# ╔═╡ fab77d3b-203d-4033-bdd0-6ee1ff3cc572
function mhLocalSearch1(tour::Array{Int,1}, dist::Array{Float64,2}, nbh::Function; sf::Bool = false)
    ctour = copy(tour)
    busqueda0 = [tspDist(dist, ctour)] # actual ztour

    while true
        newtour = nbh(ctour, dist, sf)
        if newtour === nothing
            break
        end

        newtourz = tspDist(dist, newtour)
        @show newtourz, newtour

        if newtourz < busqueda0[end]
            push!(busqueda0, newtourz)
            ctour = newtour
        else
            break
        end
    end

    savefig(plot(busqueda0), joinpath(@__DIR__, "tsp-plot-ls1.png"))
    return ctour
end

# ╔═╡ 227c17b7-39cd-434c-b6fd-4afacd007302
md"""
### mhLocalSearch1
"""

# ╔═╡ 3a6639ba-2c69-411d-aedf-a79f37af0bbf
# nbh1::Function = tspIns
# nbh1::Function = tspSwap
# nbh1::Function = tsp2Opt
nbh1::Function = tsp2Opt

# ╔═╡ 624930ac-db0b-4cad-9195-b7617287ecd0
# tourLS1 = mhLocalSearch1(tour, dist, nbh1)
# tourLS1 = mhLocalSearch1(tour, dist, nbh1; sf = true)
# tourLS1 = mhLocalSearch1(tour, dist, nbh1; sf = false)
tourLS1 = mhLocalSearch1(tour, dist, nbh1, sf = true)

# ╔═╡ d8b2fc58-194a-46dd-bd0e-c85603719971
tspPlot(X, Y, tourLS1)

# ╔═╡ a2340e34-f4d7-41ee-b923-b6b2074fb3e5
PNGFiles.load(joinpath(@__DIR__, "tsp-plot-ls1.png"))

# ╔═╡ b5cbfb3f-895c-4bf2-a16c-04a23a91a4c3
md"""
### mhLocalSearch
"""

# ╔═╡ 35265c1c-11a2-457c-a005-ff96cc31eb89
function mhLocalSearch(tour::Array{Int,1}, dist::Array{Float64,2}, nbh::Array{Function,1}; sf::Bool = false)
    ctour = copy(tour)
    busqueda0 = [tspDist(dist, ctour)] # actual ztour
    busquedafn = ["base"] # actual fn

    while true
        nbh_tour = [(nbh_i(ctour, dist, sf), string(nbh_i)) for nbh_i in nbh]
        nbh_ztour = []
        for (t, fn) in nbh_tour
            if t === nothing
                continue
            end
            dzt = tspDist(dist, t) - busqueda0[end]
            if dzt > 0.0
                continue
            end
            push!(nbh_ztour, (dzt, t, fn))
        end

        if length(nbh_ztour) == 0
            break
        end

        if sf == false
            sort!(nbh_ztour)
        end

        ctour = nbh_ztour[1][2]
        push!(busqueda0, tspDist(dist, ctour))
        push!(busquedafn, nbh_ztour[1][3])

        _z = busqueda0[end]
        _f = busquedafn[end]

        @show _z, _f, ctour
    end

    savefig(plot(busqueda0), joinpath(@__DIR__, "tsp-plot-lss.png"))
    return ctour
end

# ╔═╡ fe14fe38-c519-4103-bf59-207cfd2eb402
# nbh::Array{Function,1} = [tspIns]
# nbh::Array{Function,1} = [tspSwap]
# nbh::Array{Function,1} = [tsp2Opt]
# nbh::Array{Function,1} = [tspIns, tspSwap, tsp2Opt]
# nbh::Array{Function,1} = [tsp2Opt, tspSwap, tspIns]
nbh::Array{Function,1} = [tspSwap, tspIns]

# ╔═╡ 0dc3bc33-04c7-4905-8245-78e4412a47fd
# tourLSS = mhLocalSearch(tour, dist, nbh)
# tourLSS = mhLocalSearch(tour, dist, nbh; sf = true)
# tourLSS = mhLocalSearch(tour, dist, nbh; sf = false)
tourLSS = mhLocalSearch(tour, dist, nbh, sf = true)

# ╔═╡ f5050494-1975-4558-9a1f-2a44b388b3dd
tspPlot(X, Y, tourLSS)

# ╔═╡ 1faf1c9d-9717-45e5-9950-91400383c71b
PNGFiles.load(joinpath(@__DIR__, "tsp-plot-lss.png"))

# ╔═╡ 90497267-22a8-400b-9799-9b0dfb629f05
md"""
## Variable Neighborhood Search
"""

# ╔═╡ 7065b5f0-b6a5-49ad-9dc4-08bf704e50e6
function mhVNS(tour::Array{Int,1}, dist::Array{Float64,2}, nbh::Array{Function,1}; sf::Bool = false)
    ctour = copy(tour)
    busqueda0 = [tspDist(dist, ctour)] # actual ztour
    busquedafn = ["base"] # actual fn

    while true
        nomejora = false
        for nbh_i in nbh
            newtour = nbh_i(ctour, dist, sf)
            if nbh_i == nbh[end]
                nomejora = true
            end
            if newtour === nothing
                continue
            end

            zt = tspDist(dist, newtour)
            if zt < busqueda0[end]
                ctour = newtour
                push!(busqueda0, zt)
                push!(busquedafn, string(nbh_i))
                @show zt, nbh_i, ctour
                nomejora = false
                break
            end
        end
        if nomejora
            break
        end
    end

    savefig(plot(busqueda0), joinpath(@__DIR__, "tsp-plot-vns.png"))

    return ctour
end

# ╔═╡ f81a0464-968d-4b8e-9688-bfecdd086f80
# nbh::Array{Function,1} = [tspIns]
# nbh::Array{Function,1} = [tspSwap]
# nbh::Array{Function,1} = [tsp2Opt]
# nbh::Array{Function,1} = [tspIns, tspSwap, tsp2Opt]
# nbh::Array{Function,1} = [tsp2Opt, tspSwap, tspIns]
nbhvns::Array{Function,1} = [tspSwap, tspIns, tsp2Opt]

# ╔═╡ 98d6408b-2d04-42bd-aecb-2ad3f9ff742b
# tourMH = mhVNS(tour, dist, nbh)
# tourMH = mhVNS(tour, dist, nbh; sf = true)
# tourMH = mhVNS(tour, dist, nbh; sf = false)
tourMH = mhVNS(tour, dist, nbhvns; sf = true)

# ╔═╡ fd0cda02-86c6-47c8-aaf2-5ffa9d6f2f6b
tspPlot(X, Y, tourMH)

# ╔═╡ b626019a-5639-4c12-bd28-4b0da0ae2065
PNGFiles.load(joinpath(@__DIR__, "tsp-plot-vns.png"))

# ╔═╡ Cell order:
# ╟─413d6f34-d13a-47dd-b711-98d81f50f55e
# ╠═51bfede6-1436-11ec-0cc6-bfff507e0e99
# ╠═8728c4f5-f299-49b0-afbe-95e2b82e377b
# ╠═73c9aa55-3d14-4b7c-8702-5d6a06424408
# ╠═03fcd07b-99d5-4e2d-bc7f-9e00909139c6
# ╟─bc810e37-4517-4a2c-84fb-338ba446915e
# ╠═dbdc9bce-31fb-4e07-84fa-a9bfb6a62829
# ╟─b03019d3-0270-45d8-ab5e-fcfb8d20dbc6
# ╠═3f648c67-e281-406e-8953-28c6f138280c
# ╠═1f47d25b-69b6-4c18-a1c1-5ce8ef922611
# ╠═4a1c0d9a-f99d-4402-ac9f-c341d04164de
# ╠═8d24ee93-ab92-49f6-bcfe-10a491f0a9d9
# ╟─c7c9a12f-f3ab-4251-888d-d1ac9b87aa60
# ╠═e44f264e-e87d-4498-b89a-cdd8519eddd1
# ╠═8572781c-d545-4229-ab20-1fbd84678c7e
# ╠═64cdae57-1a43-4300-9c35-16e94104280f
# ╟─d049dd39-4736-4ff0-b2b0-981c61ee3296
# ╠═fab77d3b-203d-4033-bdd0-6ee1ff3cc572
# ╟─227c17b7-39cd-434c-b6fd-4afacd007302
# ╠═3a6639ba-2c69-411d-aedf-a79f37af0bbf
# ╠═624930ac-db0b-4cad-9195-b7617287ecd0
# ╠═d8b2fc58-194a-46dd-bd0e-c85603719971
# ╠═a2340e34-f4d7-41ee-b923-b6b2074fb3e5
# ╟─b5cbfb3f-895c-4bf2-a16c-04a23a91a4c3
# ╠═35265c1c-11a2-457c-a005-ff96cc31eb89
# ╠═fe14fe38-c519-4103-bf59-207cfd2eb402
# ╠═0dc3bc33-04c7-4905-8245-78e4412a47fd
# ╠═f5050494-1975-4558-9a1f-2a44b388b3dd
# ╠═1faf1c9d-9717-45e5-9950-91400383c71b
# ╟─90497267-22a8-400b-9799-9b0dfb629f05
# ╠═7065b5f0-b6a5-49ad-9dc4-08bf704e50e6
# ╠═f81a0464-968d-4b8e-9688-bfecdd086f80
# ╠═98d6408b-2d04-42bd-aecb-2ad3f9ff742b
# ╠═fd0cda02-86c6-47c8-aaf2-5ffa9d6f2f6b
# ╠═b626019a-5639-4c12-bd28-4b0da0ae2065
