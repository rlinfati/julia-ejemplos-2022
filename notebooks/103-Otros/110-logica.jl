### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 47e373da-ac3c-11ec-01f3-4d2837d60a99
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

# ╔═╡ 9a876803-ee22-4969-8539-2d7348690f98
md"""
## Suma de los enteros positivos que no superiores a 𝑛 
"""

# ╔═╡ 194998c0-f256-48f5-86d3-292a4769ffbf
function f1(n::Int = 10)
    r = 0
    for i in 1:n
        r += i
    end
    return r
end

# ╔═╡ 2a642f7d-b2da-4006-b756-c0f4c59e3dc1
f1(50_000)

# ╔═╡ fb4b15bb-985a-4f32-9aaa-f44d35543363
f2(n::Int = 10) = sum(1:n)

# ╔═╡ 543a5fb1-7a12-4697-b1a6-9f08f75defa9
f2(50_000)

# ╔═╡ e675f85b-e92a-4180-9c25-19b0f67b19c5
f3(n::Int = 10) = n * (n + 1) / 2

# ╔═╡ 9ffdee18-4265-4209-9e76-0a0d287ef7d5
f3(50_000)

# ╔═╡ 1484a035-5bb3-4770-bc1e-3dd6c085b8fa
f3b(n::Int = 10)::Int = n * (n + 1) / 2

# ╔═╡ e7c1c8bb-ca9b-4a3a-979d-1f4cc9bcf84e
f3b(50_000)

# ╔═╡ 9ac470c9-907d-4528-96f1-40c2edd1df03
f4(n::Int = 10) = n * (n + 1) ÷ 2

# ╔═╡ e8f7c572-d79d-42eb-8849-a6f0df6ddd8b
f4(50_000)

# ╔═╡ bcfb8f72-ff4e-4372-8104-b18c7b792580
f5(n::Int = 10) = n * (n + 1) // 2

# ╔═╡ ebab95a2-fb85-43bb-8390-84d0fd05cb32
f5(50_000)

# ╔═╡ 54685c20-3b43-4da9-9885-28716f6ea13b
md"""
## Ejemplos de operadores logicos
"""

# ╔═╡ ffd80f3e-c735-4962-804c-d5a768e04cf1
true

# ╔═╡ 90a34e76-7bf3-432d-b62d-72f446de0aa6
!true

# ╔═╡ 1d362767-28a1-49c1-ba2e-9429a8daae6b
!false

# ╔═╡ 53260c3e-ebb8-4d33-8bca-bcb7c6a326b8
begin
    v = [true, false]
    for p in v
        @show p, !p
    end
end

# ╔═╡ 1eeba5e2-863e-499b-bbba-bc810b21e8b9
for p in v, q in v
    @show p, q, p & q
end

# ╔═╡ 89d94721-0884-479a-89b7-f786bc711404
for p in v, q in v
    @show p, q, p | q
end

# ╔═╡ 595acc50-4de8-4edc-8373-14f73fcc9dda
for p in v, q in v
    @show p, q, p ⊻ q
end

# ╔═╡ 46a29627-16ee-4885-9a05-a83c38163670
f_xor(p, q) = (p & !q) | (!p & q)

# ╔═╡ 7f416566-2c82-48ba-baae-4ef3f6040d55
for p in v, q in v
    @show p, q, f_xor(p, q)
end

# ╔═╡ cbb147fb-24c3-4532-833f-5acc5726034a
f_ift(p, q) = p ? q : true

# ╔═╡ 1dcbd964-7a01-4ddc-91b5-64eb691020c3
for p in v, q in v
    @show p, q, f_ift(p, q)
end

# ╔═╡ 9f5c3eb7-e3a8-4638-b0f8-70f85e13ceb3
function f_ifthen(p, q)
    if p == true
        return q
    else
        return true
    end
end

# ╔═╡ 11042314-d596-4e41-9591-7e2bef51e614
for p in v, q in v
    @show p, q, f_ifthen(p, q)
end

