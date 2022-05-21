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

# ╔═╡ 3c72172d-feb2-4721-a69e-06d1b10deae9
using Plots

# ╔═╡ bb4218e4-06f0-482b-9ab6-55fedd51d429
using Random

# ╔═╡ 4e21d0be-afd3-4e02-84a4-f4a39a2d712f
md"""
## Lectura/Generacion de Instancia
"""

# ╔═╡ f9cb6029-062b-436e-968b-9e8e4dd7b8f6
begin
    n = 15 # customers
    m = 5 # facilities
    Random.seed!(1234)
    Xc = rand(n) * 1_000.0
    Yc = rand(n) * 1_000.0
    Xf = rand(m) * 1_000.0
    Yf = rand(m) * 1_000.0
    nothing
end

# ╔═╡ 72b74a0b-e001-445f-9c65-995c69854951
md"""
## Calculo de parametros
"""

# ╔═╡ 01c7c9d4-ee9d-408f-8eac-028e42490853
d(c, f) = sqrt((Xc[c] - Xf[f])^2 + (Yc[c] - Yf[f])^2)

# ╔═╡ c2a2b9e2-170f-44eb-be42-ea3219836e91
acov = [d(c, f) <= 700.0 for c in 1:n, f in 1:m]

# ╔═╡ 3e656563-b83c-49c1-bc61-2b845a5a9153
@assert all(sum(acov, dims = 2) .>= 1)

# ╔═╡ 66bea84e-7574-494c-abcf-eb8d092e778c
md"""
# Set/Max Covering Problem
"""

# ╔═╡ 249acea1-9778-4e03-9a7e-5636054c3f06
md"""
## Modelo Set Covering
"""

# ╔═╡ 3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
let
    global scp = JuMP.Model()

    cc_f = 100.0 * ones(m)

    @variable(scp, x[1:m], Bin)
    @objective(scp, Min, sum(cc_f .* x))
    @constraint(scp, r1[c in 1:n], sum(acov[c, :] .* x) >= 1)

    nothing
end

# ╔═╡ 48e6f211-27a6-42a2-8c4a-4352863da1fa
JuMP.latex_formulation(scp);

# ╔═╡ 2edd33de-ebd4-484c-a45b-3fe7c6beb597
md"""
### Parametros del Solver y Optimización
"""

