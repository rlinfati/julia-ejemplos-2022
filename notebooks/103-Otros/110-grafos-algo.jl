### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 47e373da-ac3c-11ec-01f3-4d2837d60a99
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("Graphs")
        Pkg.PackageSpec("GraphPlot")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 6e981460-39dd-489c-940f-4eca90ca70c1
using Graphs

# ╔═╡ 2939084c-bdec-48ec-8497-df1d89b3f61d
using GraphPlot

# ╔═╡ 483ccbef-7a70-4730-afaa-31ecc6c82fb4
g = random_regular_graph(10, 3)

# ╔═╡ c35a3606-86dc-4ca3-916b-bc8e50579f96
gplot(g, nodelabel = 1:nv(g))

# ╔═╡ cfed8ee1-6c47-4785-8e5b-6f0447a88828
Graphs.degree_greedy_color(g)

# ╔═╡ a092e819-88de-4052-8b61-2c3eb8d577c0
Graphs.greedy_color(g)

# ╔═╡ d7ed5f25-a6ad-430b-8a11-4cdef21f838c
dijkstra_shortest_paths(g, 1)

# ╔═╡ Cell order:
# ╟─47e373da-ac3c-11ec-01f3-4d2837d60a99
# ╠═6e981460-39dd-489c-940f-4eca90ca70c1
# ╠═2939084c-bdec-48ec-8497-df1d89b3f61d
# ╠═483ccbef-7a70-4730-afaa-31ecc6c82fb4
# ╠═c35a3606-86dc-4ca3-916b-bc8e50579f96
# ╠═cfed8ee1-6c47-4785-8e5b-6f0447a88828
# ╠═a092e819-88de-4052-8b61-2c3eb8d577c0
# ╠═d7ed5f25-a6ad-430b-8a11-4cdef21f838c
