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

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    m = JuMP.Model()

    @variable(m, x1 >= 1, Int)
    @variable(m, x2 >= 0, Int)
    @variable(m, x3 >= 0, Int)

    @objective(m, Min, x1)
    @constraint(m, r1, 12345 * x1 == 23456 * x2 + 34567 * x3)

    nothing
end

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
JuMP.latex_formulation(m)

# ╔═╡ 46028570-c4ab-4cd8-9fd0-46772e9fb57c
function myCallbackHeuristic(cb_data)
    x = JuMP.all_variables(m)
    x_val = JuMP.callback_value.(cb_data, x)

    if x_val[1] <= 17284.0 + eps(Float16)
        return
    end

    ret = callback_node_status(cb_data, m)
    println("** myCallbackHeuristic node_status = $(ret)")

    x_vals = [17284.0, 1.0, 6172.0]
    ret = MOI.submit(m, MOI.HeuristicSolution(cb_data), x, x_vals)
    println("** myCallbackHeuristic status = $(ret)")
    return
end

# ╔═╡ da2f7d82-8ed0-47f1-95e9-92fbbd127b66
function myCallbackLazyConstraint(cb_data)
    x = JuMP.all_variables(m)
    x_val = JuMP.callback_value.(cb_data, x)

    if x_val[1] >= 17284.0 - eps(Float16)
        return
    end

    ret = callback_node_status(cb_data, m)
    println("** myCallbackLazyConstraint node_status = $(ret)")

    con = @build_constraint(x[3] == 6172.0)
    ret = MOI.submit(m, MOI.LazyConstraint(cb_data), con)
    println("** myCallbackLazyConstraint status = $(ret)")
    return 17284
end

# ╔═╡ f3210cbd-dffc-46ae-abac-17691942a472
function myCallbackUserCut(cb_data)
    x = JuMP.all_variables(m)
    x_val = JuMP.callback_value.(cb_data, x)

    if x_val[1] >= 17284.0 - eps(Float16)
        return
    end

    ret = callback_node_status(cb_data, m)
    println("** myCallbackUserCut node_status = $(ret)")

    con = @build_constraint(x[3] >= 6172.0)
    ret = MOI.submit(m, MOI.UserCut(cb_data), con)
    println("** myCallbackUserCut status = $(ret)")
    return
end

# ╔═╡ 2957b9a2-860a-4447-b040-8cf1e3d71b0d
begin
    s1 = false
    s2 = false
    s3 = false
    s4 = false
    nothing
end

# ╔═╡ fb641ebc-03fb-4792-94e0-6820bbe82793
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 1 * 1000)

    s1 && MOI.set(m, MOI.HeuristicCallback(), myCallbackHeuristic)
    s2 && MOI.set(m, MOI.LazyConstraintCallback(), myCallbackLazyConstraint)
    s3 && MOI.set(m, MOI.UserCutCallback(), myCallbackUserCut)

    s4 && JuMP.set_optimizer_attribute(m, "fp_heur", GLP_ON)
    s4 && JuMP.set_optimizer_attribute(m, "ps_heur", GLP_ON)
    s4 && JuMP.set_optimizer_attribute(m, "gmi_cuts", GLP_ON)
    s4 && JuMP.set_optimizer_attribute(m, "mir_cuts", GLP_ON)
    s4 && JuMP.set_optimizer_attribute(m, "cov_cuts", GLP_ON)
    s4 && JuMP.set_optimizer_attribute(m, "clq_cuts", GLP_ON)
    s4 && JuMP.set_optimizer_attribute(m, "presolve", true)

    JuMP.optimize!(m)
end

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
JuMP.solution_summary(m)

# ╔═╡ b194ceec-97c1-44c2-b5bb-9d9a26ecdd9b
JuMP.value.([x1, x2, x3])

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═5751108d-6a44-4d33-9386-5d811638c6f0
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╠═46028570-c4ab-4cd8-9fd0-46772e9fb57c
# ╠═da2f7d82-8ed0-47f1-95e9-92fbbd127b66
# ╠═f3210cbd-dffc-46ae-abac-17691942a472
# ╠═2957b9a2-860a-4447-b040-8cf1e3d71b0d
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═b194ceec-97c1-44c2-b5bb-9d9a26ecdd9b