# ╔═╡ abca4d8c-438b-4c5f-8bfe-48ba140b6abb
f_iff(p, q) = p == q

# ╔═╡ fa786fb6-657f-4220-a285-763342874002
for p in v, q in v
    @show p, q, f_iff(p, q)
end

# ╔═╡ eb7853c6-8baf-4c84-9e0f-002ef18c6045
f_ej(p, q) = f_ift(p | !q, p & q)

# ╔═╡ c9566518-ad61-4889-858d-8dd541f8875d
for p in v, q in v
    @show p, q, f_ej(p, q)
end

# ╔═╡ b260c1a2-2928-4e94-b749-6fccb06d19d6
md"""
## Ejemplos de logica para sodoku
"""

# ╔═╡ 9b3962d0-3595-40c7-b087-449e2e6589f6
Sr1 = [
    1 2 3 4 5 6 7 8 9
    1 2 3 4 5 6 7 8 9
    1 2 3 4 5 6 7 8 9
    1 2 3 4 5 6 7 8 9
    1 2 3 4 5 6 7 8 9
    1 2 3 4 5 6 7 8 9
    1 2 3 4 5 6 7 8 9
    1 2 3 4 5 6 7 8 9
    1 2 3 4 5 6 7 8 9
];

# ╔═╡ a1a69f51-b52a-4687-88e5-7a9be902626f
Sr2 = [
    1 1 1 1 1 1 1 1 1
    2 2 2 2 2 2 2 2 2
    3 3 3 3 3 3 3 3 3
    4 4 4 4 4 4 4 4 4
    5 5 5 5 5 5 5 5 5
    6 6 6 6 6 6 6 6 6
    7 7 7 7 7 7 7 7 7
    8 8 8 8 8 8 8 8 8
    9 9 9 9 9 9 9 9 9
];

# ╔═╡ da3ec825-a92d-4a2b-b6fb-57cc14e9286f
Sr3 = [
    1 2 3 1 2 3 1 2 3
    4 5 6 4 5 6 4 5 6
    7 8 9 7 8 9 7 8 9
    1 2 3 1 2 3 1 2 3
    4 5 6 4 5 6 4 5 6
    7 8 9 7 8 9 7 8 9
    1 2 3 1 2 3 1 2 3
    4 5 6 4 5 6 4 5 6
    7 8 9 7 8 9 7 8 9
];

# ╔═╡ cc5981b0-a751-4aa0-828c-1fd8aaef60f4
Sok = [
    9 3 6 7 5 8 2 4 1
    1 5 7 3 4 2 6 9 8
    8 4 2 1 9 6 7 3 5
    6 8 3 4 7 5 1 2 9
    5 2 4 8 1 9 3 6 7
    7 1 9 6 2 3 5 8 4
    4 6 8 5 3 1 9 7 2
    3 9 5 2 8 7 4 1 6
    2 7 1 9 6 4 8 5 3
];

# ╔═╡ b02159a4-140d-4aa5-a6df-14d2aba0780c
S = Sok;

# ╔═╡ 6b03abd6-0f1e-4170-a714-51c3fdde6310
p(i, j, n) = return S[i, j] == n

# ╔═╡ 01130d78-2e43-49e1-8daf-441238cbad5b
p(1, 1, 1)

# ╔═╡ 642cd27a-525f-4985-b8b4-e7a76de8eb75
p(1, 1, 9)

# ╔═╡ 25775836-6ef0-4a50-8312-0219b91175eb
r1 = all([any([p(i, j, n) for j in 1:9]) for n in 1:9, i in 1:9])

# ╔═╡ 59368420-f094-4072-86ac-6d4c0dc72155
r2 = all([any([p(i, j, n) for i in 1:9]) for n in 1:9, j in 1:9])

# ╔═╡ a109c5f1-ddf1-4e46-818e-09990f0e4e25
r3 = all([any([p(i + 3r, j + 3s, n) for j in 1:3, i in 1:3]) for n in 1:9, s in 0:2, r in 0:2])

