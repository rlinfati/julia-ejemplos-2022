### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 93de468e-20be-11ec-0a46-ff4fd7cb118e
let
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("HiGHS")
        Pkg.PackageSpec("Distributions")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 12077c04-7df7-4d8a-ba0f-812d2b8189c3
using JuMP, HiGHS, Distributions, Statistics, Random

# ╔═╡ 22ffa5b6-111c-4752-a2e9-9cc26080ab00
struct FacilityLocation
    nF::Int # number of facilities
    nC::Int # number of customers
    cx::Array{Float64,2} # cost of variable x (variable cost)
    cy::Array{Float64,1} # cost of variable y (fixed cost)
    o::Array{Float64,1} # supply
    d::Array{Any,1} # demand
end

# ╔═╡ 6fbcf0fc-2c1e-4bdd-8430-709a28b1c238
function verifyFacilityLocation(data::FacilityLocation)
    @assert length(data.cx) == data.nC * data.nF
    @assert length(data.cy) == data.nF
    @assert length(data.o) == data.nF
    @assert length(data.d) == data.nC
    @assert sum(mean.(data.d)) <= sum(data.o)
    return true
end

# ╔═╡ 26cf03f3-57fe-40ac-8df8-42245fae7bb6
let
    Random.seed!(1234)
    nF = 10
    nC = 5

    cx = rand(1:100, nC, nF)
    cy = rand(1000:9999, nF)
    o = rand(300:1000, nF)
    d = [
        Distributions.Normal(300.0, 10.0)
        Distributions.Normal(300.0, 50.0)
        Distributions.Normal(300.0, 100.0)
        Distributions.Normal(300.0, 50.0)
        Distributions.Normal(300.0, 10.0)
    ]

    global data1 = FacilityLocation(nF, nC, cx, cy, o, d)
    @assert verifyFacilityLocation(data1)

    data1
end

# ╔═╡ c41f59e5-623c-4019-a86c-70a72a902eef
function SampleFacilityLocation(
    data::FacilityLocation,
    de::Array{Float64,2},
    nE::Int;
    pE::Array{Float64,1} = inv(nE) * ones(nE),
    yfix = zeros(Bool, data.nF),
)
    nC = data.nC
    nF = data.nF

    @assert size(de) == (nC, nE)
    @assert length(pE) == nE
    @assert sum(pE) ≈ 1.0
    @assert length(yfix) == nF

    m = JuMP.Model()

    @variable(m, x[1:nC, 1:nF, 1:nE] >= 0)
    @variable(m, y[1:nF], Bin)

    @expression(m, z1, sum(data.cy .* y))
    @expression(m, z2[e in 1:nE], sum(data.cx .* x[:, :, e]))

    @objective(m, Min, z1 + sum(pE .* z2))

    @constraint(m, r01[c in 1:nC, e in 1:nE], sum(x[c, :, e]) >= de[c, e])
    @constraint(m, r03[f in 1:nF, e in 1:nE], sum(x[:, f, e]) <= data.o[f] * y[f])

    if sum(yfix) != zero(Int)
        JuMP.fix.(y, yfix)
    end

    JuMP.set_optimizer(m, HiGHS.Optimizer)
    JuMP.set_optimizer_attribute(m, "log_to_console", false)
    JuMP.set_optimizer_attribute(m, "time_limit", 60.0)
    JuMP.optimize!(m)

    tcpu = JuMP.solve_time(m)
    @assert JuMP.termination_status(m) == JuMP.MathOptInterface.OPTIMAL
    @assert JuMP.primal_status(m) == JuMP.MathOptInterface.FEASIBLE_POINT
    @assert JuMP.has_values(m) == true

    yval = JuMP.value.(y)
    yval = round.(Int, yval)
    zval = JuMP.value.(z1 .+ z2)

    return yval, zval
end

# ╔═╡ 90f452b2-6cf8-4f3d-b769-c0849175f131
begin
    nE = 3
    de = [quantile.(data1.d, 0.05) quantile.(data1.d, 0.50) quantile.(data1.d, 0.95)]
end

# ╔═╡ 21c78dbe-6426-48bc-8dca-853289c2f4dd
SampleFacilityLocation(data1, de, nE)

