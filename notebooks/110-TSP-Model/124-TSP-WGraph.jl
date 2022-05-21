### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ e7262522-ac65-11ec-0633-1d82420161db
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add(
        [
            Pkg.PackageSpec("JuMP")
            Pkg.PackageSpec("GLPK")
            Pkg.PackageSpec("Plots")
            Pkg.PackageSpec("Graphs")
            Pkg.PackageSpec("SimpleWeightedGraphs")
            Pkg.PackageSpec("GraphPlot")
        ],
    )
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

# ╔═╡ 70f14c5a-0809-426d-a8a0-7dee755da648
using Graphs

# ╔═╡ 94e5017d-0bf4-411c-b7f7-abdc8d5fc961
using SimpleWeightedGraphs

# ╔═╡ 2f6763ba-366f-48d4-85c6-df7a12e57242
using GraphPlot

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

# ╔═╡ 7ce03388-585e-4b78-8dfe-52d2c8ba8602
md"""
## Grafo G
"""

# ╔═╡ 4573d40c-957f-4834-829d-53943421b73d
G = SimpleWeightedDiGraph(d)

# ╔═╡ 1dbce19b-79af-49c5-b366-740f1d350f80
[(e.src, e.dst, e.weight) for e in edges(G)]

# ╔═╡ 99280caa-ff78-44e9-93ee-d657ad578e9a
gplot(G, X, -Y, nodelabel = vertices(G), edgelabel = [e.weight for e in edges(G)])

# ╔═╡ 249acea1-9778-4e03-9a7e-5636054c3f06
md"""
## Modelo MTZ
"""

# ╔═╡ 3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
begin
    Node = vertices(G)
    Nod2 = setdiff(Node, first(Node))
    Arcs = edges(G)

    m = JuMP.Model()

    @variable(m, x[Arcs], Bin)
    @variable(m, f[Arcs] >= 0)

    @objective(m, Min, sum(e.weight * x[e] for e in Arcs))

    @constraint(m, r1[i in Node], sum(x[e] for e in Arcs if e.src == i) == 1)
    @constraint(m, r2[j in Node], sum(x[e] for e in Arcs if e.dst == j) == 1)

    @constraint(m, r3, sum(f[e] for e in Arcs if e.src == 1) == n)
    @constraint(m, r4, sum(f[e] for e in Arcs if e.dst == 1) == 1)
    @constraint(m, r5[e in Arcs], x[e] <= f[e])
    @constraint(m, r6[e in Arcs], f[e] <= n * x[e])
    @constraint(m, r7[k in Nod2], sum(f[e] for e in Arcs if e.dst == k) == 1 + sum(f[e] for e in Arcs if e.src == k))

    nothing
end

# ╔═╡ 48e6f211-27a6-42a2-8c4a-4352863da1fa
JuMP.latex_formulation(m);

# ╔═╡ 2edd33de-ebd4-484c-a45b-3fe7c6beb597
md"""
### Parametros del Solver y Optimización
"""

# ╔═╡ d1b599d9-da3a-4070-90dc-e63532951fd6
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
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
xval = JuMP.value.(x) .≈ 1.0

# ╔═╡ 24683b46-ecc8-487c-81ec-5dff1e28dd87
fval = round.(Int, JuMP.value.(f))

# ╔═╡ 8a08b116-152a-40d5-9c28-b1a0c3524aa6
t = [e for e in Arcs if xval[e]]

# ╔═╡ 773c8409-3e01-4944-8ba4-0442b8a2368d
sum(weight.(t))

# ╔═╡ ddd6790a-7597-4983-909d-41c11b24110c
md"""
### Solución gráfica
"""

# ╔═╡ c2c05477-7c33-480f-b88f-c173487a4a4c
begin
    p = plot(legend = false)
    scatter!(X, Y, color = :blue)

    for i in Node
        annotate!(X[i], Y[i], text("$i", :top))
    end

    for e in t
        e = [e.src; e.dst]
        plot!(X[e], Y[e], color = :black)
    end

    p
end

# ╔═╡ d6bf3ba9-3fa4-4257-bab0-1f2605a6585e
md"""
### calculo del vector tour
"""

# ╔═╡ c806912b-8bec-4d41-a7f3-0c7654a4ed53
begin
    tour = Int[1]
    while true
        push!(tour, filter(e -> e.src == tour[end], t)[1].dst)
        if tour[end] == 1
            break
        end
    end
    tour
end

# ╔═╡ c4da83d1-4e75-45c6-b380-496f73fd48d9
sum(d[tour[i], tour[i+1]] for i in 1:n)

# ╔═╡ 647314fe-e2b1-4e6a-923c-2811ceed01ba
begin
    p2 = plot(legend = false)
    scatter!(X, Y, color = :blue)

    for i in Node
        annotate!(X[i], Y[i], text("$i", :top))
    end

    plot!(X[tour], Y[tour], color = :black)
end

# ╔═╡ Cell order:
# ╟─e7262522-ac65-11ec-0633-1d82420161db
# ╠═e726254a-ac65-11ec-2f4c-1bead54e006a
# ╠═a28468d5-b6fd-42d1-856f-4b9a8198a4fa
# ╠═e6902e75-32f3-4c61-b564-24ce502f7025
# ╠═70f14c5a-0809-426d-a8a0-7dee755da648
# ╠═94e5017d-0bf4-411c-b7f7-abdc8d5fc961
# ╠═2f6763ba-366f-48d4-85c6-df7a12e57242
# ╠═bb4218e4-06f0-482b-9ab6-55fedd51d429
# ╟─66bea84e-7574-494c-abcf-eb8d092e778c
# ╟─4e21d0be-afd3-4e02-84a4-f4a39a2d712f
# ╠═f9cb6029-062b-436e-968b-9e8e4dd7b8f6
# ╟─72b74a0b-e001-445f-9c65-995c69854951
# ╠═c2a2b9e2-170f-44eb-be42-ea3219836e91
# ╟─7ce03388-585e-4b78-8dfe-52d2c8ba8602
# ╠═4573d40c-957f-4834-829d-53943421b73d
# ╠═1dbce19b-79af-49c5-b366-740f1d350f80
# ╠═99280caa-ff78-44e9-93ee-d657ad578e9a
# ╟─249acea1-9778-4e03-9a7e-5636054c3f06
# ╠═3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
# ╠═48e6f211-27a6-42a2-8c4a-4352863da1fa
# ╟─2edd33de-ebd4-484c-a45b-3fe7c6beb597
# ╠═d1b599d9-da3a-4070-90dc-e63532951fd6
# ╟─d1c1c450-c0d7-4427-b73e-795e0b5387fa
# ╠═fc925cdf-ffd8-45ad-a7a9-4c11228fac02
# ╟─21cc515d-d381-445f-a23a-4bc75c81e38c
# ╠═2fd0b79d-4740-45aa-a63d-95d2fb41ad81
# ╠═24683b46-ecc8-487c-81ec-5dff1e28dd87
# ╠═8a08b116-152a-40d5-9c28-b1a0c3524aa6
# ╠═773c8409-3e01-4944-8ba4-0442b8a2368d
# ╟─ddd6790a-7597-4983-909d-41c11b24110c
# ╠═c2c05477-7c33-480f-b88f-c173487a4a4c
# ╟─d6bf3ba9-3fa4-4257-bab0-1f2605a6585e
# ╠═c806912b-8bec-4d41-a7f3-0c7654a4ed53
# ╠═c4da83d1-4e75-45c6-b380-496f73fd48d9
# ╠═647314fe-e2b1-4e6a-923c-2811ceed01ba
