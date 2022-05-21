### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([Pkg.PackageSpec("JuMP")])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
## Ejemplo de Modelos de Programación Lineal
"""

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    ㊭ = JuMP.Model()

    @variable(㊭, 💻 >= 0)
    @variable(㊭, 📱 >= 0)

    @objective(㊭, Max, 3 * 💻 + 5 * 📱)

    @constraint(㊭, 💻 <= 4)
    @constraint(㊭, 2 * 📱 <= 12)
    @constraint(㊭, 3 * 💻 + 2 * 📱 <= 18)

    nothing
end

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
JuMP.latex_formulation(㊭)

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╟─76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═5751108d-6a44-4d33-9386-5d811638c6f0
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
