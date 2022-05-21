### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 0c0cc340-c27e-11ec-1ce9-2dc92a70fabd
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

# ╔═╡ 0c1184de-c27e-11ec-33ea-ab4d518e8033
using Distributions

# ╔═╡ 0c118506-c27e-11ec-2bf2-b9123001bcfb
using Plots

# ╔═╡ 0020f5bc-f2c2-409b-ab19-eeeab7d76132
md"""
## Distribución Normal
"""

# ╔═╡ f522a42e-83f1-43f9-9029-c854f067ff63
dn = Distributions.Normal(0.0, 1.0)

# ╔═╡ 02625705-be8c-415e-b032-c2eddeeca0b4
xn = rand(dn, 100_000)

# ╔═╡ 66c3c77c-2f09-4f1f-9071-2defceceeae9
mean(xn), std(xn), var(xn)

# ╔═╡ fbf92a57-bfb1-4b52-9784-7788e02fd7d2
Distributions.fit_mle(Normal, xn)

# ╔═╡ ea88916a-d20a-4526-91c2-d036750c1ec7
plot(xn, seriestype = :hist)

# ╔═╡ 7144a521-ab34-496b-ab55-be2c4265be61
Distributions.quantile(dn, 0.01), Distributions.quantile(dn, 0.5), Distributions.quantile(dn, 0.99)

# ╔═╡ 66026cd0-d26f-4a59-b8b1-b41a1722e86b
Distributions.quantile(dn, 1 / 3), Distributions.quantile(dn, 1 - 1 / 3)

# ╔═╡ 7d2826fa-6e61-49be-a5e9-f8256fc9020f
Distributions.quantile(dn, 1 / 10), Distributions.quantile(dn, 1 - 1 / 10)

# ╔═╡ 9bba981a-0b56-4c65-94e8-2f27a8b3b878
Distributions.quantile(dn, 1 / 20), Distributions.quantile(dn, 1 - 1 / 20)

# ╔═╡ 80a2ffbe-0755-4a3f-8b1e-31daac8cf4fc
Distributions.quantile(dn, 1 / 100), Distributions.quantile(dn, 1 - 1 / 100)

# ╔═╡ 04c3d3ba-2d9f-4449-bc21-5ec9d8b661cf
Distributions.quantile(dn, 1 / 1000), Distributions.quantile(dn, 1 - 1 / 1000)

# ╔═╡ 4e9edcfe-9a72-4716-8f7f-10af9f11120c
Distributions.cdf(dn, 0.0)

# ╔═╡ ef7f17ae-4722-41d9-996c-e153e1640bba
Distributions.cdf(dn, 2.0)

# ╔═╡ bdafcf54-e296-438a-aab9-c8db813c068b
Distributions.cdf(dn, 3.0)

# ╔═╡ d4a49615-e547-4bd3-9d5a-8bada17e2de8
md"""
## Distribución Exponencial
"""

# ╔═╡ bed7f273-d60e-43fc-b73a-a66bf4198f36
begin
    de = Distributions.Exponential()
    xe = rand(de, 100_000)
    @show mean(xe)
    @show std(xe)
    @show var(xe)
    plot(xe, seriestype = :hist)
end

# ╔═╡ ee337b8f-06fa-49de-8b15-580344bd5bf7
de

# ╔═╡ 8dea7530-7fa4-4ba2-8df5-8cfe8908c8f5
md"""
## Distribución Poisson
"""

# ╔═╡ 0957aa3e-dbfc-4ee0-8b06-4d5d4f687773
begin
    dp = Distributions.Poisson()
    xp = rand(dp, 100_000)
    @show mean(xp)
    @show std(xp)
    @show var(xp)
    plot(xp, seriestype = :hist)
end

# ╔═╡ b71b87d7-7f06-4304-ba63-330510c3837c
dp

# ╔═╡ 9e846d4e-c9da-47ef-bed1-fd635ea4c44b
md"""
## Distribución Chi Square
"""

# ╔═╡ cb9dee60-22f4-44e9-98a5-62f145b50257
begin
    dc = Distributions.Chisq(30)
    xc = rand(dc, 100_000)
    @show mean(xc)
    @show std(xc)
    @show var(xc)
    plot(xc, seriestype = :hist)
end

# ╔═╡ 055aa947-4df9-4d4f-a19b-0f90b748a014
dc

# ╔═╡ Cell order:
# ╟─0c0cc340-c27e-11ec-1ce9-2dc92a70fabd
# ╠═0c1184de-c27e-11ec-33ea-ab4d518e8033
# ╠═0c118506-c27e-11ec-2bf2-b9123001bcfb
# ╟─0020f5bc-f2c2-409b-ab19-eeeab7d76132
# ╠═f522a42e-83f1-43f9-9029-c854f067ff63
# ╠═02625705-be8c-415e-b032-c2eddeeca0b4
# ╠═66c3c77c-2f09-4f1f-9071-2defceceeae9
# ╠═fbf92a57-bfb1-4b52-9784-7788e02fd7d2
# ╠═ea88916a-d20a-4526-91c2-d036750c1ec7
# ╠═7144a521-ab34-496b-ab55-be2c4265be61
# ╠═66026cd0-d26f-4a59-b8b1-b41a1722e86b
# ╠═7d2826fa-6e61-49be-a5e9-f8256fc9020f
# ╠═9bba981a-0b56-4c65-94e8-2f27a8b3b878
# ╠═80a2ffbe-0755-4a3f-8b1e-31daac8cf4fc
# ╠═04c3d3ba-2d9f-4449-bc21-5ec9d8b661cf
# ╠═4e9edcfe-9a72-4716-8f7f-10af9f11120c
# ╠═ef7f17ae-4722-41d9-996c-e153e1640bba
# ╠═bdafcf54-e296-438a-aab9-c8db813c068b
# ╟─d4a49615-e547-4bd3-9d5a-8bada17e2de8
# ╠═bed7f273-d60e-43fc-b73a-a66bf4198f36
# ╠═ee337b8f-06fa-49de-8b15-580344bd5bf7
# ╟─8dea7530-7fa4-4ba2-8df5-8cfe8908c8f5
# ╠═0957aa3e-dbfc-4ee0-8b06-4d5d4f687773
# ╠═b71b87d7-7f06-4304-ba63-330510c3837c
# ╟─9e846d4e-c9da-47ef-bed1-fd635ea4c44b
# ╠═cb9dee60-22f4-44e9-98a5-62f145b50257
# ╠═055aa947-4df9-4d4f-a19b-0f90b748a014
