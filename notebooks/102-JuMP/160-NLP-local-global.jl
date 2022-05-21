### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add(
        [
            Pkg.PackageSpec("JuMP")
            Pkg.PackageSpec("Ipopt")
            Pkg.PackageSpec("Cbc")
            Pkg.PackageSpec("Juniper")
            Pkg.PackageSpec("Pavito")
            Pkg.PackageSpec("Alpine")
            Pkg.PackageSpec("Plots")
        ],
    )
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ dac312f0-28b6-4525-87ff-c50bab5edfaa
using Ipopt, Cbc

# ╔═╡ 901a223f-d796-4c38-b379-c7ee01943e35
using Juniper, Pavito, Alpine

# ╔═╡ 7d414528-acbb-427c-9dc1-991624b5e8e0
using Plots

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
## x^3
"""

# ╔═╡ 0c4bd17b-ddda-44ec-befc-426cf5cc25a9
let
    m = JuMP.Model()

    @variable(m, x >= -1_000)
    @NLobjective(m, Min, x^3)

    JuMP.latex_formulation(m)
end

# ╔═╡ 870fc9f3-49a7-4533-9b28-e4723172bb28
plot(x -> x^3, -10_000, 10_000)

# ╔═╡ dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
let
    m = JuMP.Model()

    @variable(m, x >= -1_000)
    @NLobjective(m, Min, x^3)

    JuMP.set_optimizer(m, Ipopt.Optimizer)
    JuMP.set_optimizer_attribute(m, "print_level", 0)
    JuMP.optimize!(m)
    xval = JuMP.value.(x)
end

# ╔═╡ 01b906e0-886d-4d0a-b156-a08136cc12c0
let
    m = JuMP.Model()

    @variable(m, x >= -1_000)
    @NLobjective(m, Min, x^3)

    IPOPT = JuMP.optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0)
    CBC = JuMP.optimizer_with_attributes(Cbc.Optimizer, "logLevel" => 0)
    MINLP = JuMP.optimizer_with_attributes(Juniper.Optimizer, "nl_solver" => IPOPT, "mip_solver" => CBC)

    JuMP.set_optimizer(m, MINLP)
    JuMP.optimize!(m)
    xval = JuMP.value.(x)
end

# ╔═╡ 001d6566-8582-478b-9dda-6f68cfc3030c
let
    m = JuMP.Model()

    @variable(m, x >= -1_000)
    @NLobjective(m, Min, x^3)

    IPOPT = JuMP.optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0)
    CBC = JuMP.optimizer_with_attributes(Cbc.Optimizer, "logLevel" => 0)
    MINLP = JuMP.optimizer_with_attributes(Pavito.Optimizer, "cont_solver" => IPOPT, "mip_solver" => CBC)

    JuMP.set_optimizer(m, MINLP)
    JuMP.optimize!(m)
    xval = JuMP.value.(x)
end

# ╔═╡ 809abb19-0777-417c-8030-acfdd82d765a
let
    m = JuMP.Model()

    @variable(m, x >= -1_000)
    @NLobjective(m, Min, x^3)

    IPOPT = JuMP.optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0)
    CBC = JuMP.optimizer_with_attributes(Cbc.Optimizer, "logLevel" => 0)
    JUNIPER =
        JuMP.optimizer_with_attributes(Juniper.Optimizer, "nl_solver" => IPOPT, "mip_solver" => CBC, "log_levels" => [])
    PAVITO =
        JuMP.optimizer_with_attributes(Pavito.Optimizer, "cont_solver" => IPOPT, "mip_solver" => CBC, "log_level" => 0)

    MINLP = JuMP.optimizer_with_attributes(
        Alpine.Optimizer,
        "nlp_solver" => IPOPT,
        "mip_solver" => CBC,
        "minlp_solver" => nothing,
    )

    JuMP.set_optimizer(m, MINLP)
    JuMP.optimize!(m)
    xval = JuMP.value.(x)
end

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═dac312f0-28b6-4525-87ff-c50bab5edfaa
# ╠═901a223f-d796-4c38-b379-c7ee01943e35
# ╠═7d414528-acbb-427c-9dc1-991624b5e8e0
# ╟─76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═0c4bd17b-ddda-44ec-befc-426cf5cc25a9
# ╠═870fc9f3-49a7-4533-9b28-e4723172bb28
# ╠═dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
# ╠═01b906e0-886d-4d0a-b156-a08136cc12c0
# ╠═001d6566-8582-478b-9dda-6f68cfc3030c
# ╠═809abb19-0777-417c-8030-acfdd82d765a
