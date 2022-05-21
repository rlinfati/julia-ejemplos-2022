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
        Pkg.PackageSpec("CSV")
        Pkg.PackageSpec("DataFrames")
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
using Downloads

# ╔═╡ 77e99cc5-4010-4c81-b2a4-f09c51d906b5
using CSV

# ╔═╡ 9de8b7d4-8cd8-40cb-9efb-2483168167b2
using DataFrames

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
## Passpoer Index Problem
"""

# ╔═╡ 5830787c-f6da-4e56-a07c-d9867e216447
url = "https://github.com/ilyankou/passport-index-dataset/raw/master/passport-index-matrix.csv"

# ╔═╡ a34840ca-03b0-445a-9e37-c3e87f355ab6
pim = Downloads.download(url)

# ╔═╡ b2a2567c-3fd8-4990-b42b-c2309a4d24ff
function txt2bin(x)
    if x == "visa free"
        return 1
    elseif x == "visa on arrival"
        return 1
    elseif x == "e-visa"
        return 0
    elseif x == "visa required"
        return 0
    elseif x == "covid ban"
        return 0
    elseif x == "no admission"
        return 0
    elseif x == "-1" || x == -1
        return 1
    elseif x == "7"
        return 1
    elseif x == "14"
        return 1
    elseif x == "15"
        return 1
    elseif x == "21"
        return 1
    elseif x == "28"
        return 1
    elseif x == "30"
        return 1
    elseif x == "31"
        return 1
    elseif x == "42"
        return 1
    elseif x == "45"
        return 1
    elseif x == "60"
        return 1
    elseif x == "90"
        return 1
    elseif x == "120"
        return 1
    elseif x == "180"
        return 1
    elseif x == "240"
        return 1
    elseif x == "360"
        return 1
    elseif 1 <= x <= 365
        return 1
    else
        println(x)
        return x
    end
end

# ╔═╡ 55daa79c-57ed-4f7f-9933-82ac75d02573
begin
    passportData = CSV.File(pim) |> DataFrame
    for country in passportData.Passport
        passportData[!, country] = txt2bin.(passportData[!, country])
    end
    # passportData = txt2bin.(passportData)
end

# ╔═╡ 660d13f9-d7b4-4f8d-86a3-7d9a28afa099
passportData[!, ["Passport", "Chile", "Brazil", "Italy"]]

# ╔═╡ dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
begin
    m = JuMP.Model()

    paises = passportData[!, "Passport"]

    @variable(m, x[paises], Bin)
    @objective(m, Min, sum(x))
    @constraint(m, [p in paises], sum(passportData[!, p] .* x) >= 1)

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
optimalPassport = [c for c in paises if xval[c] ≈ 1.0]

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═4d16271c-f24a-42c4-af86-7d99a753fa7f
# ╠═77e99cc5-4010-4c81-b2a4-f09c51d906b5
# ╠═9de8b7d4-8cd8-40cb-9efb-2483168167b2
# ╟─76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═5830787c-f6da-4e56-a07c-d9867e216447
# ╠═a34840ca-03b0-445a-9e37-c3e87f355ab6
# ╠═b2a2567c-3fd8-4990-b42b-c2309a4d24ff
# ╠═55daa79c-57ed-4f7f-9933-82ac75d02573
# ╠═660d13f9-d7b4-4f8d-86a3-7d9a28afa099
# ╠═dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╟─0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═54034f8e-d846-45fc-ad0a-31920e40114c
# ╠═52293f2a-3c29-4a0b-bf4c-500c57538509
