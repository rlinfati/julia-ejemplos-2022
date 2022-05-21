### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 413d6f34-d13a-47dd-b711-98d81f50f55e
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 03fcd07b-99d5-4e2d-bc7f-9e00909139c6
using Random

# ╔═╡ bc810e37-4517-4a2c-84fb-338ba446915e
md"""
# Traveling Salesman Problem
"""

# ╔═╡ ff026811-1b89-4d71-ae44-83b107c59fe0
md"""
## Funciones generadoras de puntos
"""

# ╔═╡ c60e8f45-25a7-4fd0-b44c-92ad103de291
function tspXYRand(n::Int; myseed::Int = 1234)
    rng = Random.MersenneTwister(myseed)
    X = rand(rng, n) * 1_000.0
    Y = rand(rng, n) * 1_000.0
    return X, Y
end

# ╔═╡ f0aaaa34-ddea-44e4-b300-710b5faae568
function tspXYCluster(n::Int; myseed::Int = 1234)
    rng = Random.MersenneTwister(myseed)

    cs = rand(rng, 3:8)
    X = rand(rng, n) * 1_000.0
    Y = rand(rng, n) * 1_000.0

    for i in (cs+1):n
        while true
            dps = sum(exp(-sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) / 40.0) for j in 1:cs)

            if rand(rng) < dps
                break
            end

            X[i] = rand(rng) * 1_000.0
            Y[i] = rand(rng) * 1_000.0
        end
    end
    return X, Y
end

# ╔═╡ 4b447fe9-6ea8-420e-a99b-123029ef7193
md"""
## Funciones generadoras de costos
"""

# ╔═╡ 38dc2e2f-a01e-4cbc-a00f-1a771c81c4a7
function distEuclidean(X::Array{Float64,1}, Y::Array{Float64,1})
    n = length(X)
    dist = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:n, j in 1:n]
    return dist
end

# ╔═╡ b13f25a1-49c2-4596-9fec-53be6255a539
function distManhattan(X::Array{Float64,1}, Y::Array{Float64,1})
    n = length(X)
    dist = [abs(X[i] - X[j]) + abs(Y[i] - Y[j]) for i in 1:n, j in 1:n]
    return dist
end

# ╔═╡ 59065652-6e33-49cf-b2e1-4fbcecca7303
function distMaximum(X::Array{Float64,1}, Y::Array{Float64,1})
    n = length(X)
    dist = [max(abs(X[i] - X[j]), abs(Y[i] - Y[j])) for i in 1:n, j in 1:n]
    return dist
end

# ╔═╡ 6dc338b9-2d3c-40fa-99ae-68fb5ab865b1
function distGeographical(X::Array{Float64,1}, Y::Array{Float64,1})
    n = length(X)
    # xy = DDD.MM format
    # dist = GEO from TSPLIB
    lat = floor.(X)
    lat += (X - lat) * 5.0 / 3.0
    lat *= π / 180.0

    lon = floor.(Y)
    lon += (Y - lon) * 5.0 / 3.0
    lon *= π / 180.0

    q1 = [cos(lon[i] - lon[j]) for i in 1:n, j in 1:n]
    q2 = [cos(lat[i] - lat[j]) for i in 1:n, j in 1:n]
    q3 = [cos(lat[i] + lat[j]) for i in 1:n, j in 1:n]

    rrr = 6378.388

    dist = 0.5 * ((1.0 .+ q1) .* q2 - (1.0 .- q1) .* q3)
    dist = rrr * acos.(dist)

    return dist
end

# ╔═╡ 9fa4538a-6ce3-4e69-9622-a9e54651dd6b
md"""
## Funciones auxiliares
"""

# ╔═╡ c5dfb1f9-5e57-4f4d-a7fc-cf545a7adac0
function tspPlot(X::Array{Float64,1}, Y::Array{Float64,1}, tour::Array{Int,1})
    n = length(X)

    plot(legend = false)
    scatter!(X, Y, color = :blue)
    for i in 1:n
        annotate!(X[i], Y[i], text("$i", :top))
    end

    plot!(X[tour], Y[tour], color = :black)

    return plot!()
