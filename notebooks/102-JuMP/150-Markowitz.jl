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
        Pkg.PackageSpec("Ipopt")
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
using Ipopt

# ╔═╡ 4d16271c-f24a-42c4-af86-7d99a753fa7f
using Statistics

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
## Portfolio Optimization
"""

# ╔═╡ 8a14c5b5-c03a-4af6-bc2c-ec4cc03ac7cf
stock_data = [
    93.043 51.826 1.063
    84.585 52.823 0.938
    111.453 56.477 1.000
    99.525 49.805 0.938
    95.819 50.287 1.438
    114.708 51.521 1.700
    111.515 51.531 2.540
    113.211 48.664 2.390
    104.942 55.744 3.120
    99.827 47.916 2.980
    91.607 49.438 1.900
    107.937 51.336 1.750
    115.590 55.081 1.800
]

# ╔═╡ 5830787c-f6da-4e56-a07c-d9867e216447
begin
    stock_returns = Array{Float64}(undef, 12, 3)
    for i in 1:12
        stock_returns[i, :] = (stock_data[i+1, :] .- stock_data[i, :]) ./ stock_data[i, :]
    end
    stock_returns
end

# ╔═╡ 55daa79c-57ed-4f7f-9933-82ac75d02573
r = Statistics.mean(stock_returns, dims = 1) |> vec

# ╔═╡ 660d13f9-d7b4-4f8d-86a3-7d9a28afa099
Q = Statistics.cov(stock_returns)

# ╔═╡ dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
begin
    m = JuMP.Model()
    t, n = size(stock_returns)

    @variable(m, x[1:n] >= 0)
    @objective(m, Min, x' * Q * x)
    @constraint(m, sum(x) <= 1_000)
    @constraint(m, sum(r .* x) >= 50)

    nothing
end

# ╔═╡ 9e9cd503-c8f0-42f7-b26a-f1d6305db0b9
r .* x

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
JuMP.latex_formulation(m);

# ╔═╡ fb641ebc-03fb-4792-94e0-6820bbe82793
begin
    JuMP.set_optimizer(m, Ipopt.Optimizer)
    JuMP.optimize!(m)
end

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
JuMP.solution_summary(m)

# ╔═╡ 54034f8e-d846-45fc-ad0a-31920e40114c
xval = JuMP.value.(x)

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═4d16271c-f24a-42c4-af86-7d99a753fa7f
# ╟─76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═8a14c5b5-c03a-4af6-bc2c-ec4cc03ac7cf
# ╠═5830787c-f6da-4e56-a07c-d9867e216447
# ╠═55daa79c-57ed-4f7f-9933-82ac75d02573
# ╠═660d13f9-d7b4-4f8d-86a3-7d9a28afa099
# ╠═dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
# ╠═9e9cd503-c8f0-42f7-b26a-f1d6305db0b9
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═54034f8e-d846-45fc-ad0a-31920e40114c
