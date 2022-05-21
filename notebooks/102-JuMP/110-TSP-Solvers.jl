### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ e7262522-ac65-11ec-0633-1d82420161db
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add(
        [
            Pkg.PackageSpec("JuMP")
            Pkg.PackageSpec("GLPK")
            Pkg.PackageSpec("Cbc")
            Pkg.PackageSpec("HiGHS")
            Pkg.PackageSpec("SCIP")
            #Pkg.PackageSpec("CPLEX")
            #Pkg.PackageSpec("Gurobi")
            Pkg.PackageSpec("Plots")
        ],
    )
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ e726254a-ac65-11ec-2f4c-1bead54e006a
using JuMP

# ╔═╡ a6bc0450-5aee-4216-a54c-0a64fcf114f1
using GLPK

# ╔═╡ 8b4169cd-2976-445b-8923-c692d6cf2b82
using Cbc

# ╔═╡ f822eb0a-0a63-41ad-b0af-9b980aade47b
using HiGHS

# ╔═╡ 76a597c5-98f9-4a5f-a8e6-11d6da87a0b6
using SCIP

# ╔═╡ bb4218e4-06f0-482b-9ab6-55fedd51d429
using Random

# ╔═╡ 426900cf-6fd7-4668-8705-6c502ba99cbe
using Plots

# ╔═╡ feec1720-4efa-4688-9554-04fbe215072c
# using CPLEX

# ╔═╡ 2054908c-cc26-4a68-8c2f-69530e433fff
# using Gurobi

# ╔═╡ 59dfedd9-fab4-41ac-aa71-7bed4e0a7366
begin
    abstract type solverAbstract end
    struct solverGLPK <: solverAbstract end
    struct solverGLPK2 <: solverAbstract end
    struct solverCbc <: solverAbstract end
    struct solverHiGHS <: solverAbstract end
    struct solverSCIP <: solverAbstract end
    struct solverCPLEX <: solverAbstract end
    struct solverGurobi <: solverAbstract end
end

# ╔═╡ f9cb6029-062b-436e-968b-9e8e4dd7b8f6
function instance01(n::Int = 7)
    Random.seed!(1234)
    X = rand(n) * 1_000.0
    Y = rand(n) * 1_000.0
    return X, Y
end

# ╔═╡ c2a2b9e2-170f-44eb-be42-ea3219836e91
function processInsta(X::Vector{Float64}, Y::Vector{Float64})
    n = length(X)
    @assert n == length(Y)

    d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:n, j in 1:n]
    return d
end

# ╔═╡ 9d0c2f79-93f2-4bfe-a449-c8c2483a0016
function solveTSP!(m::JuMP.Model, ::solverGLPK)
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)

    JuMP.set_optimizer_attribute(m, "fp_heur", GLP_OFF)
    JuMP.set_optimizer_attribute(m, "ps_heur", GLP_OFF)

    JuMP.set_optimizer_attribute(m, "gmi_cuts", GLP_OFF)
    JuMP.set_optimizer_attribute(m, "mir_cuts", GLP_OFF)
    JuMP.set_optimizer_attribute(m, "cov_cuts", GLP_OFF)
    JuMP.set_optimizer_attribute(m, "clq_cuts", GLP_OFF)

    JuMP.set_optimizer_attribute(m, "presolve", GLP_OFF)

    JuMP.optimize!(m)
    return nothing
end

# ╔═╡ 3602e938-0955-4efc-b590-1eebdb714fbb
function solveTSP!(m::JuMP.Model, ::solverGLPK2)
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)

    JuMP.set_optimizer_attribute(m, "fp_heur", GLP_ON)
    JuMP.set_optimizer_attribute(m, "ps_heur", GLP_ON)
    JuMP.set_optimizer_attribute(m, "ps_tm_lim", 1.0 * 1000)

    JuMP.set_optimizer_attribute(m, "gmi_cuts", GLP_ON)
    JuMP.set_optimizer_attribute(m, "mir_cuts", GLP_ON)
    JuMP.set_optimizer_attribute(m, "cov_cuts", GLP_ON)
    JuMP.set_optimizer_attribute(m, "clq_cuts", GLP_ON)

    JuMP.set_optimizer_attribute(m, "presolve", GLP_ON)

    JuMP.set_optimizer_attribute(m, "mip_gap", 0.01)

    JuMP.optimize!(m)
    return nothing
end

# ╔═╡ d7708c0c-bf22-40e4-b58e-2787f57a4ce6
function solveTSP!(m::JuMP.Model, ::solverCbc)
    JuMP.set_optimizer(m, Cbc.Optimizer)
    JuMP.set_optimizer_attribute(m, "logLevel", 1)
    JuMP.set_optimizer_attribute(m, "seconds", 60)
    JuMP.optimize!(m)
    return nothing
end

