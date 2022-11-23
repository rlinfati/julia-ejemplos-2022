### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 51bfede6-1436-11ec-0cc6-bfff507e0e99
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("Plots")
        Pkg.PackageSpec("ImageShow")
        Pkg.PackageSpec("ImageIO")
        Pkg.PackageSpec("PNGFiles")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 879c42ee-f980-42e9-bb81-2f27672aecbf
using Plots

# ╔═╡ 23c4b253-f228-47b7-9782-9a528103634a
using ImageShow

# ╔═╡ 229cf869-b2ec-47d8-99eb-1af5fd21cbd7
using PNGFiles

# ╔═╡ 03fcd07b-99d5-4e2d-bc7f-9e00909139c6
using Random

# ╔═╡ e8661f0c-38d7-4c88-9f54-68540f011f5e
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
function tspSwapTS(tour::Array{Int,1}, dist::Array{Float64,2}, tabulist::Array{Array{Int,1},1})
    n, _ = size(dist)

    besti = 0
    bestj = 0
    bestd = +Inf
    for i in 2:n-1, j in i+2:n
        if [tour[i-1], tour[j]] in tabulist
            continue
        end
        if [tour[j], tour[i+1]] in tabulist
            continue
        end
        if [tour[j-1], tour[i]] in tabulist
            continue
        end
        if [tour[i], tour[j+1]] in tabulist
            continue
        end

        dd = 0.0
        dd += dist[tour[i-1], tour[j]] + dist[tour[j], tour[i+1]]
        dd += dist[tour[j-1], tour[i]] + dist[tour[i], tour[j+1]]
        dd -= dist[tour[i-1], tour[i]] + dist[tour[i], tour[i+1]]
        dd -= dist[tour[j-1], tour[j]] + dist[tour[j], tour[j+1]]
        if dd < bestd - eps(Float16)
            besti = i
            bestj = j
            bestd = dd
        end
    end

    if besti == 0 || bestj == 0
        return (nothing, nothing, nothing)
    end

    newtour = copy(tour)
    newtour[besti], newtour[bestj] = newtour[bestj], newtour[besti]

    mov1 = [tour[besti-1], tour[besti]]
    mov2 = [tour[besti], tour[besti+1]]
    mov3 = [tour[bestj-1], tour[bestj]]
    mov4 = [tour[bestj], tour[bestj+1]]

    return (newtour, [mov1, mov2, mov3, mov4], "tspSwapTS")
end

# ╔═╡ 8572781c-d545-4229-ab20-1fbd84678c7e
function tspInsTS(tour::Array{Int,1}, dist::Array{Float64,2}, tabulist::Array{Array{Int,1},1})
    n, _ = size(dist)

    besti = 0
    bestj = 0
    bestd = +Inf
    for i in 2:n-1, j in i+2:n+1
        if [tour[i-1], tour[i+1]] in tabulist
            continue
        end
        if [tour[j-1], tour[i]] in tabulist
            continue
        end
        if [tour[i], tour[j]] in tabulist
            continue
        end

        dd = 0.0
        dd -= dist[tour[i-1], tour[i]] + dist[tour[i], tour[i+1]]
        dd += dist[tour[i-1], tour[i+1]]
        dd -= dist[tour[j-1], tour[j]]
        dd += dist[tour[j-1], tour[i]] + dist[tour[i], tour[j]]
        if dd < bestd - eps(Float16)
            besti = i
            bestj = j
            bestd = dd
        end
    end

    if besti == 0 || bestj == 0
        return (nothing, nothing, nothing)
    end

    newtour = copy(tour)
    insert!(newtour, bestj, newtour[besti])
    deleteat!(newtour, besti)

    mov1 = [tour[besti-1], tour[besti]]
    mov2 = [tour[besti], tour[besti+1]]
    mov3 = [tour[bestj-1], tour[bestj]]

    return (newtour, [mov1, mov2, mov3], "tspInsTS")
end

# ╔═╡ 64cdae57-1a43-4300-9c35-16e94104280f
function tsp2OptTS(tour::Array{Int,1}, dist::Array{Float64,2}, tabulist::Array{Array{Int,1},1})
    n, _ = size(dist)

    besti = 0
    bestj = 0
    bestd = +Inf
    for i in 2:n-1, j in i+1:n
        if [tour[i-1], tour[j]] in tabulist
            continue
        end
        if [tour[i], tour[j+1]] in tabulist
            continue
        end

        dd = dist[tour[i-1], tour[j]] + dist[tour[i], tour[j+1]] - dist[tour[i-1], tour[i]] - dist[tour[j], tour[j+1]]
        if dd < bestd - eps(Float16)
            besti = i
            bestj = j
            bestd = dd
        end
    end

    if besti == 0 || bestj == 0
        return (nothing, nothing, nothing)
    end

    newtour = reverse(tour, besti, bestj)

    mov1 = [tour[besti-1], tour[besti]]
    mov2 = [tour[bestj], tour[bestj+1]]

    return (newtour, [mov1, mov2], "tsp2OptTS")
