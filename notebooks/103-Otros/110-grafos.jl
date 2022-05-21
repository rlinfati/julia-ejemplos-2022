### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 47e373da-ac3c-11ec-01f3-4d2837d60a99
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add(
        [
            Pkg.PackageSpec("Graphs")
            Pkg.PackageSpec("GraphPlot")
            Pkg.PackageSpec("SimpleWeightedGraphs")
            Pkg.PackageSpec("MetaGraphs")
        ],
    )
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

# ╔═╡ 852263c5-95a2-4c48-b3c8-c3674439e7be
using SimpleWeightedGraphs

# ╔═╡ 5ff1b6b0-9079-4e8f-b05b-1924debd676b
using MetaGraphs

# ╔═╡ 70c51d9b-6162-4bad-b248-34fd8279674f
md"""
## SimpleGraph
"""

# ╔═╡ 483ccbef-7a70-4730-afaa-31ecc6c82fb4
begin
    G = SimpleDiGraph(3) # SimpleGraph vs SimpleDiGraph
    add_edge!(G, 1, 2)
    add_edge!(G, 1, 3)
    add_edge!(G, 2, 3)
    add_vertex!(G)
    add_edge!(G, 4, 3)
    add_edge!(G, 4, 2)
    add_edge!(G, 4, 4)
end

# ╔═╡ 9f9e7ec8-87e8-40e7-a7f5-6ba6efadba4c
nv(G), ne(G)

# ╔═╡ 04f6a2fb-c2c1-4743-9062-8df6830a38e6
neighbors(G, 2)

# ╔═╡ 73a4f143-0827-46a9-a4ea-2ab8884c45d9
has_self_loops(G)

# ╔═╡ b1c34079-4628-43fb-96cb-dedc61f2086f
is_directed(G)

# ╔═╡ 846d5d56-7280-4c97-870d-506a19151938
adjacency_matrix(G)

# ╔═╡ 29643bfb-6ed8-4825-bf36-df25c73a092f
SimpleDiGraph([
    0 1 1 0
    0 0 1 0
    0 0 0 0
    0 1 1 1
]) == G

# ╔═╡ 14b7e0b5-2031-4d04-b930-68f4a190d9fd
gplot(G)

# ╔═╡ 4448ddc4-984d-4a0b-8385-43cdc693fd19
el = 'a':1:'a'+ne(G)-1

# ╔═╡ 88fd024f-0a7d-4950-8fe6-4a2315a2207e
collect(el)

# ╔═╡ 7d7c5150-67da-4134-a483-77d3ab8c9dc6
gplot(G, nodelabel = 1:nv(G), edgelabel = el)

# ╔═╡ a91d0bff-e35b-4630-a950-36a0f9d397cc
md"""
[Ejemplos de visualización](https://juliagraphs.org/Graphs.jl/dev/first_steps/plotting/)
"""

# ╔═╡ c4b5ff28-6a1b-429c-abcf-bbfd5b201175
for e in edges(G)
    u, v = src(e), dst(e)
    println("edge $u - $v")
end

# ╔═╡ 0b79854e-6acd-4d93-9050-b8eb6ddabf22
gplot(complete_graph(5))

# ╔═╡ ad9d6b4e-c773-417a-86f9-a0c1d3ffd929
gplot(cycle_graph(5))

# ╔═╡ 3d96e179-043d-46fb-ac51-028c78a72f89
gplot(star_graph(5))

# ╔═╡ 5037eb8a-2368-4fb4-93d9-5ad64e0ce953
gplot(wheel_graph(6))

# ╔═╡ fbb57827-f5de-4053-b539-950ce579df54
gplot(clique_graph(5, 1))

# ╔═╡ fc736afc-9149-494f-a6c3-d3371fb589c8
gplot(clique_graph(5, 3))

# ╔═╡ dc77ae0c-0993-4a56-a4ab-141594e5cc0e
gplot(binary_tree(5))

# ╔═╡ 14800520-451b-461a-93ed-a0a992cb10ac
gplot(complete_bipartite_graph(2, 3))

# ╔═╡ 42a132e2-0f56-4911-9a99-caf6a3103646
gplot(lollipop_graph(5, 3))

# ╔═╡ e4265386-02fd-4f0c-b5bc-73c3415f5746
md"""
## SimpleWeightedGraphs
"""

# ╔═╡ 2a33f3de-2f17-48b7-8707-8af35edd344a
begin
    sources = [1, 1, 2]
    destinations = [2, 3, 3]
    weight = [0.5, 2.0, 0.8]
    wg = SimpleWeightedGraph(sources, destinations, weight)
    # SimpleWeightedGraph vs SimpleWeightedDiGraph
    # NOTA: los pesos van en el orden interno del grafo
end

# ╔═╡ f1bc5462-b4de-4274-abac-4deb7b420283
adjacency_matrix(wg)

# ╔═╡ 48a477a5-3096-43e5-a869-ac620f1f5265
gplot(wg, nodelabel = 1:nv(wg), edgelabel = weight)