end

# ╔═╡ c68dbb41-a898-4fd2-885b-9aebed12ef5e
function tspDist(dist::Array{Float64,2}, tour::Array{Int,1})
    n, _ = size(dist)

    f = tour[1] == tour[end] && sort(tour[1:(end-1)]) == 1:n
    if f == false
        return +Inf
    end

    totalDist = sum(dist[tour[i], tour[i+1]] for i in 1:n)
    return totalDist
end

# ╔═╡ f27ecd84-fe5e-46e3-8388-6c7a02133955
md"""
## Heuristicas
"""

# ╔═╡ f264e1c9-a4ba-4b0e-ae3e-83ea4fa7f23c
function tspRND(dist::Array{Float64,2})
    n, _ = size(dist)

    tour = randperm(n)
    push!(tour, tour[1])

    return tour
end

# ╔═╡ 9fcc8ac3-f50a-4b24-be7e-6b2c5411ef2c
function tspNN(dist::Array{Float64,2}; s::Int = 0)
    n, _ = size(dist)

    if s == 0
        s = rand(1:n)
    end
    @assert 1 <= s <= n

    tour = Int[s]
    aVisitar = collect(1:n)
    deleteat!(aVisitar, s)

    while !isempty(aVisitar)
        proxID = argmin(dist[tour[end], aVisitar])
        push!(tour, aVisitar[proxID])
        deleteat!(aVisitar, proxID)
    end
    push!(tour, s)

    return tour
end

# ╔═╡ e0603161-bf93-416e-be83-e217f474cd99
function tspCI(dist::Array{Float64,2}; s::Int = 0)
    n, _ = size(dist)

    # Heuristica Insercion mas barata
    if s == 0
        s = rand(1:n)
    end
    @assert 1 <= s <= n

    tour = Int[]
    push!(tour, s)
    push!(tour, s)

    aVisitar = collect(1:n)
    deleteat!(aVisitar, s)

    while !isempty(aVisitar)
        bestJ = 0
        bestK = 0

        f(idx, k) = dist[tour[idx], k] + dist[k, tour[idx+1]] - dist[tour[idx], tour[idx+1]]
        m = [f(idx, k) for idx in 1:(length(tour)-1), k in aVisitar]

        x = argmin(m)
        bestJ = x[1] + 1
        bestK = aVisitar[x[2]]

        insert!(tour, bestJ, bestK)
        setdiff!(aVisitar, bestK)
    end

    return tour
end

# ╔═╡ 56aefeb3-86a8-43ae-9d21-02d76edca91d
function tspCWs(dist::Array{Float64,2}; lamda::Float64 = 1.0, s::Int = 0)
    n, _ = size(dist)

    # Heuristica de los ahorros
    if s == 0
        s = rand(1:n)
    end
    @assert 1 <= s <= n

    ahorro = [(dist[i, s] + dist[s, j] - lamda * dist[i, j], i, j) for i in 1:n for j in (i+1):n]
    sort!(ahorro, rev = true)
    visitado = zeros(Int, n)

    tour = [ahorro[1][2]; ahorro[1][3]]

    visitado[s] = 1
    visitado[tour[1]] = 1
    visitado[tour[2]] = 1
    visitado[s] = 1

    while sum(visitado) < n
        for (_, i, j) in ahorro
            if visitado[i] + visitado[j] != 1
                continue
            end

            if tour[1] == i
                pushfirst!(tour, j)
                visitado[j] = 1
            elseif tour[1] == j
                pushfirst!(tour, i)
                visitado[i] = 1
            elseif tour[end] == i
                push!(tour, j)
                visitado[j] = 1
            elseif tour[end] == j
                push!(tour, i)
                visitado[i] = 1
            else
                continue
            end

            break
        end
    end

    pushfirst!(tour, s)
    push!(tour, s)

    return tour
end