# ╔═╡ d1b599d9-da3a-4070-90dc-e63532951fd6
begin
    JuMP.set_optimizer(scp, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(scp, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(scp, "tm_lim", 60 * 1000)
    JuMP.optimize!(scp)
end

# ╔═╡ d1c1c450-c0d7-4427-b73e-795e0b5387fa
md"""
### Estado del Solver
"""

# ╔═╡ fc925cdf-ffd8-45ad-a7a9-4c11228fac02
JuMP.solution_summary(scp)

# ╔═╡ 21cc515d-d381-445f-a23a-4bc75c81e38c
md"""
### Solución del Solver
"""

# ╔═╡ 2fd0b79d-4740-45aa-a63d-95d2fb41ad81
scp_xval = JuMP.value.(scp[:x]) .≈ 1.0

# ╔═╡ ddd6790a-7597-4983-909d-41c11b24110c
md"""
### Solución gráfica
"""

# ╔═╡ c806912b-8bec-4d41-a7f3-0c7654a4ed53
begin
    plot(legend = false)
    scatter!(Xc, Yc, markershape = :circle, markercolor = :blue)

    co = [(scp_xval[j] ? :red : :white) for j in 1:m]
    scatter!(Xf, Yf, markershape = :square, markercolor = co)

    for c in 1:n, f in 1:m
        if acov[c, f] * scp_xval[f]
            plot!([Xc[c], Xf[f]], [Yc[c], Yf[f]], color = :black)
        end
    end

    psc = plot!(title = "Set Covering")
end

# ╔═╡ c2c05477-7c33-480f-b88f-c173487a4a4c
md"""
# Max Covering
"""

# ╔═╡ e6b9b8fe-46e4-4d14-ab60-07793d268cff
let
    global mcp = JuMP.Model()

    de_c = ones(n)
    p = 2

    @variable(mcp, x[1:m], Bin)
    @variable(mcp, y[1:n], Bin)
    @objective(mcp, Max, sum(de_c .* y))
    @constraint(mcp, r1[c in 1:n], y[c] <= sum(acov[c, :] .* x))
    @constraint(mcp, r2, sum(x) <= p)

    nothing
end

# ╔═╡ cabb5852-7de3-4151-9294-230b33b1281f
JuMP.latex_formulation(mcp);

# ╔═╡ cfd844e0-5275-46e5-a121-6553c181c7c7
md"""
### Parametros del Solver y Optimización
"""

# ╔═╡ 43fb9978-267e-4d88-ae24-31e7ad47c127
begin
    JuMP.set_optimizer(mcp, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(mcp, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(mcp, "tm_lim", 60 * 1000)
    JuMP.optimize!(mcp)
end

# ╔═╡ 975d1820-0b66-4d58-802f-9eb9709a10e0
md"""
### Estado del Solver
"""

# ╔═╡ 77057339-b3fd-4b32-b560-e9b3d6caefa4
JuMP.solution_summary(mcp)

# ╔═╡ 043d2417-edbf-4fbc-a9d3-b5d0c8c91848
md"""
### Solución del Solver
"""

# ╔═╡ fb990193-cf2f-43d2-a216-b93718f6047f
mcp_xval = JuMP.value.(mcp[:x]) .≈ 1.0

# ╔═╡ 085c09d7-2db5-404d-8c5a-5ee15ebebc7f
mcp_yval = JuMP.value.(mcp[:y]) .≈ 1.0

# ╔═╡ c4fe01ef-abb3-4655-b57c-63c4eefc07f5
md"""
### Solución gráfica
"""

# ╔═╡ 27a5d621-a7f8-49d8-acd5-016909530d45
begin
    plot(legend = false)

    mc = [(mcp_yval[j] ? :blue : :yellow) for j in 1:n]
    scatter!(Xc, Yc, markershape = :circle, markercolor = mc)

    mf = [(mcp_xval[j] ? :red : :white) for j in 1:m]
    scatter!(Xf, Yf, markershape = :square, markercolor = mf)

    for c in 1:n, f in 1:m
        if acov[c, f] * mcp_yval[c] * mcp_xval[f]
            plot!([Xc[c], Xf[f]], [Yc[c], Yf[f]], color = :black)
        end
    end

    global pmc = plot!(title = "Max Covering")
end

# ╔═╡ 3a2b96d8-1c68-4cee-8ad4-0e631e399b15
md"""
# Set Covering vs Max Covering
"""

# ╔═╡ 33abcf0b-02fe-4a8c-850f-46c1913415d6
plot(psc, pmc)

# ╔═╡ Cell order:
# ╟─e7262522-ac65-11ec-0633-1d82420161db
# ╠═e726254a-ac65-11ec-2f4c-1bead54e006a
# ╠═a28468d5-b6fd-42d1-856f-4b9a8198a4fa
# ╠═3c72172d-feb2-4721-a69e-06d1b10deae9
# ╠═bb4218e4-06f0-482b-9ab6-55fedd51d429
# ╟─4e21d0be-afd3-4e02-84a4-f4a39a2d712f
# ╠═f9cb6029-062b-436e-968b-9e8e4dd7b8f6
# ╟─72b74a0b-e001-445f-9c65-995c69854951
# ╠═01c7c9d4-ee9d-408f-8eac-028e42490853
# ╠═c2a2b9e2-170f-44eb-be42-ea3219836e91
# ╠═3e656563-b83c-49c1-bc61-2b845a5a9153
# ╟─66bea84e-7574-494c-abcf-eb8d092e778c
# ╟─249acea1-9778-4e03-9a7e-5636054c3f06
# ╠═3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
# ╠═48e6f211-27a6-42a2-8c4a-4352863da1fa
# ╟─2edd33de-ebd4-484c-a45b-3fe7c6beb597
# ╠═d1b599d9-da3a-4070-90dc-e63532951fd6
# ╟─d1c1c450-c0d7-4427-b73e-795e0b5387fa
# ╠═fc925cdf-ffd8-45ad-a7a9-4c11228fac02
# ╟─21cc515d-d381-445f-a23a-4bc75c81e38c
# ╠═2fd0b79d-4740-45aa-a63d-95d2fb41ad81
# ╟─ddd6790a-7597-4983-909d-41c11b24110c
# ╠═c806912b-8bec-4d41-a7f3-0c7654a4ed53
# ╟─c2c05477-7c33-480f-b88f-c173487a4a4c
# ╠═e6b9b8fe-46e4-4d14-ab60-07793d268cff
# ╠═cabb5852-7de3-4151-9294-230b33b1281f
# ╟─cfd844e0-5275-46e5-a121-6553c181c7c7
# ╠═43fb9978-267e-4d88-ae24-31e7ad47c127
# ╟─975d1820-0b66-4d58-802f-9eb9709a10e0
# ╠═77057339-b3fd-4b32-b560-e9b3d6caefa4
# ╟─043d2417-edbf-4fbc-a9d3-b5d0c8c91848
# ╠═fb990193-cf2f-43d2-a216-b93718f6047f
# ╠═085c09d7-2db5-404d-8c5a-5ee15ebebc7f
# ╟─c4fe01ef-abb3-4655-b57c-63c4eefc07f5
# ╠═27a5d621-a7f8-49d8-acd5-016909530d45
# ╟─3a2b96d8-1c68-4cee-8ad4-0e631e399b15
# ╠═33abcf0b-02fe-4a8c-850f-46c1913415d6
