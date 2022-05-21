### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ c092f70c-d896-11ec-2f00-470b953f694e
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

# ╔═╡ 123ed931-5360-4147-a04e-a03f855bbf8e
md"""
# Heuristic Bin Packing Problem
"""

# ╔═╡ 703d8f5f-8ac3-4a37-9cd3-8f58ba549ef6
function bppheur(c::Int, w::Vector{Int})
    n = length(w)

    bin = [Int[]]

    for i in 1:n
        u = sum.(bin)
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

    return bin
end

# ╔═╡ 983cd410-9ca0-4a9a-8788-200e8bbe0eac
function readbpp(f::String)
    v = readlines(f)
    c = parse(Int, v[2])
    w = parse.(Int, v[3:end])
    @assert parse(Int, v[1]) == length(w)
    return c, w
end

# ╔═╡ e62a6ef0-1d0a-420f-92c4-3efe6e2db523
function writebppsol(f::String, bin)
    open(f, "w") do io
        println(io, "#bin = ", length(bin))
        println(io, "#use = ", sum.(bin))
        return println(io, "bin = ", bin)
    end
    return
end

# ╔═╡ 36282a2a-16d5-40d6-9b11-d72b3d1fabb0
md"""
# Process Files
"""

# ╔═╡ 679deb25-cfbc-4e8b-a78e-62d5fa39a5b3
dir = @__DIR__

# ╔═╡ 07447d12-7ee3-4bb6-b328-2d72750ebd79
dirinput = joinpath(dir, "instances")

# ╔═╡ 8facfa1d-0a31-45ef-b2b4-3937a2119824
diroutput = mkpath(joinpath(dir, "salida"))

# ╔═╡ 518040c6-6ab2-4836-9c80-c319626933a8
md"""
# Process Functions
"""

# ╔═╡ b20b0d30-0898-4d72-a466-13ece0f77e07
function bppheur(instance::Function)
    w, c = instance()
    n = length(w)

    bin = [Int[]]

    for i in 1:n
        u = sum.(bin)
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

    return bin
end

# ╔═╡ 6cf9c03d-bacd-4902-a93f-e01dead74c36
for f in filter(x -> endswith(x, ".txt"), readdir(dirinput))
    c, w = readbpp(joinpath(dirinput, f))

    bin = bppheur(c, w)

    println("file = ", f, "\t ub = ", length(bin), "\t lb = ", round(sum(w) / c, RoundUp))

    writebppsol(joinpath(diroutput, f), bin)
end

# ╔═╡ 5037fb04-9fa3-4c4d-bab8-e0636aac7855
function instance01()
    w = [50, 3, 48, 53, 53, 4, 3, 41, 23, 20, 52, 49]
    c = 100
    return w, c
end

# ╔═╡ a79b75cb-b9e4-428e-8af4-e9b75c7c4d52
function instanceRNG(n::Int)
    w = rand(1:100, n)
    c = round(Int, sum(w) / 2)
    return w, c
end

# ╔═╡ fceed409-6e0d-461d-837e-19f476e868d9
instanceRNG30() = instanceRNG(30)

# ╔═╡ 7fb1ac50-bb17-4661-9873-e4d90b273fff
instas = [
    instance01
    () -> instanceRNG(20)
    instanceRNG30
]

# ╔═╡ b08dacd3-d2f2-4f6a-a600-7cf64d1d5af9
for inta in instas
    bin = bppheur(inta)

    println("insta = ", inta, "\t ub = ", length(bin))

    writebppsol(joinpath(diroutput, string(inta) * ".log"), bin)
end

# ╔═╡ Cell order:
# ╟─c092f70c-d896-11ec-2f00-470b953f694e
# ╟─123ed931-5360-4147-a04e-a03f855bbf8e
# ╠═703d8f5f-8ac3-4a37-9cd3-8f58ba549ef6
# ╠═983cd410-9ca0-4a9a-8788-200e8bbe0eac
# ╠═e62a6ef0-1d0a-420f-92c4-3efe6e2db523
# ╟─36282a2a-16d5-40d6-9b11-d72b3d1fabb0
# ╠═679deb25-cfbc-4e8b-a78e-62d5fa39a5b3
# ╠═07447d12-7ee3-4bb6-b328-2d72750ebd79
# ╠═8facfa1d-0a31-45ef-b2b4-3937a2119824
# ╠═6cf9c03d-bacd-4902-a93f-e01dead74c36
# ╟─518040c6-6ab2-4836-9c80-c319626933a8
# ╠═b20b0d30-0898-4d72-a466-13ece0f77e07
# ╠═5037fb04-9fa3-4c4d-bab8-e0636aac7855
# ╠═a79b75cb-b9e4-428e-8af4-e9b75c7c4d52
# ╠═fceed409-6e0d-461d-837e-19f476e868d9
# ╠═7fb1ac50-bb17-4661-9873-e4d90b273fff
# ╠═b08dacd3-d2f2-4f6a-a600-7cf64d1d5af9
