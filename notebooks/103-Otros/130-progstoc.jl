### A Pluto.jl notebook ###
# v0.19.2

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
function farmer(pc, pp, sp, li, la, yi, re)
    m = JuMP.Model(GLPK.Optimizer)

    nc = length(pc)
    @assert nc == length(pp)
    @assert nc == length(sp)
    @assert nc == length(yi)
    @assert nc == length(re)

    @variable(m, x[1:nc] >= 0)
    @variable(m, y[1:nc] >= 0)
    @variable(m, w[1:nc] >= 0)

    JuMP.fix(y[end], 0.0; force = true)

    @expression(m, z1, pc' * x)
    @expression(m, z2, pp' * y - sp' * w)

    @objective(m, Min, z1 + z2)

    @constraint(m, lan, sum(x) <= la)
    @constraint(m, req[j in 1:nc], yi[j] * x[j] + y[j] - w[j] >= re[j])
    @constraint(m, lim, w[end] <= li)

    JuMP.optimize!(m)

    xval = round.(JuMP.value.(x); digits = 4)
    yval = round.(JuMP.value.(y); digits = 4)
    wval = round.(JuMP.value.(w); digits = 4)
    zval = round(JuMP.objective_value(m); digits = 4)
    vval = xval .* yi
    rval = re

    return md"""
    | Cultivo  | Trigo      | Maiz       | Remolacha   |
    |----------|------------|------------|-------------|
    |Superficie| $(xval[1]) | $(xval[2]) | $(xval[3])  |
    |Rendimiento| $(vval[1]) | $(vval[2]) | $(vval[3])  |
    |Requerimiento| $(rval[1]) | $(rval[2]) | $(rval[3])  |
    |Compra    | $(yval[1]) | $(yval[2]) | $(yval[3])  |
    |Venta     | $(wval[1]) | $(wval[2]) | $(wval[3])  |
    |Utilidad  |            | $(zval)    |             |
    """
end

# ╔═╡ ba664bc3-144b-4875-ab6a-73fbbdf5ecfc
md"""
## Representación determinista
"""

# ╔═╡ 56516b24-fc61-4676-95a6-15ec38ccf8e0
begin
    PlantingCost = [150; 230; 260]
    PurshasePrice = [238; 210; 0]
    SellingPrice = [170; 150; 36]
    limit = 6_000
    land = 500
    Yield = [2.5; 3.0; 20]
    Requierement = [200; 240; 0]
    nothing
end

# ╔═╡ 9d41f2f3-11a6-4896-b263-bf24e63127e6
md"""
## Representación por escenarios
"""

# ╔═╡ 97091f04-60cb-48ab-b6b7-84d6eac25e7c
md"""
### Caso Optimista
"""

# ╔═╡ 96e8ac9c-75c4-4e59-a2d2-25c6588dc7dd
md"""
### Caso Promedio
"""

# ╔═╡ 379e578d-f974-4e24-bf44-214ab9d35908
md"""
### Caso Pesimista
"""

# ╔═╡ 220b46dc-8f0d-40ce-8919-4a7f030b6ca8
md"""
## Representación estocastica por escenarios
"""

# ╔═╡ 7f9b95d9-9df2-409e-b69b-dead7f1e82ef
md"""
- Primera etapa: x
- Segunda etapa: y, w
"""

# ╔═╡ 41053912-c0fb-4fee-aab9-bae6b85b25c6
function farmer(pc, pp, sp, li, la, yi, re, ss; xfix = zeros(Float64, length(pc)))
    m = JuMP.Model(GLPK.Optimizer)

    nc = length(pc)
    @assert nc == length(pp)
    @assert nc == length(sp)
    @assert nc == length(yi)
    @assert nc == length(re)
    ns = length(ss)
    @assert sum(xfix) <= la

    @variable(m, x[1:nc] >= 0)
    @variable(m, y[1:nc, 1:ns] >= 0)
    @variable(m, w[1:nc, 1:ns] >= 0)

    JuMP.fix.(y[end, :], 0.0; force = true)
    if sum(xfix) >= eps(Float16)
        JuMP.fix.(x, xfix; force = true)
    end

    @expression(m, z1, pc' * x)
    @expression(m, z2[s in 1:ns], pp' * y[:, s] - sp' * w[:, s])

    @objective(m, Min, z1 + inv(ns) * sum(z2))

    @constraint(m, lan, sum(x) <= la)
    @constraint(m, req[j in 1:nc, s in 1:ns], ss[s] * yi[j] * x[j] + y[j, s] - w[j, s] >= re[j])
    @constraint(m, lim[s in 1:ns], w[end, s] <= li)

    JuMP.optimize!(m)

    rmd = ""

    xval = round.(JuMP.value.(x); digits = 4)
    zval = round(JuMP.objective_value(m); digits = 4)
    rval = re

    for s in 1:ns
        yval = round.(JuMP.value.(y[:, s]); digits = 4)
        wval = round.(JuMP.value.(w[:, s]); digits = 4)
        vval = xval .* yi .* ss[s]
        sval = round.(JuMP.value.(z1 + z2[s]); digits = 4)

        smd = """
       	Caso $(s) - $(ss[s]*100)%
       | Cultivo  | Trigo      | Maiz       | Remolacha   |
       |----------|------------|------------|-------------|
       |Superficie| $(xval[1]) | $(xval[2]) | $(xval[3])  |
       |Rendimiento| $(vval[1]) | $(vval[2]) | $(vval[3])  |
       |Requerimiento| $(rval[1]) | $(rval[2]) | $(rval[3])  |
       |Compra    | $(yval[1]) | $(yval[2]) | $(yval[3])  |
       |Venta     | $(wval[1]) | $(wval[2]) | $(wval[3])  |
       |Utilidad  |            | $(sval)    |             |
       """
        rmd *= smd
    end
    rmd *= "Utilidad Promedio $(zval)"

    return Markdown.parse(rmd)
end

# ╔═╡ 43d6566b-8b8d-411c-b562-0262edcbb16d
farmer(PlantingCost, PurshasePrice, SellingPrice, limit, land, Yield, Requierement)

# ╔═╡ 5e945e7f-98f8-4bad-ac20-f7c93af49c70
farmer(PlantingCost, PurshasePrice, SellingPrice, limit, land, 1.2 * Yield, Requierement)

# ╔═╡ 3ad6ffa4-1b47-4fa0-b002-42267ec40c6e
farmer(PlantingCost, PurshasePrice, SellingPrice, limit, land, 1.0 * Yield, Requierement)

# ╔═╡ 6586cfa0-379a-47c2-b342-370176fc0358
farmer(PlantingCost, PurshasePrice, SellingPrice, limit, land, 0.8 * Yield, Requierement)

# ╔═╡ 6c6cdba0-82b3-4ffe-9251-25c13df9dfe3
farmer(PlantingCost, PurshasePrice, SellingPrice, limit, land, Yield, Requierement, [1.2; 1.0; 0.8])

# ╔═╡ fa78ecb3-91de-400c-9635-3209f2f4c6d8
md"""
- RP = -108390.0 
- WS = (-167666.6 - 118600.0 - 59950.0)/3.0 = $((-167666.6 - 118600.0 - 59950.0)/3.0)
- EVPI = -108390.0 - (-167666.6 - 118600.0 - 59950.0)/3.0 = $(-108390.0 - (-167666.6 - 118600.0 - 59950.0)/3.0)

* RP: recourse problem -> here-and-now
* WS: wait-and-see
* EVPI: expected value of perfect information
* EVPI = RP - WS
"""

# ╔═╡ c138ae64-a5de-4c17-acf5-40ffdc5f1c6c
farmer(
    PlantingCost,
    PurshasePrice,
    SellingPrice,
    limit,
    land,
    Yield,
    Requierement,
    [1.2; 1.0; 0.8];
    xfix = [120.0; 80.0; 300.0],
)

# ╔═╡ 174c767b-d7cc-4b8f-9b71-a0168f9c0930
md"""
- EEV: -103240.0
- RP:  -108390.0
- VSS: -103240.0 - -108390 = $(-103240.0 - -108390)

* EEV: Expected result of Expected value problem or Expected result of mean value problem
* VSS: Value of stochastic solution
* VSS = EEV - RP
"""

# ╔═╡ 4bda29aa-6b7b-48ed-a149-d0e2f1f11270
md"""
- WS <= RP <= EEV
- $((-167666.6 - 118600.0 - 59950.0)/3.0) <= -108390.0 <= -103240.0


* WS: wait-and-see
* RP: recourse problem -> here-and-now
* EVPI: expected value of perfect information
* EVPI = RP - WS


* EEV: Expected result of Expected value problem
* VSS: Value of stochastic solution
* VSS = EEP - RP
"""

# ╔═╡ Cell order:
# ╟─0c0cc340-c27e-11ec-1ce9-2dc92a70fabd
# ╠═0c1184de-c27e-11ec-33ea-ab4d518e8033
# ╠═0c118506-c27e-11ec-2bf2-b9123001bcfb
# ╠═115b4692-4eb7-4845-b711-7fdc0390c2f5
# ╟─ba664bc3-144b-4875-ab6a-73fbbdf5ecfc
# ╠═56516b24-fc61-4676-95a6-15ec38ccf8e0
# ╠═43d6566b-8b8d-411c-b562-0262edcbb16d
# ╟─9d41f2f3-11a6-4896-b263-bf24e63127e6
# ╟─97091f04-60cb-48ab-b6b7-84d6eac25e7c
# ╠═5e945e7f-98f8-4bad-ac20-f7c93af49c70
# ╟─96e8ac9c-75c4-4e59-a2d2-25c6588dc7dd
# ╠═3ad6ffa4-1b47-4fa0-b002-42267ec40c6e
# ╟─379e578d-f974-4e24-bf44-214ab9d35908
# ╠═6586cfa0-379a-47c2-b342-370176fc0358
# ╟─220b46dc-8f0d-40ce-8919-4a7f030b6ca8
# ╟─7f9b95d9-9df2-409e-b69b-dead7f1e82ef
# ╠═41053912-c0fb-4fee-aab9-bae6b85b25c6
# ╠═6c6cdba0-82b3-4ffe-9251-25c13df9dfe3
# ╟─fa78ecb3-91de-400c-9635-3209f2f4c6d8
# ╠═c138ae64-a5de-4c17-acf5-40ffdc5f1c6c
# ╟─174c767b-d7cc-4b8f-9b71-a0168f9c0930
# ╟─4bda29aa-6b7b-48ed-a149-d0e2f1f11270