# ╔═╡ 4457c6f1-bf75-4c47-814e-be4adda8a1a2
function solveTSP!(m::JuMP.Model, ::solverHiGHS)
    JuMP.set_optimizer(m, HiGHS.Optimizer)
    JuMP.set_optimizer_attribute(m, "log_to_console", true)
    JuMP.set_optimizer_attribute(m, "log_file", joinpath(@__DIR__, "logfile.txt"))
    JuMP.set_optimizer_attribute(m, "time_limit", 60.0)
    JuMP.optimize!(m)
    return nothing
end

# ╔═╡ 5175db90-1bf4-44c1-9ff0-65f81a25b138
function solveTSP!(m::JuMP.Model, ::solverSCIP)
    JuMP.set_optimizer(m, SCIP.Optimizer)
    JuMP.set_optimizer_attribute(m, "display/verblevel", 2)
    JuMP.set_optimizer_attribute(m, "limits/time", 60)
    JuMP.optimize!(m)
    return nothing
end

# ╔═╡ 5de47f3e-63f0-4a5f-98db-e7701e407f27
function solveTSP!(m::JuMP.Model, ::solverCPLEX)
    JuMP.set_optimizer(m, CPLEX.Optimizer)
    JuMP.set_optimizer_attribute(m, "CPX_PARAM_MIPDISPLAY", 3)
    JuMP.set_optimizer_attribute(m, "CPX_PARAM_TILIM", 60)
    JuMP.optimize!(m)
    return nothing
end

# ╔═╡ 48e6f211-27a6-42a2-8c4a-4352863da1fa
function solveTSP!(m::JuMP.Model, ::solverGurobi)
    JuMP.set_optimizer(m, Gurobi.Optimizer)
    JuMP.set_optimizer_attribute(m, "LogToConsole", 1)
    JuMP.set_optimizer_attribute(m, "LogFile", joinpath(@__DIR__, "logfile.txt"))
    JuMP.set_optimizer_attribute(m, "TimeLimit", 60)
    JuMP.optimize!(m)
    return nothing
end

# ╔═╡ 3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
function modelTSP(d::Matrix{Float64}, solver::solverAbstract)
    n, n2 = size(d)
    @assert n == n2

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

    solveTSP!(m, solver)

    return m
end

# ╔═╡ 83f4e638-1488-467c-ae8e-f62f583c7ab3
function solutionTSP(m::JuMP.Model)
    if JuMP.primal_status(m) != JuMP.MOI.FEASIBLE_POINT
        return Int[]
    end

    xval = round.(Int, JuMP.value.(m[:x]))

    tour = Int[1]
    while true
        push!(tour, argmax(xval[tour[end], :]))
        if tour[end] == 1
            break
        end
    end
    return tour
end

# ╔═╡ 594761f6-941d-45f0-8c75-c48acda46b03
function plotTSP(X::Vector{Float64}, Y::Vector{Float64}, t::Vector{Int})
    p = plot(legend = false)
    scatter!(X, Y, color = :blue)

    if length(t) == length(X) + 1
        plot!(X[t], Y[t], color = :red)
    end

    return p
end

# ╔═╡ 450df63d-93c2-4b44-9fda-0387fc396bec
begin
    X, Y = instance01(7)
    d = processInsta(X, Y)
    m = modelTSP(d, solverGLPK())
    println(JuMP.solution_summary(m))
    t = solutionTSP(m)
    p = plotTSP(X, Y, t)
end

# ╔═╡ Cell order:
# ╟─e7262522-ac65-11ec-0633-1d82420161db
# ╠═e726254a-ac65-11ec-2f4c-1bead54e006a
# ╠═a6bc0450-5aee-4216-a54c-0a64fcf114f1
# ╠═8b4169cd-2976-445b-8923-c692d6cf2b82
# ╠═f822eb0a-0a63-41ad-b0af-9b980aade47b
# ╠═76a597c5-98f9-4a5f-a8e6-11d6da87a0b6
# ╠═feec1720-4efa-4688-9554-04fbe215072c
# ╠═2054908c-cc26-4a68-8c2f-69530e433fff
# ╠═bb4218e4-06f0-482b-9ab6-55fedd51d429
# ╠═426900cf-6fd7-4668-8705-6c502ba99cbe
# ╠═59dfedd9-fab4-41ac-aa71-7bed4e0a7366
# ╠═f9cb6029-062b-436e-968b-9e8e4dd7b8f6
# ╠═c2a2b9e2-170f-44eb-be42-ea3219836e91
# ╠═3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
# ╠═9d0c2f79-93f2-4bfe-a449-c8c2483a0016
# ╠═3602e938-0955-4efc-b590-1eebdb714fbb
# ╠═d7708c0c-bf22-40e4-b58e-2787f57a4ce6
# ╠═4457c6f1-bf75-4c47-814e-be4adda8a1a2
# ╠═5175db90-1bf4-44c1-9ff0-65f81a25b138
# ╠═5de47f3e-63f0-4a5f-98db-e7701e407f27
# ╠═48e6f211-27a6-42a2-8c4a-4352863da1fa
# ╠═83f4e638-1488-467c-ae8e-f62f583c7ab3
# ╠═594761f6-941d-45f0-8c75-c48acda46b03
# ╠═450df63d-93c2-4b44-9fda-0387fc396bec
