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
## Ejemplo m2
"""

# ╔═╡ f522a42e-83f1-43f9-9029-c854f067ff63
p(n::Int) = exp(-1) / factorial(n)

# ╔═╡ 5dbdde79-6d93-40f1-a81c-35e15c91637e
p2(n::Int) = pdf(Poisson(1.0), n)

# ╔═╡ d65f9b77-4e50-4e36-82d5-b78b034617a6
for i in 0:10
    @show i, p2(i) == p(i)
end

# ╔═╡ d13e8192-fe12-44b0-a3a1-5e49c1a1ba18
for i in 0:10
    @show i, p2(i) ≈ p(i)
end

# ╔═╡ 02625705-be8c-415e-b032-c2eddeeca0b4
P = [
    1-(p(0)+p(1)+p(2)) p(2) p(1) p(0)
    1-p(0) p(0) 0 0
    1-p(0)-p(1) p(1) p(0) 0
    1-(p(0)+p(1)+p(2)) p(2) p(1) p(0)
]

# ╔═╡ 66c3c77c-2f09-4f1f-9071-2defceceeae9
P * P

# ╔═╡ fbf92a57-bfb1-4b52-9784-7788e02fd7d2
P^3

# ╔═╡ 055aa947-4df9-4d4f-a19b-0f90b748a014
P^4

# ╔═╡ a20e82f3-7519-41e1-9ecc-42a20ea47842
P^10

# ╔═╡ c31cf468-b2ac-47f2-8d0f-0c838c11a245
P^100

# ╔═╡ 3ee85736-b104-4eec-8783-daaeb1784bea
P^500

# ╔═╡ 94a10135-3f7c-45fb-85d8-8f4919ea88ae
P^1000

# ╔═╡ Cell order:
# ╟─0c0cc340-c27e-11ec-1ce9-2dc92a70fabd
# ╠═0c1184de-c27e-11ec-33ea-ab4d518e8033
# ╠═0c118506-c27e-11ec-2bf2-b9123001bcfb
# ╟─0020f5bc-f2c2-409b-ab19-eeeab7d76132
# ╠═f522a42e-83f1-43f9-9029-c854f067ff63
# ╠═5dbdde79-6d93-40f1-a81c-35e15c91637e
# ╠═d65f9b77-4e50-4e36-82d5-b78b034617a6
# ╠═d13e8192-fe12-44b0-a3a1-5e49c1a1ba18
# ╠═02625705-be8c-415e-b032-c2eddeeca0b4
# ╠═66c3c77c-2f09-4f1f-9071-2defceceeae9
# ╠═fbf92a57-bfb1-4b52-9784-7788e02fd7d2
# ╠═055aa947-4df9-4d4f-a19b-0f90b748a014
# ╠═a20e82f3-7519-41e1-9ecc-42a20ea47842
# ╠═c31cf468-b2ac-47f2-8d0f-0c838c11a245
# ╠═3ee85736-b104-4eec-8783-daaeb1784bea
# ╠═94a10135-3f7c-45fb-85d8-8f4919ea88ae
