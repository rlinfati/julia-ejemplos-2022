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
using JuMP, HiGHS, Distributions, Statistics

# ╔═╡ 22ffa5b6-111c-4752-a2e9-9cc26080ab00
struct FacilityLocation
    nC::Int # number of customers
    nF::Int # number of facilities
    nP::Int # p
    cF::Array{Float64,1} # fixed cost of facilities
    qF::Array{Float64,1} # capacity of facilities
    coorC::Array{Float64,2} # x,y of customers
    coorF::Array{Float64,2} # x,y of facilities
    de::Array{Any,1} # demand
    cC::Array{Float64,1} # cost of unsatisfied demand
    distm::Array{Float64,2} # distance matrix
end

# ╔═╡ 6fbcf0fc-2c1e-4bdd-8430-709a28b1c238
function verifyFacilityLocation(data::FacilityLocation)
    @assert 1 <= data.nP <= data.nF
    @assert length(data.cF) == data.nF
    @assert length(data.qF) == data.nF
    @assert size(data.coorC) == (data.nC, 2)
    @assert size(data.coorF) == (data.nF, 2)
    @assert length(data.de) == data.nC
    return true
end

# ╔═╡ 26cf03f3-57fe-40ac-8df8-42245fae7bb6
let
    nC = 4
    nF = 10
    nP = 2

    cF = 10_000 * ones(nF)
    qF = 3_000 * ones(nF)

    coorC = [
        -808.173 853.86
        638.46 548.485
        505.152 502.95
        550.152 532.95
    ]
    coorF = [
        520.181 -327.771
        -194.31 -708.177
        -498.155 -108.272
        -194.31 -708.177
        -742.364 750.494
        -801.871 -913.896
        525.289 724.879
        834.495 99.5397
        795.801 3.82173
        683.577 715.29
    ]

    de = [
        Distributions.Normal(1_000.0, 100.0)
        Distributions.Normal(360.0, 150.0)
        Distributions.Normal(360.0, 150.0)
        Distributions.Normal(360.0, 150.0)
    ]

    distf(c::Int, f::Int)::Float64 = sqrt((coorC[c, 1] - coorF[f, 1])^2 + (coorC[c, 2] - coorF[f, 2])^2)

    distm = [distf(c, f) for c in 1:nC, f in 1:nF]
    cC = (maximum(distm) + 1.0) * ones(nC)

    global data1 = FacilityLocation(nC, nF, nP, cF, qF, coorC, coorF, de, cC, distm)
    @assert verifyFacilityLocation(data1) == true

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
    nP = data.nP
    cF = data.cF
    qF = data.qF
    cC = data.cC
    distm = data.distm

    @assert length(pE) == nE
    @assert sum(pE) ≈ 1.0
    @assert size(de) == (nC, nE)
    @assert length(yfix) == nF
    @assert sum(yfix) == zero(Int) || sum(yfix) == nP

    m = JuMP.Model()

    @variable(m, x[1:nC, 1:nF, 1:nE] >= 0)
    @variable(m, y[1:nF], Bin)
    @variable(m, z[1:nC, 1:nE] >= 0)

    @expression(m, z1, sum(cF .* y))
    @expression(m, z2[e in 1:nE], sum(distm .* x[:, :, e]))
    @expression(m, z3[e in 1:nE], sum(cC .* z[:, e]))

    @objective(m, Min, z1 + sum(pE .* z2 + pE .* z3))

    @constraint(m, r01, sum(y) == nP)
    @constraint(m, r02[c in 1:nC, e in 1:nE], sum(x[c, :, e]) + z[c, e] >= de[c, e])
    @constraint(m, r03[f in 1:nF, e in 1:nE], sum(x[:, f, e]) <= qF[f] * y[f])

    if sum(yfix) != zero(Int)
        @assert sum(yfix) == nP
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
    zval = JuMP.value.(z1 .+ z2 .+ z3)

    return yval, zval
end

# ╔═╡ b4a43fbf-cb3e-49aa-8f3f-cab1d82c2584
begin
    nE = 3
    de = [quantile.(data1.de, 0.05) quantile.(data1.de, 0.50) quantile.(data1.de, 0.95)]
end

# ╔═╡ 764ee67c-663c-4b5b-8f49-a072e299cdb9
SampleFacilityLocation(data1, de, nE)