# ╔═╡ 26c34ef8-9abb-477b-8f06-ec7495414f74
r4 = all([f_ift(p(i, j, n1), !p(i, j, n2)) for n1 in 1:9, n2 in 1:9, j in 1:9, i in 1:9 if n1 != n2])

# ╔═╡ 139bebfb-515e-4829-a58b-1febbda49bb3
r1 & r2 & r3 & r4

# ╔═╡ Cell order:
# ╟─47e373da-ac3c-11ec-01f3-4d2837d60a99
# ╟─9a876803-ee22-4969-8539-2d7348690f98
# ╠═194998c0-f256-48f5-86d3-292a4769ffbf
# ╠═2a642f7d-b2da-4006-b756-c0f4c59e3dc1
# ╠═fb4b15bb-985a-4f32-9aaa-f44d35543363
# ╠═543a5fb1-7a12-4697-b1a6-9f08f75defa9
# ╠═e675f85b-e92a-4180-9c25-19b0f67b19c5
# ╠═9ffdee18-4265-4209-9e76-0a0d287ef7d5
# ╠═1484a035-5bb3-4770-bc1e-3dd6c085b8fa
# ╠═e7c1c8bb-ca9b-4a3a-979d-1f4cc9bcf84e
# ╠═9ac470c9-907d-4528-96f1-40c2edd1df03
# ╠═e8f7c572-d79d-42eb-8849-a6f0df6ddd8b
# ╠═bcfb8f72-ff4e-4372-8104-b18c7b792580
# ╠═ebab95a2-fb85-43bb-8390-84d0fd05cb32
# ╟─54685c20-3b43-4da9-9885-28716f6ea13b
# ╠═ffd80f3e-c735-4962-804c-d5a768e04cf1
# ╠═90a34e76-7bf3-432d-b62d-72f446de0aa6
# ╠═1d362767-28a1-49c1-ba2e-9429a8daae6b
# ╠═53260c3e-ebb8-4d33-8bca-bcb7c6a326b8
# ╠═1eeba5e2-863e-499b-bbba-bc810b21e8b9
# ╠═89d94721-0884-479a-89b7-f786bc711404
# ╠═595acc50-4de8-4edc-8373-14f73fcc9dda
# ╠═46a29627-16ee-4885-9a05-a83c38163670
# ╠═7f416566-2c82-48ba-baae-4ef3f6040d55
# ╠═cbb147fb-24c3-4532-833f-5acc5726034a
# ╠═1dcbd964-7a01-4ddc-91b5-64eb691020c3
# ╠═9f5c3eb7-e3a8-4638-b0f8-70f85e13ceb3
# ╠═11042314-d596-4e41-9591-7e2bef51e614
# ╠═abca4d8c-438b-4c5f-8bfe-48ba140b6abb
# ╠═fa786fb6-657f-4220-a285-763342874002
# ╠═eb7853c6-8baf-4c84-9e0f-002ef18c6045
# ╠═c9566518-ad61-4889-858d-8dd541f8875d
# ╟─b260c1a2-2928-4e94-b749-6fccb06d19d6
# ╠═9b3962d0-3595-40c7-b087-449e2e6589f6
# ╠═a1a69f51-b52a-4687-88e5-7a9be902626f
# ╠═da3ec825-a92d-4a2b-b6fb-57cc14e9286f
# ╠═cc5981b0-a751-4aa0-828c-1fd8aaef60f4
# ╠═b02159a4-140d-4aa5-a6df-14d2aba0780c
# ╠═6b03abd6-0f1e-4170-a714-51c3fdde6310
# ╠═01130d78-2e43-49e1-8daf-441238cbad5b
# ╠═642cd27a-525f-4985-b8b4-e7a76de8eb75
# ╠═25775836-6ef0-4a50-8312-0219b91175eb
# ╠═59368420-f094-4072-86ac-6d4c0dc72155
# ╠═a109c5f1-ddf1-4e46-818e-09990f0e4e25
# ╠═26c34ef8-9abb-477b-8f06-ec7495414f74
# ╠═139bebfb-515e-4829-a58b-1febbda49bb3
