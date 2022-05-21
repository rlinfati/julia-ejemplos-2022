### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ e7262522-ac65-11ec-0633-1d82420161db
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("GLPK")
        Pkg.PackageSpec("Plots")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ e726254a-ac65-11ec-2f4c-1bead54e006a
using JuMP

# ╔═╡ a28468d5-b6fd-42d1-856f-4b9a8198a4fa
using GLPK

# ╔═╡ e6902e75-32f3-4c61-b564-24ce502f7025
using Plots

# ╔═╡ bb4218e4-06f0-482b-9ab6-55fedd51d429
using Random

# ╔═╡ 66bea84e-7574-494c-abcf-eb8d092e778c
md"""
# Traveling Salesman Problem
"""

# ╔═╡ 4e21d0be-afd3-4e02-84a4-f4a39a2d712f
md"""
## Lectura/Generacion de Instancia
"""

# ╔═╡ f9cb6029-062b-436e-968b-9e8e4dd7b8f6
begin
    n = 7
    rng = Random.MersenneTwister(1234)
    X = rand(rng, n) * 1_000.0
    Y = rand(rng, n) * 1_000.0
    nothing
end

# ╔═╡ 72b74a0b-e001-445f-9c65-995c69854951
md"""
## Calculo de parametros
"""

# ╔═╡ c2a2b9e2-170f-44eb-be42-ea3219836e91
d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:n, j in 1:n]

# ╔═╡ 249acea1-9778-4e03-9a7e-5636054c3f06
md"""
## Modelo MTZ
"""

# ╔═╡ 3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
begin
    m = JuMP.Model()

    @variable(m, x[1:n, 1:n], Bin)

    @objective(m, Min, sum(d .* x))

    @constraint(m, r0[i in 1:n], x[i, i] == 0) # FIX
    @constraint(m, r1[i in 1:n], sum(x[i, :]) == 1)
    @constraint(m, r2[j in 1:n], sum(x[:, j]) == 1)

    # SEC
    for a in 1:n, b in a+1:n
        s = [a, b]
        @constraint(m, sum(x[i, j] for i in s, j in s) <= length(s) - 1)
    end

    nothing
end

# ╔═╡ 48e6f211-27a6-42a2-8c4a-4352863da1fa
JuMP.latex_formulation(m);

# ╔═╡ fff51859-5a07-4c3b-881c-06fe01211aeb
"""
Función myCallbackUserCut: genera planos de corte para el branch-and-bound
"""
function myCallbackUserCut(cb_data)
    ret = callback_node_status(cb_data, m)
    # @show "C", ret

    xval = JuMP.callback_value.(cb_data, m[:x])

    for a in 1:n, b in a+1:n, c in b+1:n
        s = [a, b, c]
        sums = sum(xval[i, j] for i in s, j in s)

        if sums <= length(s) - 1 + eps(Float16)
            continue
        end

        @show "c", sums, s
        con = @build_constraint(sum(m[:x][i, j] for i in s, j in s) <= length(s) - 1)
        ret = MOI.submit(m, MOI.UserCut(cb_data), con)
    end

    return
end

# ╔═╡ 4df28073-a8ce-41d2-8178-ef3c29f3b8f7
"""
Función tspDist: dada una matriz de distancia y un tour factible, calcula la distancia total
"""
function tspDist(dist::Array{Float64,2}, tour::Array{Int,1})
    n, _ = size(dist)

    f = tour[1] == tour[end] && sort(tour[1:(end-1)]) == 1:n
    if f == false
        return +Inf
    end

    totalDist = sum(dist[tour[i], tour[i+1]] for i in 1:n)
    return totalDist
end

# ╔═╡ 702938a7-922b-46e5-b0ba-bf977a02ac83
"""
Función tspCWs: dada una matriz de distancia, calcula un tour factible.
"""
function tspCWs(dist::Array{Float64,2}, lamda::Float64 = 1.0, s::Int = 0)
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

# ╔═╡ 523d44ac-351f-4386-915a-b8eaa39f10e2
"""
Función tsp2Opt: dado un tour factible, y una una matriz de distancia, calcula un tour 2-OPT mejorado
"""
function tsp2Opt(tour::Array{Int,1}, dist::Array{Float64,2}, sf::Bool = false)
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

