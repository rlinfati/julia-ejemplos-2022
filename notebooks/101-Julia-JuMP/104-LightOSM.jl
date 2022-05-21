### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([Pkg.PackageSpec("LightOSM")])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
using LightOSM

# ╔═╡ 58c2ea61-c9b4-4454-b74f-6c3f8af51ec7
md"""
# Uso de LightOSM
"""

# ╔═╡ debc168b-0078-4dde-a032-75cefa00d119
md"""
## Buscar direcciones

Usar [nominatim](https://nominatim.openstreetmap.org/)
"""

# ╔═╡ 0c5cea8e-ec2c-42e4-9b53-cca423636d24
dire = [
    "Plaza Belgica, Concepcion, Chile"
    "Plaza de la Independencia, Concepcion, Chile"
    "Mall Plaza, Concepcion, Chile"
    "Collao 1202, Concepcion, Chile"
]

# ╔═╡ c89a9a9e-b463-4e94-9501-ad3fe1a99101
function getlatlon(dir::String)::GeoLocation
    q = LightOSM.nominatim_polygon_query(dir)
    j = LightOSM.nominatim_request(q)

    d = LightOSM.JSON.parse(j)

    println(d[1]["display_name"])
    lat = parse(Float64, d[1]["lat"])
    lon = parse(Float64, d[1]["lon"])

    return GeoLocation(lat, lon)
end

# ╔═╡ 70dbab2e-0520-4f51-bd01-b902e420cbc4
function buscanodo(g::OSMGraph{U,T,W}, points::Vector{GeoLocation})::Vector{T} where {U,T,W}
    x = LightOSM.nearest_node(g, points)
    for i in eachindex(points)
        println("nodo= ", x[1][i][1], " dista= ", x[2][i][1])
    end
    return vcat(x[1]...)
end

# ╔═╡ 940e3841-719e-4466-9044-284f3d75a476
md"""
## Extraer Lat/Lon
"""

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
latlon = getlatlon.(dire)

# ╔═╡ 667d1cba-2872-4dd7-85d6-396ed5b213f8
md"""
## Cargar Mapa
"""

# ╔═╡ 886ec68e-3134-40fd-bf61-4346e12caa25
g = LightOSM.graph_from_download(:place_name, weight_type = :distance, place_name = "Concepción, Chile")

# ╔═╡ 4cc2f28c-d6d1-428e-bb1d-49eb1c276736
md"""
## Buscar nodos en grafo OSM
"""

# ╔═╡ c96fd875-b1f7-4115-8b0c-f1454343fe35
puntos = buscanodo(g, latlon)

# ╔═╡ 6b236a95-0b54-4649-8abb-4ce6d9aaa6fd
md"""
## Distancia Real
"""

# ╔═╡ 45b91d6f-0172-4ba6-8b26-81fad700579b
function distreal(g::OSMGraph{U,T,W}, o::T, d::T)::Float64 where {U,T,W}
    if o == d
        return 0.0
    end
    ruta = LightOSM.shortest_path(g, o, d)
    distx = LightOSM.weights_from_path(g, ruta)
    return sum(distx)
end

# ╔═╡ 0797888b-80b8-444b-961c-8edd96f73318
dista = [distreal(g, o, d) for o in puntos, d in puntos]

# ╔═╡ e1adff78-c1cb-4dec-88f0-8a83adef58a1
md"""
## Distancia GEO - haversine
"""

# ╔═╡ 832faa87-2ce0-4d01-acbe-4201f036077c
function distgeo(g::OSMGraph{U,T,W}, o::T, d::T)::Float64 where {U,T,W}
    disth = LightOSM.distance(g.nodes[o], g.nodes[d])
    return disth
end

# ╔═╡ 3c56e61a-b9d0-49d1-ba7c-83f7e503d049
disth = [distgeo(g, o, d) for o in puntos, d in puntos]

# ╔═╡ c727ceb1-d42d-4de8-b2d8-37745ccea58c
md"""
## Diferencias de distancias

NOTA: la matriz es asimetrica
"""

# ╔═╡ eede4794-a506-4677-bdda-982bb86b3201
dista - disth

# ╔═╡ c119f81d-c870-417b-9f0a-07c5440cd15c
md"""
## Distancia Euclidiana
"""

# ╔═╡ 2f63ed19-730f-4230-92d1-9d9429f0fa2f
[sqrt((i.lat - j.lat)^2 + (i.lon - j.lon)^2) for i in latlon, j in latlon]

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╟─58c2ea61-c9b4-4454-b74f-6c3f8af51ec7
# ╟─debc168b-0078-4dde-a032-75cefa00d119
# ╠═0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═c89a9a9e-b463-4e94-9501-ad3fe1a99101
# ╠═70dbab2e-0520-4f51-bd01-b902e420cbc4
# ╟─940e3841-719e-4466-9044-284f3d75a476
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╟─667d1cba-2872-4dd7-85d6-396ed5b213f8
# ╠═886ec68e-3134-40fd-bf61-4346e12caa25
# ╟─4cc2f28c-d6d1-428e-bb1d-49eb1c276736
# ╠═c96fd875-b1f7-4115-8b0c-f1454343fe35
# ╟─6b236a95-0b54-4649-8abb-4ce6d9aaa6fd
# ╠═45b91d6f-0172-4ba6-8b26-81fad700579b
# ╠═0797888b-80b8-444b-961c-8edd96f73318
# ╟─e1adff78-c1cb-4dec-88f0-8a83adef58a1
# ╠═832faa87-2ce0-4d01-acbe-4201f036077c
# ╠═3c56e61a-b9d0-49d1-ba7c-83f7e503d049
# ╟─c727ceb1-d42d-4de8-b2d8-37745ccea58c
# ╠═eede4794-a506-4677-bdda-982bb86b3201
# ╟─c119f81d-c870-417b-9f0a-07c5440cd15c
# ╠═2f63ed19-730f-4230-92d1-9d9429f0fa2f
