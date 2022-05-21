### A Pluto.jl notebook ###
# v0.19.2

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

# ╔═╡ 1d70a3da-b5d1-4d72-9175-a122e18dc781
begin
    m = JuMP.Model()

    @variable(m, x[i in 1:9, j in 1:9, k in 1:9], Bin)

    @constraint(m, r1[j in 1:9, k in 1:9], sum(x[:, j, k]) == 1)
    @constraint(m, r2[i in 1:9, k in 1:9], sum(x[i, :, k]) == 1)
    @constraint(m, r3[i in 1:9, j in 1:9], sum(x[i, j, :]) == 1)

    @constraint(m, r4[r in 0:2, s in 0:2, k in 1:9], sum(x[i+3r, j+3s, k] for i in 1:3, j in 1:3) == 1)

    nothing
end

# ╔═╡ b0014954-02bd-4ba5-a4c4-f85ecca990c9
JuMP.latex_formulation(m);

# ╔═╡ a16e54d1-ef42-47dc-8d74-d6445c42c428
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ c837b5d2-76ca-4741-a254-6d72c37cbe5e
JuMP.solution_summary(m)

# ╔═╡ 1a1b23fe-fb4b-4e40-b1b3-59d995e0e27c
xval = round.(Int, JuMP.value.(x))

# ╔═╡ 67fbbeeb-4dfd-489b-a12f-0ac51cb2691a
sol = [sum(k * xval[i, j, k] for k in 1:9) for i in 1:9, j in 1:9]

# ╔═╡ ddc96a6e-8b22-433d-a8e9-de2f36c9b5c4
parSol = [
    5 3 0 0 7 0 0 0 0
    6 0 0 1 9 5 0 0 0
    0 9 8 0 0 0 0 6 0
    8 0 0 0 6 0 0 0 3
    4 0 0 8 0 3 0 0 1
    7 0 0 0 2 0 0 0 6
    0 6 0 0 0 0 2 8 0
    0 0 0 4 1 9 0 0 5
    0 0 0 0 8 0 0 7 9
]

# ╔═╡ 22e9b0ac-762e-47c2-a7c9-78080867b721
m2 = copy(m)

# ╔═╡ 07c1cbec-d2f9-4386-ad41-f8f615ad6880
x2 = m2[:x];

# ╔═╡ 7de1d0e2-ca5a-438b-bf31-5a25e44e10ce
for i in 1:9, j in 1:9
    if parSol[i, j] != 0
        fix(x2[i, j, parSol[i, j]], 1)
    end
end

# ╔═╡ 3abea7e9-fd9d-402e-9429-f03f24019a2e
begin
    JuMP.set_optimizer(m2, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m2, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m2, "tm_lim", 60 * 1000)
    JuMP.optimize!(m2)
end

# ╔═╡ 0da56218-4059-4d24-8a33-cec0f7cad36e
JuMP.solution_summary(m2)

# ╔═╡ 8f5c11f3-eeef-4e44-a385-734ee948a32f
xval2 = round.(Int, JuMP.value.(x2));

# ╔═╡ 834a2d2a-023e-4c11-8078-ef4c050a5d16
sol2 = [sum(k * xval2[i, j, k] for k in 1:9) for i in 1:9, j in 1:9]

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═1d70a3da-b5d1-4d72-9175-a122e18dc781
# ╠═b0014954-02bd-4ba5-a4c4-f85ecca990c9
# ╠═a16e54d1-ef42-47dc-8d74-d6445c42c428
# ╠═c837b5d2-76ca-4741-a254-6d72c37cbe5e
# ╠═1a1b23fe-fb4b-4e40-b1b3-59d995e0e27c
# ╠═67fbbeeb-4dfd-489b-a12f-0ac51cb2691a
# ╠═ddc96a6e-8b22-433d-a8e9-de2f36c9b5c4
# ╠═22e9b0ac-762e-47c2-a7c9-78080867b721
# ╠═07c1cbec-d2f9-4386-ad41-f8f615ad6880
# ╠═7de1d0e2-ca5a-438b-bf31-5a25e44e10ce
# ╠═3abea7e9-fd9d-402e-9429-f03f24019a2e
# ╠═0da56218-4059-4d24-8a33-cec0f7cad36e
# ╠═8f5c11f3-eeef-4e44-a385-734ee948a32f
# ╠═834a2d2a-023e-4c11-8078-ef4c050a5d16
