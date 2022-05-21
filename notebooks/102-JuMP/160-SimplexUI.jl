### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try
            Base.loaded_modules[Base.PkgId(
                Base.UUID("6e696c72-6542-2067-7265-42206c756150"),
                "AbstractPlutoDingetjes",
            )].Bonds.initial_value
        catch
            b -> missing
        end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("GLPK")
        Pkg.PackageSpec("Plots")
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP, GLPK

# ╔═╡ f22938c9-a58b-4ae9-bd11-aa774b7a60a1
using Plots

# ╔═╡ 762350d1-1aa7-4478-9157-cd9029e80d80
using PlutoUI

# ╔═╡ fe844b29-2de9-4df0-b965-fcb23620b128
md"""
## Problema Primal
"""

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    m = JuMP.Model(GLPK.Optimizer)

    @variable(m, x[1:2] >= 0)

    @objective(m, Max, 3 * x[1] + 5 * x[2])

    @constraint(m, r1, 1 * x[1] <= 4)
    @constraint(m, r2, 2 * x[2] <= 12)
    @constraint(m, r3, 3 * x[1] + 2 * x[2] <= 18)

    JuMP.optimize!(m)
    @show JuMP.value.(x), JuMP.objective_value(m)

    JuMP.latex_formulation(m)
end

# ╔═╡ a36b9c33-d55d-4616-829b-475ee820af13
md"""
## Solucion Grafica
"""

# ╔═╡ 0d085272-d6c3-402e-926a-798c4ec256f8
md"""
r1 = $( @bind s1 PlutoUI.CheckBox(false) )
r2 = $( @bind s2 PlutoUI.CheckBox(false) )
r3 = $( @bind s3 PlutoUI.CheckBox(false) )
rf = $( @bind s4 PlutoUI.CheckBox(false) )
sb = $( @bind s5 PlutoUI.CheckBox(false) )
"""

# ╔═╡ acdad7c0-89c0-4792-8708-0ae209e2651e
begin
    p = Plots.plot()
    Plots.xlims!(0, 7)
    Plots.ylims!(0, 10)

    t = range(0, 7, length = 100)
    f1 = 4 * one.(t)
    f2(t) = 12 / 2
    f3(t) = 18 / 2 - 3 / 2 * t

    s1 && Plots.plot!([(0, 0), (4, 0), (4, 10), (0, 10)], fill = (0, 0.3), label = "x_1 <= 4")
    s2 && Plots.plot!(f2, 0, 7, fill = (0, 0.3), label = "2*x_2 <= 12")
    s3 && Plots.plot!(f3, 0, 6, fill = (0, 0.3), label = "3*x_1+2*x_2 <= 18")

    rf = Plots.Shape([(0, 0), (4, 0), (4, 3), (2, 6), (0, 6), (0, 0)])
    s4 && Plots.plot!(rf, fill = (0, 0.7), label = "Region Factible")

    s5 && Plots.annotate!(0, 0, "z(0,0)=0", :left)
    s5 && Plots.annotate!(4, 0, "z(4,0)=12", :left)
    s5 && Plots.annotate!(4, 3, "z(4,3)=27", :left)
    s5 && Plots.annotate!(2, 6, "z(2,6)=36", :left)
    s5 && Plots.annotate!(0, 6, "z(0,6)=30", :left)
    p
end

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═f22938c9-a58b-4ae9-bd11-aa774b7a60a1
# ╠═762350d1-1aa7-4478-9157-cd9029e80d80
# ╟─fe844b29-2de9-4df0-b965-fcb23620b128
# ╟─5751108d-6a44-4d33-9386-5d811638c6f0
# ╟─a36b9c33-d55d-4616-829b-475ee820af13
# ╟─0d085272-d6c3-402e-926a-798c4ec256f8
# ╟─acdad7c0-89c0-4792-8708-0ae209e2651e
