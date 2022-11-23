### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 607905aa-c590-11ec-0279-41c5bf71d587
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([Pkg.PackageSpec("JuMP")])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 607905e6-c590-11ec-201f-01ed9bbbf52a
using JuMP

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

# ╔═╡ Cell order:
# ╟─607905aa-c590-11ec-0279-41c5bf71d587
# ╠═607905e6-c590-11ec-201f-01ed9bbbf52a
# ╟─9d5b2183-496b-4da3-b86e-09832e2b3bb7
# ╠═30dc53c4-29de-4915-8052-98c6dce98f15
# ╟─f198445a-d851-4ecb-9807-c9fdfabe85ab
# ╠═040f12b0-ba69-4f1e-afd4-d042b2813b54
# ╟─36584da6-5463-41c8-b272-34cc618aaa6e
# ╠═b3cd9675-ba07-4ecc-9c47-ebb310c5bcc2
