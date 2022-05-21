### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 9f8f0300-c281-11ec-1395-71f6655a7748
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("Distributions")
        Pkg.PackageSpec("Plots")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 9f8f0328-c281-11ec-0ae8-3f247e5d72f2
using Distributions

# ╔═╡ 9cdff5a7-d4c5-4d1f-b491-2e8e2a7266c4
using Plots

# ╔═╡ 4fd4230a-060e-4492-a849-e0bdf585c292
md"""
## Ejemplo 2
"""

# ╔═╡ 277f6f09-61ee-468c-915b-1316c1702240
dp = Poisson(1.0)

# ╔═╡ 5ad74f0e-c235-422c-a021-a31ad634f989
dt = [0, rand(dp, 10)...]

# ╔═╡ 0f0413ec-a450-4f21-a667-68ae9d4e3123
begin
    xt = zero(dt)
    xt[1] = 3
    xt
end

# ╔═╡ 979f8b27-3750-460d-a746-02432ff7647e
for i in eachindex(xt)
    if i == length(xt)
        continue
    end

    xt[i+1] = xt[i] == 0 ? max(0, 3 - dt[i+1]) : max(0, xt[i] - dt[i+1])
end

# ╔═╡ bd2e68a5-a6e5-486e-b79f-9df34b876d96
0 == 0 ? "Es cero" : "NO ES CERO"

# ╔═╡ 4315473d-f4fb-410f-b9ab-adee8c122bc2
123 == 0 ? "Es cero" : "NO ES CERO"

# ╔═╡ 2b51fb07-1ace-4b3b-872e-ca66f201fdb8
[0:10 dt xt]

# ╔═╡ ead29dc5-c5f2-4382-9028-ae5cd87dad70
begin
    plot(dt, label = "dt")
    plot!(xt, label = "xt")
end

# ╔═╡ 4f11dbed-551d-44e5-b70d-bf9e429240e6
md"""
## Ejemplo 3
"""

# ╔═╡ 515a5300-7f11-4855-a883-4b27511b5057
begin
    p2 = 0.5
    x2 = [5; zeros(20)]
end

# ╔═╡ 8d0b49d8-018c-4e1f-b6db-3b59877fd6ac
for i in eachindex(x2)
    if i == length(x2)
        continue
    end
    if x2[i] == 0
        x2[i+1] = 0
        continue
    end
    if x2[i] == 10
        x2[i+1] = 10
        continue
    end
    x2[i+1] = rand() < p2 ? x2[i] + 1 : x2[i] - 1
end

# ╔═╡ 135c49fa-4ca3-4895-a54a-195eabbc8c0d
[0:20 x2]

# ╔═╡ c6e40f9c-5133-4d8f-a27d-6234415d06b4
plot(x2)

# ╔═╡ Cell order:
# ╟─9f8f0300-c281-11ec-1395-71f6655a7748
# ╠═9f8f0328-c281-11ec-0ae8-3f247e5d72f2
# ╠═9cdff5a7-d4c5-4d1f-b491-2e8e2a7266c4
# ╟─4fd4230a-060e-4492-a849-e0bdf585c292
# ╠═277f6f09-61ee-468c-915b-1316c1702240
# ╠═5ad74f0e-c235-422c-a021-a31ad634f989
# ╠═0f0413ec-a450-4f21-a667-68ae9d4e3123
# ╠═979f8b27-3750-460d-a746-02432ff7647e
# ╠═bd2e68a5-a6e5-486e-b79f-9df34b876d96
# ╠═4315473d-f4fb-410f-b9ab-adee8c122bc2
# ╠═2b51fb07-1ace-4b3b-872e-ca66f201fdb8
# ╠═ead29dc5-c5f2-4382-9028-ae5cd87dad70
# ╟─4f11dbed-551d-44e5-b70d-bf9e429240e6
# ╠═515a5300-7f11-4855-a883-4b27511b5057
# ╠═8d0b49d8-018c-4e1f-b6db-3b59877fd6ac
# ╠═135c49fa-4ca3-4895-a54a-195eabbc8c0d
# ╠═c6e40f9c-5133-4d8f-a27d-6234415d06b4
