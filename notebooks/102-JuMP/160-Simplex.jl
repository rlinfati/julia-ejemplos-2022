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
        Pkg.PackageSpec("Plots")
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

# ╔═╡ f22938c9-a58b-4ae9-bd11-aa774b7a60a1
using Plots

# ╔═╡ 762350d1-1aa7-4478-9157-cd9029e80d80
using LinearAlgebra

# ╔═╡ fe844b29-2de9-4df0-b965-fcb23620b128
md"""
## Problema Primal
"""

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    m = JuMP.Model()

    @variable(m, x[1:2] >= 0)

    @objective(m, Max, 3 * x[1] + 5 * x[2])

    @constraint(m, r1, 1 * x[1] <= 4)
    @constraint(m, r2, 2 * x[2] <= 12)
    @constraint(m, r3, 3 * x[1] + 2 * x[2] <= 18)

    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.optimize!(m)
    @show JuMP.value.(x)
    @show JuMP.shadow_price.([r1, r2, r3]) # MAX

    JuMP.latex_formulation(m)
end

# ╔═╡ a36b9c33-d55d-4616-829b-475ee820af13
md"""
## Solucion Grafica
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

    Plots.plot!([(0, 0), (4, 0), (4, 10), (0, 10)], fill = (0, 0.3), label = "x_1 <= 4")
    Plots.plot!(f2, 0, 7, fill = (0, 0.3), label = "2*x_2 <= 12")
    Plots.plot!(f3, 0, 6, fill = (0, 0.3), label = "3*x_1+2*x_2 <= 18")

    rf = Plots.Shape([(0, 0), (4, 0), (4, 3), (2, 6), (0, 6), (0, 0)])
    Plots.plot!(rf, fill = (0, 0.7), label = "Region Factible")

    Plots.annotate!(0, 0, "z(0,0)=0", :left)
    Plots.annotate!(4, 0, "z(4,0)=12", :left)
    Plots.annotate!(4, 3, "z(4,3)=27", :left)
    Plots.annotate!(2, 6, "z(2,6)=36", :left)
    Plots.annotate!(0, 6, "z(0,6)=30", :left)
end

# ╔═╡ 221dd330-67dc-4dc6-9e20-bcaaaf6387d8
md"""
## Problema Dual
"""

# ╔═╡ fb641ebc-03fb-4792-94e0-6820bbe82793
begin
    md = JuMP.Model()

    @variable(md, y[1:3] >= 0)

    @objective(md, Min, 4 * y[1] + 12 * y[2] + 18 * y[3])

    @constraint(md, r01, 1 * y[1] + 3 * y[3] >= 3)
    @constraint(md, r02, 2 * y[2] + 2 * y[3] >= 5)

    JuMP.set_optimizer(md, GLPK.Optimizer)
    JuMP.optimize!(md)
    @show JuMP.value.(y)
    @show JuMP.dual.([r01, r02]) # MIN

    JuMP.latex_formulation(md)
end

# ╔═╡ 44197b6b-2373-4a60-a86d-7f404f082c78
md"""
## Tableau Simplex
"""

# ╔═╡ 93d19bf7-9824-4b7f-8585-b9c3b4495a77
function nextSimplex(xx, c, A, b)
    nn = length(c)
    mm = length(b)

    cc = vcat(c, zeros(mm))
    AA = hcat(A, LinearAlgebra.I(mm)) |> Matrix
    bb = b

    cb = cc[xx]
    BB = AA[:, xx]
    rc = hcat(cb' * inv(BB) * A - c', cb' * inv(BB))' |> Vector

    zobj = cb' * inv(BB) * b
    xvar = xx
    xval = inv(BB) * b

    println("rc   = ", rc)
    println("zobj = ", zobj)
    println("xvar = ", xvar)
    println("xval = ", xval)
    println()

    vin = argmin(rc)
    if rc[vin] > -eps()
        return
    end

    AAA = hcat(inv(BB) * A, inv(BB))
    bbb = inv(BB) * b
    bAcol = [(bbb[i] / AAA[i, vin], i) for i in 1:mm if AAA[i, vin] > eps()]

    nout = bAcol[argmin(bAcol)][2]
    vout = 0

    for i in eachindex(xx)
        if xx[i]
            nout -= 1
        end
        if nout == 0
            vout = i
            break
        end
    end

    xx[vin] = true
    xx[vout] = false

    return xx
end

# ╔═╡ 6fe6bcf8-9fbd-470a-8700-28d50774614f
let
    c = [3, 5]
    A = [
        1 0
        0 2
        3 2
    ]
    b = [
        4
        12
        18
    ]

    xx = vcat(falses(length(c)), trues(length(b)))

    while true
        xx = nextSimplex(xx, c, A, b)
        if xx === nothing
            break
        end
    end
end

# ╔═╡ 1a13e6db-c406-4c4f-bc6a-bbb4f4f71264
md"""
## Analisis de Sensibilidad
"""

# ╔═╡ 61eb641b-78d1-4e0b-acc6-e7378f2c7857
report = lp_sensitivity_report(m)

# ╔═╡ 1b15b5c7-19e9-4b7b-b556-299d6b29f60e
for i in JuMP.all_variables(m)
    xval = JuMP.value(i)
    dx_lo, dx_hi = report[i]
    fo = JuMP.objective_function(m)
    c = JuMP.coefficient(fo, i)
    rc = JuMP.reduced_cost(i)
    println("$i=$xval \t -> rc = $rc \t Δ: ($dx_lo, $dx_hi) \t -> α: ($(c+dx_lo):$(c+dx_hi))")
end

# ╔═╡ 7d51fdfc-96de-44d1-86b7-ad80eb431b20
for i in list_of_constraint_types(m)
    if i[1] == VariableRef
        continue
    end

    for j in JuMP.all_constraints(m, i[1], i[2])
        ys = JuMP.shadow_price(j)
        b = JuMP.normalized_rhs(j)

        dRHS_lo, dRHS_hi = report[j]
        println("$j \t -> shadow_price: $ys \t -> Δ: ($dRHS_lo, $dRHS_hi) \t -> α: ($(b+dRHS_lo):$(b+dRHS_hi))")
    end
end

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═f22938c9-a58b-4ae9-bd11-aa774b7a60a1
# ╠═762350d1-1aa7-4478-9157-cd9029e80d80
# ╟─fe844b29-2de9-4df0-b965-fcb23620b128
# ╠═5751108d-6a44-4d33-9386-5d811638c6f0
# ╟─a36b9c33-d55d-4616-829b-475ee820af13
# ╠═acdad7c0-89c0-4792-8708-0ae209e2651e
# ╟─221dd330-67dc-4dc6-9e20-bcaaaf6387d8
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╟─44197b6b-2373-4a60-a86d-7f404f082c78
# ╠═93d19bf7-9824-4b7f-8585-b9c3b4495a77
# ╠═6fe6bcf8-9fbd-470a-8700-28d50774614f
# ╟─1a13e6db-c406-4c4f-bc6a-bbb4f4f71264
# ╠═61eb641b-78d1-4e0b-acc6-e7378f2c7857
# ╠═1b15b5c7-19e9-4b7b-b556-299d6b29f60e
# ╠═7d51fdfc-96de-44d1-86b7-ad80eb431b20
