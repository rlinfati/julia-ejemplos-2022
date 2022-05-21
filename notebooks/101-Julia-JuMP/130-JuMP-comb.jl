### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 607905aa-c590-11ec-0279-41c5bf71d587
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("GLPK")
        Pkg.PackageSpec("Plots")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 607905e6-c590-11ec-201f-01ed9bbbf52a
using JuMP, GLPK, Plots

# ╔═╡ 9d5b2183-496b-4da3-b86e-09832e2b3bb7
md"# modelo PL con imagenes"

# ╔═╡ 30dc53c4-29de-4915-8052-98c6dce98f15
let
    ㊭ = JuMP.Model()

    @variable(㊭, 💻 >= 0)
    @variable(㊭, 📱 >= 0)

    @objective(㊭, Max, 3 * 💻 + 5 * 📱)

    @constraint(㊭, 💻 <= 4)
    @constraint(㊭, 2 * 📱 <= 12)
    @constraint(㊭, 3 * 💻 + 2 * 📱 <= 18)

    JuMP.latex_formulation(㊭)
end

# ╔═╡ f198445a-d851-4ecb-9807-c9fdfabe85ab
md"# modelo PL con conjuntos"

# ╔═╡ 040f12b0-ba69-4f1e-afd4-d042b2813b54
let
    animales = ["perro", "gato", "pollo", "vaca", "chancho"]

    m = JuMP.Model()

    @variable(m, x[animales] >= 0)
    @objective(m, Max, sum(x[j] for j in animales if 'a' in j))
    @constraint(m, sum(x) <= 123)

    JuMP.latex_formulation(m)
end

# ╔═╡ 36584da6-5463-41c8-b272-34cc618aaa6e
md"# modelo PL con diccionarios"

# ╔═╡ b3cd9675-ba07-4ecc-9c47-ebb310c5bcc2
let
    pesoAnimales = Dict("perro" => 20.0, "gato" => 5.0, "pollo" => 2.0, "vaca" => 720.0, "chancho" => 150.0)
    m = JuMP.Model()

    @variable(m, x[j in eachindex(pesoAnimales)] >= 0)
    @objective(m, Max, sum(x))
    @constraint(m, sum(v * x[k] for (k, v) in pesoAnimales) <= 123)

    JuMP.latex_formulation(m)
end

# ╔═╡ 868ae2d4-ddd5-463f-8bcc-ea67c09c2cf1
md"# modelo TSP - MTZ"

# ╔═╡ 80f4f6bc-6b8a-4966-afd5-b7b89ab70d1a
md"## datos"

# ╔═╡ 9360aa79-3d83-4bec-8b0c-b729ab8b000a
begin
    n = 15
    X = rand(n) * 1_000.0
    Y = rand(n) * 1_000.0
    d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:n, j in 1:n]
end

# ╔═╡ 28f00d5c-1133-472f-9d29-21d0dfaa62f3
md"## modelo"

# ╔═╡ 8cf9daae-c5e7-4749-8d0e-16c409d4c390
begin
    m = JuMP.Model()

    @variable(m, x[1:n, 1:n], Bin)
    @variable(m, u[1:n] >= 0)

    @objective(m, Min, sum(d .* x))

    @constraint(m, r0[i in 1:n], x[i, i] == 0) # FIX
    @constraint(m, r1[i in 1:n], sum(x[i, :]) == 1)
    @constraint(m, r2[j in 1:n], sum(x[:, j]) == 1)
    @constraint(m, r3[i in 1:n, j in 2:n], u[i] + 1 <= u[j] + n * (1 - x[i, j]))
    @constraint(m, r4[i in 1:n], u[i] <= n - 1)
    @constraint(m, r5, u[1] == 0)

    nothing
end

# ╔═╡ 28b4add9-df83-4578-b528-c3c4c21cf301
md"## solución"

# ╔═╡ d4f4da79-fe32-4b27-b97d-0a07ec2bb219
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.optimize!(m)
    JuMP.solution_summary(m)
end

# ╔═╡ face8449-56ac-4011-be6f-56f1054674dc
xval = JuMP.value.(x) .≈ 1.0

# ╔═╡ c6ef4f94-0665-4a11-a773-3674954e8d7e
uval = JuMP.value.(u)

# ╔═╡ 8fe244b6-64bf-4d33-a3fe-ab09c5bd3e90
md"## solución - gráfica"

# ╔═╡ 4a0ae290-4818-4e4a-aae3-0bcc99ba3ea4
begin
    tour = Int[1]
    while true
        push!(tour, argmax(xval[tour[end], :]))
        if tour[end] == 1
            break
        end
    end
    tour
end

# ╔═╡ 82c8165f-0aed-4fe7-b807-b85d82e6a8f7
sum(d[tour[i], tour[i+1]] for i in 1:n)

# ╔═╡ a4307499-41f5-4c6b-8d8a-e3eb34529120
begin
    p2 = plot(legend = false)
    scatter!(X, Y, color = :blue)

    for i in 1:n
        annotate!(X[i], Y[i], text("$i", :top))
    end

    plot!(X[tour], Y[tour], color = :red)
end

# ╔═╡ Cell order:
# ╟─607905aa-c590-11ec-0279-41c5bf71d587
# ╠═607905e6-c590-11ec-201f-01ed9bbbf52a
# ╟─9d5b2183-496b-4da3-b86e-09832e2b3bb7
# ╠═30dc53c4-29de-4915-8052-98c6dce98f15
# ╟─f198445a-d851-4ecb-9807-c9fdfabe85ab
# ╠═040f12b0-ba69-4f1e-afd4-d042b2813b54
# ╟─36584da6-5463-41c8-b272-34cc618aaa6e
# ╠═b3cd9675-ba07-4ecc-9c47-ebb310c5bcc2
# ╟─868ae2d4-ddd5-463f-8bcc-ea67c09c2cf1
# ╟─80f4f6bc-6b8a-4966-afd5-b7b89ab70d1a
# ╠═9360aa79-3d83-4bec-8b0c-b729ab8b000a
# ╟─28f00d5c-1133-472f-9d29-21d0dfaa62f3
# ╠═8cf9daae-c5e7-4749-8d0e-16c409d4c390
# ╟─28b4add9-df83-4578-b528-c3c4c21cf301
# ╠═d4f4da79-fe32-4b27-b97d-0a07ec2bb219
# ╠═face8449-56ac-4011-be6f-56f1054674dc
# ╠═c6ef4f94-0665-4a11-a773-3674954e8d7e
# ╠═82c8165f-0aed-4fe7-b807-b85d82e6a8f7
# ╟─8fe244b6-64bf-4d33-a3fe-ab09c5bd3e90
# ╠═4a0ae290-4818-4e4a-aae3-0bcc99ba3ea4
# ╠═a4307499-41f5-4c6b-8d8a-e3eb34529120