# ╔═╡ e858baeb-4a31-4101-a45e-ee3834eb4cf6
"""
Función mhLocalSearch1: dado un tour factible, y una una matriz de distancia, calcula un tour optimo local
"""
function mhLocalSearch1(tour::Array{Int,1}, dist::Array{Float64,2}, sf::Bool = false)
    ctour = copy(tour)
    busqueda0 = [tspDist(dist, ctour)] # actual ztour

    while true
        newtour = tsp2Opt(ctour, dist, sf)
        if newtour === nothing
            break
        end

        newtourz = tspDist(dist, newtour)

        if newtourz < busqueda0[end]
            push!(busqueda0, newtourz)
            ctour = newtour
        else
            break
        end
    end

    return ctour
end

# ╔═╡ 2edd33de-ebd4-484c-a45b-3fe7c6beb597
md"""
### Parametros del Solver y Optimización
"""

# ╔═╡ 388b624b-b9c1-4477-8726-a2e4c57a5566
global cbh_firstrun = Ref{Bool}(true)

# ╔═╡ 8ae5ac06-b797-4235-a841-9793f867078f
global tourLz = Ref{Float64}(sum(d))

# ╔═╡ f1445740-6449-4e3c-9b2b-cc47be199fc1
global tourL = Ref{Array{Int}}(Int[])

# ╔═╡ 7b9ba7f4-2281-4d81-86bb-a5b71e10e887
"""
Función myCallbackLazyConstraint: genera restricciones adicionales para el branch-and-bound
"""
function myCallbackLazyConstraint(cb_data)
    ret = callback_node_status(cb_data, m)
    # @show "L", ret
    if ret == JuMP.MOI.CALLBACK_NODE_STATUS_FRACTIONAL
        return
    end

    xval = JuMP.callback_value.(cb_data, m[:x])

    aVisitar = collect(1:n)
    while !isempty(aVisitar)
        s = Int[aVisitar[1]]
        while true
            proxID = argmax(xval[s[end], aVisitar])

            if s[1] != aVisitar[proxID]
                push!(s, aVisitar[proxID])
                deleteat!(aVisitar, proxID)
            else
                deleteat!(aVisitar, proxID)
                break
            end
        end

        if length(s) == n
            ss = [s..., s[1]]
            zTSP = tspDist(d, ss)
            if zTSP < tourLz[]
                tourLz[] = zTSP
                tourL[] = ss
            end
            return
        end

        @show "l", length(s), s
        con = @build_constraint(sum(m[:x][i, j] for i in s, j in s) <= length(s) - 1)
        MOI.submit(m, MOI.LazyConstraint(cb_data), con)
    end
    return
end

# ╔═╡ f2f892e0-52ef-4945-a8b7-36e4fb15b44f
"""
Función myCallbackHeuristic: genera una solucion heuristica para el branch-and-bound
"""
function myCallbackHeuristic(cb_data)
    ret = callback_node_status(cb_data, m)
    # @show "H", ret

    if cbh_firstrun[]
        tour = tspCWs(d)
        tour = mhLocalSearch1(tour, d)

        xval = zeros(n, n)
        for i in 1:n
            xval[tour[i], tour[i+1]] = 1.0
        end

        ret = MOI.submit(m, MOI.HeuristicSolution(cb_data), x[:], xval[:])
        println("** myCallbackHeuristic0 status = $(ret)")

        cbh_firstrun[] = false
    end

    if length(tourL[]) == n + 1
        tour = mhLocalSearch1(tourL[], d)
        tourz = tspDist(d, tour)

        if tourz < tourLz[]
            xval = zeros(n, n)
            for i in 1:n
                xval[tour[i], tour[i+1]] = 1.0
            end

            ret = MOI.submit(m, MOI.HeuristicSolution(cb_data), x[:], xval[:])
            println("** myCallbackHeuristicL status = $(ret)")
        end
        tourLz[] = tourz - eps(Float16)
        tourL[] = Int[]
    end

    return
end

# ╔═╡ d1b599d9-da3a-4070-90dc-e63532951fd6
begin
    cbh_firstrun[] = true
    tourLz[] = sum(sum(maximum(d, dims = 2)))
    tourL[] = Int[]

    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)

    JuMP.MOI.set(m, JuMP.MOI.LazyConstraintCallback(), myCallbackLazyConstraint)
    JuMP.MOI.set(m, JuMP.MOI.UserCutCallback(), myCallbackUserCut)
    JuMP.MOI.set(m, JuMP.MOI.HeuristicCallback(), myCallbackHeuristic)

    JuMP.optimize!(m)