end

# ╔═╡ d049dd39-4736-4ff0-b2b0-981c61ee3296
md"""
## Tabu Search
"""

# ╔═╡ fab77d3b-203d-4033-bdd0-6ee1ff3cc572
function mhTS(tour::Array{Int,1}, dist::Array{Float64,2}, nbh::Array{Function,1})
    n, _ = size(dist)
    ctour = copy(tour)
    besttour = copy(tour)

    tabulist::Array{Array{Int,1},1} = []
    tabutenure = 7
    maxiter = 10 * n

    busqueda0 = [tspDist(dist, ctour)] # actual ztour
    busqueda1 = copy(busqueda0)        # mejor  ztour
    busquedafn = ["base"]              # actual fn

    for _ in 1:maxiter
        nbh_tour = [nbh_i(ctour, dist, tabulist) for nbh_i in nbh]
        nbh_ztour = []
        for (t, mv1, fn) in nbh_tour
            if t === nothing
                continue
            end
            zt = tspDist(dist, t)
            push!(nbh_ztour, (zt, t, mv1, fn))
        end
        if length(nbh_ztour) == 0
            break
        end

        sort!(nbh_ztour)
        newtourz, newtour, mov1, fn = nbh_ztour[1]

        ctour = newtour
        if newtourz < busqueda1[end]
            besttour = newtour
        end

        for mvi in mov1
            push!(tabulist, mvi)
        end
        while length(tabulist) > tabutenure
            popfirst!(tabulist)
        end

        push!(busqueda0, newtourz)
        if newtourz < busqueda1[end]
            push!(busqueda1, newtourz)
        else
            push!(busqueda1, busqueda1[end])
        end
        push!(busquedafn, fn)

        @show newtourz, fn
    end

    plot(busqueda0)
    plot!(busqueda1)
    savefig(joinpath(@__DIR__, "tsp-plot-TSz.png"))

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

# ╔═╡ cc590562-b6d7-422a-bdfd-267accb8d14a
# nbh::Array{Function,1} = [tspInsTS]
# nbh::Array{Function,1} = [tspSwapTS]
# nbh::Array{Function,1} = [tsp2OptTS]
# nbh::Array{Function,1} = [tspInsTS, tspSwapTS, tsp2OptTS]
# nbh::Array{Function,1} = [tsp2OptTS, tspSwapTS, tspInsTS]
nbh::Array{Function,1} = [tspSwapTS, tspInsTS, tsp2OptTS]

# ╔═╡ fe14fe38-c519-4103-bf59-207cfd2eb402
# tourMH = mhTS(tour, dist, nbh)
tourMH = mhTS(tour, dist, nbh)

# ╔═╡ f5050494-1975-4558-9a1f-2a44b388b3dd
tspPlot(X, Y, tourMH)

# ╔═╡ 0c85af3d-16bc-493c-a4e2-43af9a61026c
PNGFiles.load(joinpath(@__DIR__, "tsp-plot-TSz.png"))

# ╔═╡ Cell order:
# ╟─51bfede6-1436-11ec-0cc6-bfff507e0e99
# ╠═879c42ee-f980-42e9-bb81-2f27672aecbf
# ╠═23c4b253-f228-47b7-9782-9a528103634a
# ╠═229cf869-b2ec-47d8-99eb-1af5fd21cbd7
# ╠═03fcd07b-99d5-4e2d-bc7f-9e00909139c6
# ╟─bc810e37-4517-4a2c-84fb-338ba446915e
# ╠═e8661f0c-38d7-4c88-9f54-68540f011f5e
# ╟─c7c9a12f-f3ab-4251-888d-d1ac9b87aa60
# ╠═e44f264e-e87d-4498-b89a-cdd8519eddd1
# ╠═8572781c-d545-4229-ab20-1fbd84678c7e
# ╠═64cdae57-1a43-4300-9c35-16e94104280f
# ╟─d049dd39-4736-4ff0-b2b0-981c61ee3296
# ╠═fab77d3b-203d-4033-bdd0-6ee1ff3cc572
# ╟─b03019d3-0270-45d8-ab5e-fcfb8d20dbc6
# ╠═3f648c67-e281-406e-8953-28c6f138280c
# ╠═cc590562-b6d7-422a-bdfd-267accb8d14a
# ╠═fe14fe38-c519-4103-bf59-207cfd2eb402
# ╠═f5050494-1975-4558-9a1f-2a44b388b3dd
# ╠═0c85af3d-16bc-493c-a4e2-43af9a61026c
