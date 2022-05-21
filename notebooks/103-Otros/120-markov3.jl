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
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("GLPK")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 23d5d8a6-f2a0-456b-8e39-314488a73fc7
using JuMP, GLPK

# ╔═╡ 4e3a9682-440e-4daf-844c-f9037dcba5a6
using LinearAlgebra

# ╔═╡ 0020f5bc-f2c2-409b-ab19-eeeab7d76132
md"""
## Ejemplo me1
"""

# ╔═╡ f522a42e-83f1-43f9-9029-c854f067ff63
P = [
    0.8 0.2
    0.6 0.4
]

# ╔═╡ 5dbdde79-6d93-40f1-a81c-35e15c91637e
P^1000

# ╔═╡ df03d876-4d5e-42ea-adcd-fbdba584fa39
n, _ = size(P)

# ╔═╡ 4320d7f5-be99-4450-b6fc-3dd823345bb7
begin
    m = Model(GLPK.Optimizer)
    @variable(m, πⱼ[1:n] >= 0)
    @constraint(m, r[j in 1:n], πⱼ[j] == sum(πⱼ[i] * P[i, j] for i in 1:n))
    @constraint(m, r0, sum(πⱼ) == 1.0)
    println(m)
    optimize!(m)
    value.(πⱼ)
end

# ╔═╡ fcd59437-2e20-41ba-976d-1fbc860e558d
begin
    A = [P' - I(n); ones(n)']
    b = [zeros(n); 1.0]
    A \ b
end

# ╔═╡ Cell order:
# ╟─0c0cc340-c27e-11ec-1ce9-2dc92a70fabd
# ╟─0020f5bc-f2c2-409b-ab19-eeeab7d76132
# ╠═f522a42e-83f1-43f9-9029-c854f067ff63
# ╠═5dbdde79-6d93-40f1-a81c-35e15c91637e
# ╠═df03d876-4d5e-42ea-adcd-fbdba584fa39
# ╠═23d5d8a6-f2a0-456b-8e39-314488a73fc7
# ╠═4320d7f5-be99-4450-b6fc-3dd823345bb7
# ╠═4e3a9682-440e-4daf-844c-f9037dcba5a6
# ╠═fcd59437-2e20-41ba-976d-1fbc860e558d