end

# ╔═╡ d1c1c450-c0d7-4427-b73e-795e0b5387fa
md"""
### Estado del Solver
"""

# ╔═╡ fc925cdf-ffd8-45ad-a7a9-4c11228fac02
JuMP.solution_summary(m)

# ╔═╡ 21cc515d-d381-445f-a23a-4bc75c81e38c
md"""
### Solución del Solver
"""

# ╔═╡ 2fd0b79d-4740-45aa-a63d-95d2fb41ad81
xval = JuMP.value.(x) .> 1.0 - eps(Float16)

# ╔═╡ ddd6790a-7597-4983-909d-41c11b24110c
md"""
### Solución gráfica
"""

# ╔═╡ c806912b-8bec-4d41-a7f3-0c7654a4ed53
begin
    tour = Int[1]
    while true
        push!(tour, argmax(xval[tour[end], :]))
        if tour[end] == 1
            break
        end
    end
    tour
end

# ╔═╡ dc506999-2c80-42ed-a2c2-84b6aad636d2
sum(d[tour[i], tour[i+1]] for i in 1:n)

# ╔═╡ c2c05477-7c33-480f-b88f-c173487a4a4c
begin
    p = plot(legend = false)
    scatter!(X, Y, color = :blue)

    for i in 1:n
        annotate!(X[i], Y[i], text("$i", :top))
    end

    plot!(X[tour], Y[tour], color = :black)
end

# ╔═╡ Cell order:
# ╟─e7262522-ac65-11ec-0633-1d82420161db
# ╠═e726254a-ac65-11ec-2f4c-1bead54e006a
# ╠═a28468d5-b6fd-42d1-856f-4b9a8198a4fa
# ╠═e6902e75-32f3-4c61-b564-24ce502f7025
# ╠═bb4218e4-06f0-482b-9ab6-55fedd51d429
# ╟─66bea84e-7574-494c-abcf-eb8d092e778c
# ╟─4e21d0be-afd3-4e02-84a4-f4a39a2d712f
# ╠═f9cb6029-062b-436e-968b-9e8e4dd7b8f6
# ╟─72b74a0b-e001-445f-9c65-995c69854951
# ╠═c2a2b9e2-170f-44eb-be42-ea3219836e91
# ╟─249acea1-9778-4e03-9a7e-5636054c3f06
# ╠═3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
# ╠═48e6f211-27a6-42a2-8c4a-4352863da1fa
# ╟─7b9ba7f4-2281-4d81-86bb-a5b71e10e887
# ╟─fff51859-5a07-4c3b-881c-06fe01211aeb
# ╟─4df28073-a8ce-41d2-8178-ef3c29f3b8f7
# ╟─702938a7-922b-46e5-b0ba-bf977a02ac83
# ╟─523d44ac-351f-4386-915a-b8eaa39f10e2
# ╟─e858baeb-4a31-4101-a45e-ee3834eb4cf6
# ╟─f2f892e0-52ef-4945-a8b7-36e4fb15b44f
# ╟─2edd33de-ebd4-484c-a45b-3fe7c6beb597
# ╠═388b624b-b9c1-4477-8726-a2e4c57a5566
# ╠═8ae5ac06-b797-4235-a841-9793f867078f
# ╠═f1445740-6449-4e3c-9b2b-cc47be199fc1
# ╠═d1b599d9-da3a-4070-90dc-e63532951fd6
# ╟─d1c1c450-c0d7-4427-b73e-795e0b5387fa
# ╠═fc925cdf-ffd8-45ad-a7a9-4c11228fac02
# ╟─21cc515d-d381-445f-a23a-4bc75c81e38c
# ╠═2fd0b79d-4740-45aa-a63d-95d2fb41ad81
# ╟─ddd6790a-7597-4983-909d-41c11b24110c
# ╠═c806912b-8bec-4d41-a7f3-0c7654a4ed53
# ╠═dc506999-2c80-42ed-a2c2-84b6aad636d2
# ╠═c2c05477-7c33-480f-b88f-c173487a4a4c