# ╔═╡ 6c69873c-52a1-4a20-9d90-99137cb95416
SampleFacilityLocation(data1, de, nE, pE = [0.15, 0.70, 0.15])

# ╔═╡ 6402aee3-c3d9-4124-848b-2e0ae0223ae9
SampleFacilityLocation(data1, de, nE, yfix = [1, 0, 0, 0, 0, 0, 0, 0, 0, 1])

# ╔═╡ 4dba7117-2be2-4cdf-bcac-98e8017e5130
SampleFacilityLocation(data1, de, nE, pE = [0.3, 0.4, 0.3], yfix = [1, 0, 0, 0, 0, 0, 0, 0, 0, 1])

# ╔═╡ 27c82989-e7e3-432a-9c9a-db3bc52635ac
md"""
## SSA
"""

# ╔═╡ b7394c26-2751-4ba1-985b-70658b537a7c
begin
    factor = 1
    nSA = 10 * factor
    nE1 = 15 * factor
    nE2 = 1000 * factor
end

# ╔═╡ ce08ddeb-fcec-4c4a-ab5f-1ff6585c2d27
begin
    # step 1
    s1_yval::Array{Array{Int,1},1} = []
    s1_zavg::Array{Float64,1} = []
    for sa in 1:nSA
        de1 = reduce(hcat, [rand.(data1.de) for _ in 1:nE1])
        yval1, zval1 = SampleFacilityLocation(data1, de1, nE1)

        push!(s1_yval, yval1)
        push!(s1_zavg, mean(zval1))
    end

    [s1_zavg s1_yval]
end

# ╔═╡ 116eba7c-6a2b-478f-aaa4-3f85d19f6d51
begin
    # step 2
    println("* step 2")
    @show zavg = mean(s1_zavg)
    @show zvar = var(s1_zavg) * inv(nSA)
end

# ╔═╡ fc45fe9a-9ff3-49ec-9ef9-aface4573642
begin
    # step 3
    s2_zavg::Array{Float64,1} = []
    s2_zvar::Array{Float64,1} = []
    for m in 1:nSA
        yval0 = s1_yval[m]
        de2 = reduce(hcat, [rand.(data1.de) for _ in 1:nE2])
        yval2, zval2 = SampleFacilityLocation(data1, de2, nE2, yfix = yval0)
        @assert yval2 == yval0
        push!(s2_zavg, mean(zval2))
        push!(s2_zvar, var(zval2) * inv(nE2))
    end
    s2_zavg
end

# ╔═╡ d0a498d0-166d-479a-8679-da64aacaf6f2
begin
    # step 4
    println("* step 4")
    @show idx = argmin(s2_zavg)
    @show gapp = s2_zavg[idx] - zavg
    @show gaa1 = gapp / zavg
    @show gvar = s2_zvar[idx] + zvar
end

# ╔═╡ Cell order:
# ╟─93de468e-20be-11ec-0a46-ff4fd7cb118e
# ╠═12077c04-7df7-4d8a-ba0f-812d2b8189c3
# ╠═22ffa5b6-111c-4752-a2e9-9cc26080ab00
# ╠═6fbcf0fc-2c1e-4bdd-8430-709a28b1c238
# ╠═26cf03f3-57fe-40ac-8df8-42245fae7bb6
# ╠═c41f59e5-623c-4019-a86c-70a72a902eef
# ╠═b4a43fbf-cb3e-49aa-8f3f-cab1d82c2584
# ╠═764ee67c-663c-4b5b-8f49-a072e299cdb9
# ╠═6c69873c-52a1-4a20-9d90-99137cb95416
# ╠═6402aee3-c3d9-4124-848b-2e0ae0223ae9
# ╠═4dba7117-2be2-4cdf-bcac-98e8017e5130
# ╟─27c82989-e7e3-432a-9c9a-db3bc52635ac
# ╠═b7394c26-2751-4ba1-985b-70658b537a7c
# ╠═ce08ddeb-fcec-4c4a-ab5f-1ff6585c2d27
# ╠═116eba7c-6a2b-478f-aaa4-3f85d19f6d51
# ╠═fc45fe9a-9ff3-49ec-9ef9-aface4573642
# ╠═d0a498d0-166d-479a-8679-da64aacaf6f2