# ╔═╡ 42ccd1af-9ffc-4e9c-9af8-1d8f9131bdb1
dijkstra_shortest_paths(wg, 1)

# ╔═╡ 650801e4-02f1-4942-81d2-efacd1e94b16
enumerate_paths(dijkstra_shortest_paths(wg, 1), 3)

# ╔═╡ fb0b7590-4a14-4b9c-ad39-61b302b09bff
md"""
## MetaGraphs
"""

# ╔═╡ 20f0eba8-477f-49f0-a130-e509d2d31898
mg = MetaGraph(path_graph(5), 3.0) # MetaGraph vs MetaDiGraph

# ╔═╡ 573c3e3d-c1c4-4e6e-8883-ca2b35918dc9
set_prop!(mg, :description, "This is a metagraph.")

# ╔═╡ 48dccb5f-5995-4db4-a00c-5a80634955dd
set_prop!(mg, 1, :name, "John")

# ╔═╡ 65770c86-a953-4bde-a313-da362f923651
set_props!(mg, 2, Dict(:name => "Susan", :id => 123))

# ╔═╡ 5d2e5fa1-9abb-438f-99bb-bd638954d975
set_prop!(mg, Edge(1, 2), :action, "knows")

# ╔═╡ f0238e4a-aaba-42d9-97c0-2497c4f1fe5b
props(mg, 1)

# ╔═╡ b4bbf4ec-4522-4ed0-a328-16a37e7d4559
props(mg, Edge(1, 2))

# ╔═╡ e1c57412-e2db-4b8f-825c-4b20d599f4ea
get_prop(mg, 2, :name)

# ╔═╡ Cell order:
# ╟─47e373da-ac3c-11ec-01f3-4d2837d60a99
# ╠═6e981460-39dd-489c-940f-4eca90ca70c1
# ╠═2939084c-bdec-48ec-8497-df1d89b3f61d
# ╟─70c51d9b-6162-4bad-b248-34fd8279674f
# ╠═483ccbef-7a70-4730-afaa-31ecc6c82fb4
# ╠═9f9e7ec8-87e8-40e7-a7f5-6ba6efadba4c
# ╠═04f6a2fb-c2c1-4743-9062-8df6830a38e6
# ╠═73a4f143-0827-46a9-a4ea-2ab8884c45d9
# ╠═b1c34079-4628-43fb-96cb-dedc61f2086f
# ╠═846d5d56-7280-4c97-870d-506a19151938
# ╠═29643bfb-6ed8-4825-bf36-df25c73a092f
# ╠═14b7e0b5-2031-4d04-b930-68f4a190d9fd
# ╠═4448ddc4-984d-4a0b-8385-43cdc693fd19
# ╠═88fd024f-0a7d-4950-8fe6-4a2315a2207e
# ╠═7d7c5150-67da-4134-a483-77d3ab8c9dc6
# ╟─a91d0bff-e35b-4630-a950-36a0f9d397cc
# ╠═c4b5ff28-6a1b-429c-abcf-bbfd5b201175
# ╠═0b79854e-6acd-4d93-9050-b8eb6ddabf22
# ╠═ad9d6b4e-c773-417a-86f9-a0c1d3ffd929
# ╠═3d96e179-043d-46fb-ac51-028c78a72f89
# ╠═5037eb8a-2368-4fb4-93d9-5ad64e0ce953
# ╠═fbb57827-f5de-4053-b539-950ce579df54
# ╠═fc736afc-9149-494f-a6c3-d3371fb589c8
# ╠═dc77ae0c-0993-4a56-a4ab-141594e5cc0e
# ╠═14800520-451b-461a-93ed-a0a992cb10ac
# ╠═42a132e2-0f56-4911-9a99-caf6a3103646
# ╟─e4265386-02fd-4f0c-b5bc-73c3415f5746
# ╠═852263c5-95a2-4c48-b3c8-c3674439e7be
# ╠═2a33f3de-2f17-48b7-8707-8af35edd344a
# ╠═f1bc5462-b4de-4274-abac-4deb7b420283
# ╠═48a477a5-3096-43e5-a869-ac620f1f5265
# ╠═42ccd1af-9ffc-4e9c-9af8-1d8f9131bdb1
# ╠═650801e4-02f1-4942-81d2-efacd1e94b16
# ╟─fb0b7590-4a14-4b9c-ad39-61b302b09bff
# ╠═5ff1b6b0-9079-4e8f-b05b-1924debd676b
# ╠═20f0eba8-477f-49f0-a130-e509d2d31898
# ╠═573c3e3d-c1c4-4e6e-8883-ca2b35918dc9
# ╠═48dccb5f-5995-4db4-a00c-5a80634955dd
# ╠═65770c86-a953-4bde-a313-da362f923651
# ╠═5d2e5fa1-9abb-438f-99bb-bd638954d975
# ╠═f0238e4a-aaba-42d9-97c0-2497c4f1fe5b
# ╠═b4bbf4ec-4522-4ed0-a328-16a37e7d4559
# ╠═e1c57412-e2db-4b8f-825c-4b20d599f4ea