# ╔═╡ 536c2f5c-42a7-4dcd-aaea-b3499f6707e2
SampleFacilityLocation(data1, de, nE, pE = [0.08, 0.12, 0.80])

# ╔═╡ 63737926-3a54-4488-a7aa-baf450913e03
SampleFacilityLocation(data1, de, nE, yfix = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0])

# ╔═╡ 4f4160ac-6383-4cb5-8c76-b4096e2d1982
SampleFacilityLocation(data1, de, nE, pE = [0.3, 0.4, 0.3], yfix = [1, 1, 1, 0, 0, 0, 0, 1, 1, 1])

# ╔═╡ 4dba7117-2be2-4cdf-bcac-98e8017e5130
md"""
## SSA
"""

# ╔═╡ c52382b3-1ba5-4a01-88ca-0a7d2f0c23c9
begin
    factor = 2
    nSA = 10 * factor
    nE1 = 15 * factor
    nE2 = 100 * factor
end

# ╔═╡ 2f989670-27cf-468c-90e4-fcb20dba8ea9
begin
    # step 1
    s1_yval::Array{Array{Int,1},1} = []
    s1_zavg::Array{Float64,1} = []
    for sa in 1:nSA
        de1 = reduce(hcat, [rand.(data1.d) for _ in 1:nE1])
        yval1, zval1 = SampleFacilityLocation(data1, de1, nE1)

        push!(s1_yval, yval1)
        push!(s1_zavg, mean(zval1))
    end

    [s1_zavg s1_yval]
end

# ╔═╡ b1a20403-68e7-400f-aec8-8a12ee01a209
begin
    # step 2
    println("* step 2")
    @show zavg = mean(s1_zavg)
    @show zvar = var(s1_zavg) * inv(nSA)
end

# ╔═╡ a316707a-c3c1-4a13-98f0-683c6f4f6c6e
begin
    # step 3
    println("* step 3")
    s2_zavg::Array{Float64,1} = []
    s2_zvar::Array{Float64,1} = []
    for m in 1:nSA
        yval0 = s1_yval[m]
        de2 = reduce(hcat, [rand.(data1.d) for _ in 1:nE2])
        yval2, zval2 = SampleFacilityLocation(data1, de2, nE2, yfix = yval0)
        @assert yval2 == yval0
        push!(s2_zavg, mean(zval2))
        push!(s2_zvar, var(zval2) * inv(nE2))
    end
    s2_zavg
end

# ╔═╡ 0ac6e7d8-9fb9-441e-9047-70dd9c15be10
begin
    # step 4
    println("* step 4")
    @show idx = argmin(s2_zavg)
    @show gapp = s2_zavg[idx] - zavg
    @show gaa1 = gapp / zavg
    @show gvar = s2_zvar[idx] + zvar
end

# ╔═╡ 3f31e641-5c83-45e2-bdaf-08326a30e7e6

# ╔═╡ Cell order:
# ╠═93de468e-20be-11ec-0a46-ff4fd7cb118e
# ╠═12077c04-7df7-4d8a-ba0f-812d2b8189c3
# ╠═22ffa5b6-111c-4752-a2e9-9cc26080ab00
# ╠═6fbcf0fc-2c1e-4bdd-8430-709a28b1c238
# ╠═26cf03f3-57fe-40ac-8df8-42245fae7bb6
# ╠═c41f59e5-623c-4019-a86c-70a72a902eef
# ╠═90f452b2-6cf8-4f3d-b769-c0849175f131
# ╠═21c78dbe-6426-48bc-8dca-853289c2f4dd
# ╠═536c2f5c-42a7-4dcd-aaea-b3499f6707e2
# ╠═63737926-3a54-4488-a7aa-baf450913e03
# ╠═4f4160ac-6383-4cb5-8c76-b4096e2d1982
# ╟─4dba7117-2be2-4cdf-bcac-98e8017e5130
# ╠═c52382b3-1ba5-4a01-88ca-0a7d2f0c23c9
# ╠═2f989670-27cf-468c-90e4-fcb20dba8ea9
# ╠═b1a20403-68e7-400f-aec8-8a12ee01a209
# ╠═a316707a-c3c1-4a13-98f0-683c6f4f6c6e
# ╠═0ac6e7d8-9fb9-441e-9047-70dd9c15be10
# ╠═3f31e641-5c83-45e2-bdaf-08326a30e7e6
