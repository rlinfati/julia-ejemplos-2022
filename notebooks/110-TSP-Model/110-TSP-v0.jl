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
    n = 10
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

    nothing
end

# ╔═╡ 2a400f11-eb28-40b0-9255-d6c9a301309d
subtour = [[1, 5], [1, 5, 10, 4, 8], [1, 5, 6, 2, 3, 9, 7, 8], [1, 5, 10, 4]]

# ╔═╡ 32b24383-6f75-494d-99a7-304b9a026d2d
for st in subtour
    @constraint(m, sum(x[i, j] for i in st, j in st) <= length(st) - 1)
end

# ╔═╡ 45e939e2-af03-45d3-9978-54eebc803b04
[[8, 4, 10], [1, 5], [7, 9], [3, 2, 6], [2, 6], [7, 9, 3], [4, 10, 5, 1, 8], [4, 10], [1, 5, 6, 2, 3, 9, 7, 8]]

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

# ╔═╡ ea89fc90-dacd-4f90-852b-a9eb3bce0450
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
# ╠═2a400f11-eb28-40b0-9255-d6c9a301309d
# ╠═32b24383-6f75-494d-99a7-304b9a026d2d
# ╠═45e939e2-af03-45d3-9978-54eebc803b04
# ╠═48e6f211-27a6-42a2-8c4a-4352863da1fa
# ╟─2edd33de-ebd4-484c-a45b-3fe7c6beb597
# ╠═d1b599d9-da3a-4070-90dc-e63532951fd6
# ╟─d1c1c450-c0d7-4427-b73e-795e0b5387fa
# ╠═fc925cdf-ffd8-45ad-a7a9-4c11228fac02
# ╟─21cc515d-d381-445f-a23a-4bc75c81e38c
# ╠═2fd0b79d-4740-45aa-a63d-95d2fb41ad81
# ╟─ddd6790a-7597-4983-909d-41c11b24110c
# ╠═c806912b-8bec-4d41-a7f3-0c7654a4ed53
# ╠═ea89fc90-dacd-4f90-852b-a9eb3bce0450
# ╠═c2c05477-7c33-480f-b88f-c173487a4a4c