# ╔═╡ 6c684a38-07b2-4559-b5e4-58de72a0e44e
function tspCWp(dist::Array{Float64,2}; lamda::Float64 = 1.0, s::Int = 0)
    n, _ = size(dist)

    # Heuristica de los ahorros
    if s == 0
        s = rand(1:n)
    end
    @assert 1 <= s <= n

    ahorro = [(dist[i, s] + dist[s, j] - lamda * dist[i, j], i, j) for i in 1:n for j in (i+1):n]
    sort!(ahorro, rev = true)

    visitado = zeros(n)
    paths = []

    while sum(visitado) < n || length(paths) > 1
        for (_, i, j) in ahorro
            if visitado[i] + visitado[j] == 0
                push!(paths, [i, j])
                visitado[i] = visitado[j] = 1
            elseif visitado[i] + visitado[j] == 1
                for p in paths
                    if p[1] == i
                        pushfirst!(p, j)
                        visitado[j] = 1
                    elseif p[1] == j
                        pushfirst!(p, i)
                        visitado[i] = 1
                    elseif p[end] == i
                        push!(p, j)
                        visitado[j] = 1
                    elseif p[end] == j
                        push!(p, i)
                        visitado[i] = 1
                    end
                end
            elseif visitado[i] + visitado[j] == 2
                v1 = findfirst(p -> p[1] == i, paths)
                v1s = true
                if v1 === nothing
                    v1 = findfirst(p -> p[end] == i, paths)
                    v1s = false
                end
                if v1 === nothing
                    continue
                end

                v2 = findfirst(p -> p[1] == j, paths)
                v2s = true
                if v2 === nothing
                    v2 = findfirst(p -> p[end] == j, paths)
                    v2s = false
                end
                if v2 === nothing
                    continue
                end

                if v1 == v2
                    continue
                end

                vn = Int[]
                if v1s == true && v2s == true
                    vn = [reverse(paths[v1]); paths[v2]]
                elseif v1s == true && v2s == false
                    vn = [paths[v2]; paths[v1]]
                elseif v1s == false && v2s == true
                    vn = [paths[v1]; paths[v2]]
                elseif v1s == false && v2s == false
                    vn = [paths[v1]; reverse(paths[v2])]
                end
                push!(paths, vn)
                deleteat!(paths, max(v1, v2))
                deleteat!(paths, min(v1, v2))
            end
        end
    end

    tour = paths[1]
    push!(tour, tour[1])

    return tour
end

# ╔═╡ 43e6c712-d693-48af-98c2-2ebf95467b3d
nothing

# ╔═╡ Cell order:
# ╟─413d6f34-d13a-47dd-b711-98d81f50f55e
# ╠═03fcd07b-99d5-4e2d-bc7f-9e00909139c6
# ╟─bc810e37-4517-4a2c-84fb-338ba446915e
# ╟─ff026811-1b89-4d71-ae44-83b107c59fe0
# ╠═c60e8f45-25a7-4fd0-b44c-92ad103de291
# ╠═f0aaaa34-ddea-44e4-b300-710b5faae568
# ╟─4b447fe9-6ea8-420e-a99b-123029ef7193
# ╠═38dc2e2f-a01e-4cbc-a00f-1a771c81c4a7
# ╠═b13f25a1-49c2-4596-9fec-53be6255a539
# ╠═59065652-6e33-49cf-b2e1-4fbcecca7303
# ╠═6dc338b9-2d3c-40fa-99ae-68fb5ab865b1
# ╟─9fa4538a-6ce3-4e69-9622-a9e54651dd6b
# ╠═c5dfb1f9-5e57-4f4d-a7fc-cf545a7adac0
# ╠═c68dbb41-a898-4fd2-885b-9aebed12ef5e
# ╟─f27ecd84-fe5e-46e3-8388-6c7a02133955
# ╠═f264e1c9-a4ba-4b0e-ae3e-83ea4fa7f23c
# ╠═9fcc8ac3-f50a-4b24-be7e-6b2c5411ef2c
# ╠═e0603161-bf93-416e-be83-e217f474cd99
# ╠═56aefeb3-86a8-43ae-9d21-02d76edca91d
# ╠═6c684a38-07b2-4559-b5e4-58de72a0e44e
# ╠═43e6c712-d693-48af-98c2-2ebf95467b3d
