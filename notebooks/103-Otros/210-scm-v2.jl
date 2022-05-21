### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 0c0cc340-c27e-11ec-1ce9-2dc92a70fabd
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("GLPK")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 0c1184de-c27e-11ec-33ea-ab4d518e8033
using JuMP

# ╔═╡ 0c118506-c27e-11ec-2bf2-b9123001bcfb
using GLPK

# ╔═╡ 115b4692-4eb7-4845-b711-7fdc0390c2f5
begin
    nE1 = 2 # proveedores
    nE2 = 3 # fabricas
    nE3 = 1 # distribuidores
    nE4 = 1 # minoristas
    nE5 = 2 # clientes

    nMP = 3 # materias primas

    # costo del ciclo de adquisicion
    c12 = [
        1 2 3
        2 1 3
    ]

    # costo del ciclo de fabricaicon
    c23 = [
        1
        1
        1
    ]

    # costo del ciclo de reabastecimiento
    c34 = [1]

    # costo del ciclo de pedido
    c45 = [2 3]

    # oferta en los proveedores de cada materia prima
    oferta = [
        100 200 300
        150 300 450
    ]

    # demanda de cada uno de los clientes
    demanda = [
        75
        25
    ]

    # composicion de materia prima del producto final
    mezcla = [2 3 4]

    nothing
end

# ╔═╡ ba664bc3-144b-4875-ab6a-73fbbdf5ecfc
begin
    m = JuMP.Model()

    @variable(m, x12mp[1:nE1, 1:nE2, 1:nMP] >= 0)
    @variable(m, x12f[1:nE2] >= 0)
    @variable(m, x23[1:nE2, 1:nE3] >= 0)
    @variable(m, x34[1:nE3, 1:nE4] >= 0)
    @variable(m, x45[1:nE4, 1:nE5] >= 0)

    @objective(
        m,
        Min,
        sum(c12 .* sum(x12mp[:, :, i] for i in 1:nMP)) + sum(c23 .* x23) + sum(c34 .* x34) + sum(c45 .* x45)
    )

    @constraint(m, r01[i in 1:nE1, k in 1:nMP], sum(x12mp[i, :, k]) <= oferta[i, k])
    @constraint(m, r10[j in 1:nE2, k in 1:nMP], sum(x12mp[:, j, k]) == mezcla[k] * x12f[j])

    @constraint(m, r02[j in 1:nE2], x12f[j] == sum(x23[j, :]))

    @constraint(m, r3[j in 1:nE3], sum(x23[:, j]) == sum(x34[j, :]))
    @constraint(m, r4[j in 1:nE4], sum(x34[:, j]) == sum(x45[j, :]))
    @constraint(m, r5[j in 1:nE5], sum(x45[:, j]) >= demanda[j])

    JuMP.latex_formulation(m)
end

# ╔═╡ 56516b24-fc61-4676-95a6-15ec38ccf8e0
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ 43d6566b-8b8d-411c-b562-0262edcbb16d
JuMP.solution_summary(m)

# ╔═╡ 7154f634-21d4-4275-b949-f2eda7a7a56c
JuMP.value.(x12mp)

# ╔═╡ af0dec3f-4161-47c1-9bfb-0c4816143db4
JuMP.value.(x12f)

# ╔═╡ 9d69258e-a872-442b-94c5-e524b155b6d6
JuMP.value.(x23)

# ╔═╡ e0e787aa-87cb-43db-9e67-eb3f89550ed7
JuMP.value.(x34)

# ╔═╡ e960d53d-0e05-45c0-91b3-5de09574da96
JuMP.value.(x45)

# ╔═╡ ee72e4cf-659e-4e6c-86e5-5d635d395996
JuMP.dual.(r01)

# ╔═╡ 381d8952-b8bf-4bd4-a147-44dae4ada796
JuMP.dual.(r10)

# ╔═╡ 260a6510-7884-435f-8c02-1d0f4d32b833
JuMP.dual.(r02)

# ╔═╡ c0dc62d3-c363-4e9e-a282-f54c2d514bcf
JuMP.dual.(r3)

# ╔═╡ a3eb580e-c366-4b07-9e18-706474c767da
JuMP.dual.(r4)

# ╔═╡ 9b58bcad-b863-4ebc-b1bf-432bafd328f8
JuMP.dual.(r5)

# ╔═╡ Cell order:
# ╟─0c0cc340-c27e-11ec-1ce9-2dc92a70fabd
# ╠═0c1184de-c27e-11ec-33ea-ab4d518e8033
# ╠═0c118506-c27e-11ec-2bf2-b9123001bcfb
# ╠═115b4692-4eb7-4845-b711-7fdc0390c2f5
# ╠═ba664bc3-144b-4875-ab6a-73fbbdf5ecfc
# ╠═56516b24-fc61-4676-95a6-15ec38ccf8e0
# ╠═43d6566b-8b8d-411c-b562-0262edcbb16d
# ╠═7154f634-21d4-4275-b949-f2eda7a7a56c
# ╠═af0dec3f-4161-47c1-9bfb-0c4816143db4
# ╠═9d69258e-a872-442b-94c5-e524b155b6d6
# ╠═e0e787aa-87cb-43db-9e67-eb3f89550ed7
# ╠═e960d53d-0e05-45c0-91b3-5de09574da96
# ╠═ee72e4cf-659e-4e6c-86e5-5d635d395996
# ╠═381d8952-b8bf-4bd4-a147-44dae4ada796
# ╠═260a6510-7884-435f-8c02-1d0f4d32b833
# ╠═c0dc62d3-c363-4e9e-a282-f54c2d514bcf
# ╠═a3eb580e-c366-4b07-9e18-706474c767da
# ╠═9b58bcad-b863-4ebc-b1bf-432bafd328f8
