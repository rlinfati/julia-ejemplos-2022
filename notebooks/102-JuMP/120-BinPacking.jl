### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ e7262522-ac65-11ec-0633-1d82420161db
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

# ╔═╡ e726254a-ac65-11ec-2f4c-1bead54e006a
using JuMP

# ╔═╡ a28468d5-b6fd-42d1-856f-4b9a8198a4fa
using GLPK

# ╔═╡ 66bea84e-7574-494c-abcf-eb8d092e778c
md"""
# Bin Packing Problem
"""

# ╔═╡ f9cb6029-062b-436e-968b-9e8e4dd7b8f6
function instance01()
    w = [50, 3, 48, 53, 53, 4, 3, 41, 23, 20, 52, 49]
    c = 100
    # w = sort(w, rev = true)
    return w, c
end

# ╔═╡ e25e7bf8-681f-4951-b062-bcc5c7517207
function instance02() # Falkenauer_u120_19
    w = [
        100,
        59,
        84,
        40,
        95,
        50,
        69,
        31,
        97,
        55,
        77,
        37,
        90,
        48,
        65,
        26,
        96,
        51,
        74,
        33,
        88,
        44,
        62,
        23,
        99,
        58,
        79,
        38,
        93,
        49,
        66,
        28,
        97,
        54,
        76,
        34,
        90,
        44,
        63,
        24,
        95,
        50,
        72,
        32,
        85,
        42,
        60,
        21,
        100,
        58,
        83,
        39,
        94,
        50,
        68,
        29,
        97,
        54,
        77,
        36,
        90,
        47,
        65,
        25,
        96,
        50,
        74,
        33,
        86,
        43,
        62,
        23,
        99,
        57,
        78,
        38,
        92,
        48,
        66,
        27,
        97,
        52,
        75,
        33,
        89,
        44,
        63,
        23,
        95,
        50,
        72,
        31,
        85,
        41,
        60,
        21,
        99,
        58,
        80,
        39,
        94,
        49,
        67,
        28,
        97,
        54,
        77,
        35,
        90,
        46,
        64,
        24,
        95,
        50,
        73,
        32,
        86,
        43,
        62,
        22,
    ]
    c = 150
    # w = sort(w, rev = true)
    return w, c
end

# ╔═╡ 1934c4c8-080c-4d3d-89f6-116939f19021
function instance03() # Falkenauer_t60_19
    w = [
        499,
        363,
        273,
        415,
        305,
        257,
        460,
        342,
        261,
        384,
        287,
        253,
        488,
        358,
        267,
        405,
        298,
        254,
        459,
        329,
        259,
        368,
        282,
        251,
        460,
        343,
        261,
        391,
        288,
        253,
        423,
        316,
        257,
        366,
        276,
        250,
        493,
        361,
        270,
        407,
        303,
        255,
        459,
        342,
        259,
        382,
        286,
        252,
        470,
        350,
        263,
        395,
        292,
        254,
        427,
        324,
        258,
        367,
        279,
        251,
    ]
    c = 1000
    # w = sort(w, rev = true)
    return w, c
end

# ╔═╡ 269911c3-f174-442d-b6f6-4bc29b203cfb
w, c = instance01()

# ╔═╡ 249acea1-9778-4e03-9a7e-5636054c3f06
md"""
## Modelo Matematico
"""

# ╔═╡ 3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
begin
    m = JuMP.Model()

    n = length(w)
    nn = round(Int, 1.5 * sum(w) / c, RoundUp) # heuristic...

    @variable(m, x[1:nn, 1:n], Bin)
    @variable(m, y[1:nn], Bin)

    @objective(m, Min, sum(y))
    @constraint(m, r1[i in 1:nn], sum(w[:] .* x[i, :]) <= c * y[i])
    @constraint(m, r2[j in 1:n], sum(x[:, j]) == 1)

    nothing
end

# ╔═╡ 48e6f211-27a6-42a2-8c4a-4352863da1fa
JuMP.latex_formulation(m);

# ╔═╡ d1b599d9-da3a-4070-90dc-e63532951fd6
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ d1c1c450-c0d7-4427-b73e-795e0b5387fa
md"""
### Solución del Solver
"""

# ╔═╡ fc925cdf-ffd8-45ad-a7a9-4c11228fac02
JuMP.solution_summary(m)

