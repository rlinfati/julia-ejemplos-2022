### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 4ce3202a-dd50-11ec-2e9f-59d442a9cc24
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 4ce32c6e-dd50-11ec-0c34-95689f664566
function f(T::Type)::T
    a::T = 0.1
    b::T = 0.2
    return a + b
end

# ╔═╡ 1da8a04b-4cf4-44ef-b95f-459b8ad828c6
f(Float64)

# ╔═╡ bcbdbe15-0b4a-4a6b-b407-a9272a459ecf
f(Float32)

# ╔═╡ 13ddd5c6-119b-4ddb-9e12-9611e3cf518a
f(Float16)

# ╔═╡ 75938ff8-169b-4e73-97ee-8fbb1105786a
f(BigFloat)

# ╔═╡ Cell order:
# ╟─4ce3202a-dd50-11ec-2e9f-59d442a9cc24
# ╠═4ce32c6e-dd50-11ec-0c34-95689f664566
# ╠═1da8a04b-4cf4-44ef-b95f-459b8ad828c6
# ╠═bcbdbe15-0b4a-4a6b-b407-a9272a459ecf
# ╠═13ddd5c6-119b-4ddb-9e12-9611e3cf518a
# ╠═75938ff8-169b-4e73-97ee-8fbb1105786a
