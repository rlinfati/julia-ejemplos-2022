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
        Pkg.PackageSpec("JSON")
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

# ╔═╡ 4d16271c-f24a-42c4-af86-7d99a753fa7f
using JSON

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
## Transport Problem
"""

# ╔═╡ 5830787c-f6da-4e56-a07c-d9867e216447
data = JSON.parse("""
{
    "plants": {
        "Seattle": {"capacity": 350},
        "San-Diego": {"capacity": 600}
    },
    "markets": {
        "New-York": {"demand": 300},
        "Chicago": {"demand": 300},
        "Topeka": {"demand": 300}
    },
    "distances": {
        "Seattle => New-York": 2.5,
        "Seattle => Chicago": 1.7,
        "Seattle => Topeka": 1.8,
        "San-Diego => New-York": 2.5,
        "San-Diego => Chicago": 1.8,
        "San-Diego => Topeka": 1.4
    }
}
""")

# ╔═╡ 55daa79c-57ed-4f7f-9933-82ac75d02573
O = keys(data["plants"])

# ╔═╡ 660d13f9-d7b4-4f8d-86a3-7d9a28afa099
D = keys(data["markets"])

# ╔═╡ 3f5e6e89-fa10-4cfe-8715-4e8a6d923b78
distance(i::String, j::String) = data["distances"]["$(i) => $(j)"]

# ╔═╡ dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
begin
    m = JuMP.Model()

    @variable(m, x[O, D] >= 0)

    @objective(m, Min, sum(distance(i, j) * x[i, j] for i in O, j in D))
    @constraint(m, [i in O], sum(x[i, :]) <= data["plants"][i]["capacity"])
    @constraint(m, [j in D], sum(x[:, j]) >= data["markets"][j]["demand"])

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

# ╔═╡ 54034f8e-d846-45fc-ad0a-31920e40114c
xval = JuMP.value.(x)

# ╔═╡ 52293f2a-3c29-4a0b-bf4c-500c57538509
for i in O, j in D
    println(i, " => ", j, ": ", xval[i, j])
end

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═4d16271c-f24a-42c4-af86-7d99a753fa7f
# ╟─76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═5830787c-f6da-4e56-a07c-d9867e216447
# ╠═55daa79c-57ed-4f7f-9933-82ac75d02573
# ╠═660d13f9-d7b4-4f8d-86a3-7d9a28afa099
# ╠═3f5e6e89-fa10-4cfe-8715-4e8a6d923b78
# ╠═dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╟─0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═54034f8e-d846-45fc-ad0a-31920e40114c
# ╠═52293f2a-3c29-4a0b-bf4c-500c57538509