# ╔═╡ c2f753f3-3fe5-4160-9e43-0e228b3f2b3e
let
    xval = round.(Int, JuMP.value.(x))
    yval = round.(Int, JuMP.value.(y))
    for i in 1:length(yval)
        if yval[i] ≈ 0.0
            continue
        end
        wval = w .* xval[i, :]
        u = sum(wval)
        println("bin $i - used $u/$c = $wval")
    end
    xval
end

# ╔═╡ afdb0e5c-4b41-496a-8020-9349cce38a7d
md"""
## Next Fit Heuristic
"""

# ╔═╡ c06bdbf6-209f-46bc-92b0-928142e586c3
let
    bin = [Int[]]
    for i in 1:n
        if sum(bin[end]) + w[i] <= c
            push!(bin[end], w[i])
        else
            push!(bin, Int[])
            push!(bin[end], w[i])
        end
    end

    for i in 1:length(bin)
        u = sum(bin[i])
        println("bin $i - used $u/$c = $(bin[i])")
    end

    bin
end

# ╔═╡ 350858a8-97f5-476a-a5f1-8e49ef098fa2
md"""
## First Fit Heuristic
"""

# ╔═╡ d8ff6306-10c3-4c8b-9e2c-b95068340f0c
let
    bin = [Int[]]
    for i in 1:n
        estaOK = false
        for j in 1:length(bin)
            if sum(bin[j]) + w[i] <= c
                push!(bin[j], w[i])
                estaOK = true
                break
            end
        end
        if estaOK == false
            push!(bin, Int[])
            push!(bin[end], w[i])
        end
    end

    for i in 1:length(bin)
        u = sum(bin[i])
        println("bin $i - used $u/$c = $(bin[i])")
    end

    bin
end

# ╔═╡ 2c84d95e-d866-4de6-b750-62547c632dc0
md"""
## Best Fit Heuristic
"""

# ╔═╡ 72212560-f2e4-4f6c-b3ed-c6abfcf9dc5e
let
    bin = [Int[]]
    for i in 1:n
        u = [sum(bin[i]) for i in 1:length(bin)]
        while true
            id = argmax(u)
            if sum(bin[id]) + w[i] <= c
                push!(bin[id], w[i])
                break
            else
                u[id] = 0
            end
            if sum(u) == 0
                push!(bin, Int[])
                push!(bin[end], w[i])
                break
            end
        end
    end

    for i in 1:length(bin)
        u = sum(bin[i])
        println("bin $i - used $u/$c = $(bin[i])")
    end

    bin
end

# ╔═╡ Cell order:
# ╟─e7262522-ac65-11ec-0633-1d82420161db
# ╠═e726254a-ac65-11ec-2f4c-1bead54e006a
# ╠═a28468d5-b6fd-42d1-856f-4b9a8198a4fa
# ╟─66bea84e-7574-494c-abcf-eb8d092e778c
# ╠═f9cb6029-062b-436e-968b-9e8e4dd7b8f6
# ╠═e25e7bf8-681f-4951-b062-bcc5c7517207
# ╠═1934c4c8-080c-4d3d-89f6-116939f19021
# ╠═269911c3-f174-442d-b6f6-4bc29b203cfb
# ╟─249acea1-9778-4e03-9a7e-5636054c3f06
# ╠═3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
# ╠═48e6f211-27a6-42a2-8c4a-4352863da1fa
# ╠═d1b599d9-da3a-4070-90dc-e63532951fd6
# ╟─d1c1c450-c0d7-4427-b73e-795e0b5387fa
# ╠═fc925cdf-ffd8-45ad-a7a9-4c11228fac02
# ╠═c2f753f3-3fe5-4160-9e43-0e228b3f2b3e
# ╟─afdb0e5c-4b41-496a-8020-9349cce38a7d
# ╠═c06bdbf6-209f-46bc-92b0-928142e586c3
# ╟─350858a8-97f5-476a-a5f1-8e49ef098fa2
# ╠═d8ff6306-10c3-4c8b-9e2c-b95068340f0c
# ╟─2c84d95e-d866-4de6-b750-62547c632dc0
# ╠═72212560-f2e4-4f6c-b3ed-c6abfcf9dc5e
