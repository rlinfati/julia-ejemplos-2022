### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 5bb1052e-de16-11ec-2f1a-15892ed32ed0
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([Pkg.PackageSpec("Distributions")])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 5bb11156-de16-11ec-1cbd-f571cab18749
using Distributions

# ╔═╡ b011cda8-3632-431f-b732-f3198022972d
using Random

# ╔═╡ 897f34ae-a697-4434-a5c8-4c392b02c70d
begin
    λ = 1 / 45
    μ = 1 / 20
    ρ = λ / μ
    W = inv(μ - λ)
    Wq = ρ * W
    ρ, W, Wq
end

# ╔═╡ f9923c19-9a6a-4317-b3e5-b7892fa69ae9
n = 1e2

# ╔═╡ 415ff7d2-a47f-465f-a76e-6f9762391069
@time let
    din = Distributions.Exponential(1 / λ)
    dout = Distributions.Exponential(1 / μ)

    sum_rout = 0.0
    sum_w = 0.0
    diff_t = 0.0

    tin = 0.0
    tout = 0.0

    for _ in 1:n
        rin = rand(din)
        rout = rand(dout)

        sum_rout += rout
        sum_w += max(0.0, tout - tin - rin)

        tin += rin
        tout = max(tin, tout) + rout

        diff_t += tout - tin
    end

    ρ = sum_rout / tout
    W = diff_t / n
    Wq = sum_w / n

    ρ, W, Wq
end

# ╔═╡ Cell order:
# ╟─5bb1052e-de16-11ec-2f1a-15892ed32ed0
# ╠═5bb11156-de16-11ec-1cbd-f571cab18749
# ╠═b011cda8-3632-431f-b732-f3198022972d
# ╠═897f34ae-a697-4434-a5c8-4c392b02c70d
# ╠═f9923c19-9a6a-4317-b3e5-b7892fa69ae9
# ╠═415ff7d2-a47f-465f-a76e-6f9762391069
