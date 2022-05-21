### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
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

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
using GLPK

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
## Ejemplo de Modelos de Programación Lineal
"""

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    m = JuMP.Model()

    @variable(m, x[1:2] >= 0)

    @objective(m, Max, 3 * x[1] + 5 * x[2])

    @constraint(m, r1, 1 * x[1] <= 4)
    @constraint(m, r2, 2 * x[2] <= 12)
    @constraint(m, r3, 3 * x[1] + 2 * x[2] <= 18)

    nothing
end

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
JuMP.latex_formulation(m);

# ╔═╡ 0c5cea8e-ec2c-42e4-9b53-cca423636d24
md"""
## Solucion con JuMP
"""

# ╔═╡ fb641ebc-03fb-4792-94e0-6820bbe82793
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
JuMP.solution_summary(m)

# ╔═╡ c89a9a9e-b463-4e94-9501-ad3fe1a99101
begin
    @show JuMP.termination_status(m)
    @show JuMP.primal_status(m)
    @show JuMP.dual_status(m)

    @show JuMP.objective_value(m)
    @show JuMP.objective_bound(m)

    @show JuMP.solve_time(m)
    # @show JuMP.relative_gap(m)
    # @show JuMP.node_count(m)

    @show JuMP.result_count(m)
    nothing
end

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╟─76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═5751108d-6a44-4d33-9386-5d811638c6f0
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╟─0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═c89a9a9e-b463-4e94-9501-ad3fe1a99101
