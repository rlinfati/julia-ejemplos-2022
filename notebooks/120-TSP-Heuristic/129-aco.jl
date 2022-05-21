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

# ╔═╡ 9b8872d8-9b2d-4a1f-82e2-2e536d8912ba
using Plots

# ╔═╡ 0a1a2649-7bf7-4283-b070-70aa59e78574
using ImageShow

# ╔═╡ 9c76635e-22dd-42c3-b6a3-6b9db9425d8f
using PNGFiles

# ╔═╡ d7286808-faad-4652-b2e2-27b77bf63e61
using Random

# ╔═╡ 03fcd07b-99d5-4e2d-bc7f-9e00909139c6
using Statistics

# ╔═╡ 1ab100b4-0bc2-4273-8e70-9befd6d073e2
include(joinpath(@__DIR__, "120-functions.jl"))

# ╔═╡ bc810e37-4517-4a2c-84fb-338ba446915e
md"""
# Traveling Salesman Problem
"""

# ╔═╡ 6ef09464-2e99-43c3-99e9-af732d04db80
md"""
## Ant Colony Optimization
"""

# ╔═╡ 8c2906e8-9656-44d2-89c4-0a5c2061440f
function mhACO(dist::Array{Float64,2}; s::Int = 0)
    n, _ = size(dist)
    if s == 0
        s = rand(1:n)
    end
    @assert 1 <= s <= n

    alpha = 1.0
    betha = 1.0
    rho = 0.20
    qfer = 100.0

    nHormigas = 2 * n
    maxiter = 10 * n

    tau::Array{Float64,2} = ones(n, n)
    eta::Array{Float64,2} = mean(dist) ./ dist
    for i in 1:n
        eta[i, i] = eps()
    end

    busqueda0 = [] # promedio ztour
    busqueda1 = [] # mejor    ztour
    mejortour = [0]

    for _ in 1:maxiter
        tours = []
        for _ in 1:nHormigas
            tour = Int[s]

            novisited = ones(n)
            novisited[s] = 0.0

            while sum(novisited) > 0.0
                pxy = tau[tour[end], :] .^ alpha .* eta[tour[end], :] .^ betha .* novisited
                pxy = pxy ./ sum(pxy)

                next = 0
                cspxy = cumsum(pxy)
                r = rand()

                for i in 1:n
                    if novisited[i] ≈ 0.0
                        continue
                    end
                    if r < cspxy[i]
                        next = i
                        break
                    end
                end
                @assert next != 0

                push!(tour, next)
                novisited[next] = 0.0
            end
            push!(tour, tour[1])
            push!(tours, tour)
        end

        zt = [tspDist(dist, i) for i in tours]
        push!(busqueda0, mean(zt))
        push!(busqueda1, minimum(zt))

        bestID = argmin(zt)
        if zt[bestID] < tspDist(dist, mejortour)
            mejortour = tours[bestID]
        end

        tau *= 1 - rho
        for h in 1:nHormigas
            up = qfer / tspDist(dist, tours[h])
            for p in 1:n
                i = tours[h][p]
                j = tours[h][p+1]
                tau[i, j] += up
            end
        end
    end

    plot(busqueda0)
    plot!(busqueda1)
    savefig(joinpath(@__DIR__, "tsp-plot-ACOz.png"))

    return mejortour
end

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

# ╔═╡ e25019e0-3c89-4dc9-8adc-96900affe702
tourMH = mhACO(dist)

# ╔═╡ f5050494-1975-4558-9a1f-2a44b388b3dd
tspPlot(X, Y, tourMH)

# ╔═╡ 1e099701-6fd7-42d3-a76e-0077c4c8a174
PNGFiles.load(joinpath(@__DIR__, "tsp-plot-ACOz.png"))

# ╔═╡ Cell order:
# ╟─51bfede6-1436-11ec-0cc6-bfff507e0e99
# ╠═9b8872d8-9b2d-4a1f-82e2-2e536d8912ba
# ╠═0a1a2649-7bf7-4283-b070-70aa59e78574
# ╠═9c76635e-22dd-42c3-b6a3-6b9db9425d8f
# ╠═d7286808-faad-4652-b2e2-27b77bf63e61
# ╠═03fcd07b-99d5-4e2d-bc7f-9e00909139c6
# ╟─bc810e37-4517-4a2c-84fb-338ba446915e
# ╠═1ab100b4-0bc2-4273-8e70-9befd6d073e2
# ╟─6ef09464-2e99-43c3-99e9-af732d04db80
# ╠═8c2906e8-9656-44d2-89c4-0a5c2061440f
# ╟─b03019d3-0270-45d8-ab5e-fcfb8d20dbc6
# ╠═3f648c67-e281-406e-8953-28c6f138280c
# ╠═e25019e0-3c89-4dc9-8adc-96900affe702
# ╠═f5050494-1975-4558-9a1f-2a44b388b3dd
# ╠═1e099701-6fd7-42d3-a76e-0077c4c8a174
