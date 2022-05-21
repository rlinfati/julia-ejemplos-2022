### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("Optim")
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("Ipopt")
        Pkg.PackageSpec("Plots")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ c349935f-7631-4fb5-a723-475798a596ec
using Optim

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ dac312f0-28b6-4525-87ff-c50bab5edfaa
using Ipopt

# ╔═╡ 901a223f-d796-4c38-b379-c7ee01943e35
using Statistics

# ╔═╡ 7d414528-acbb-427c-9dc1-991624b5e8e0
using Plots

# ╔═╡ 2c9491b7-18cf-4145-8ead-f8c3ad11dbff
n = 10

# ╔═╡ 6fe6c23b-1f1e-413f-b7c7-a5c9799ec8eb
x = sort(rand(-10:100, n))

# ╔═╡ b10222ca-0c5b-408f-8e83-e1ad48f8febe
y = 5 / 9 .* (x .- 32) .+ 0 .* randn.() # y =  5/9 .* (x .- 32) + error

# ╔═╡ 47b040e6-3914-4dce-bfd0-7d5782fd3180
begin
    plot(x, y, m = :c, mc = :red, legend = false, ls = :dash)
    xlabel!("°F")
    ylabel!("°C")
    # plot!(x, x/2 .- 16) # RL Aproximacion
end

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
# **Least-squares fitting**
"""

# ╔═╡ a88af8de-9885-4c7a-bf14-7461d74ed5ab
md"""
## Solución del profesor de estadistica
"""

# ╔═╡ 8269be24-2a95-499e-a8cd-4b126dc9db45
begin
    m = cov(x, y) / var(x) # same as (x.-mean(x))⋅(y.-mean(y))/sum(abs2,x.-mean(x))
    b = mean(y) - m * mean(x)
    b, m
end

# ╔═╡ df0124c3-3421-4375-af6c-93f647d86999
plot!(x -> m * x + b, lw = 3, alpha = 0.7)

# ╔═╡ 2ff1bc90-0a6f-4c05-8ed1-f826993999b1
md"""
## Solución del profesor de algebra
"""

# ╔═╡ b605664f-ad6e-4b03-801f-9950e6a74006
[one.(x) x] \ y

# ╔═╡ baa542e0-e707-4680-bf93-0fe114d20367
[one.(x) x] * [-32 * 5 / 9; 5 / 9] - y

# ╔═╡ 22ad57f6-4db9-44eb-8256-8906c498a480
md"""
## Solución del profesor de optimizacion
"""

# ╔═╡ daae866e-8600-4a34-b219-9c535d7bc710
md"""
## Optim.jl
[Optim.jl Documentation](https://julianlsolvers.github.io/Optim.jl/stable/)

$$\min_{b,m} \sum_{i=1}^n  [ (b + m x_i) - y_i]^2$$

"""

# ╔═╡ d9897112-0320-4d57-b6f8-ab4c2f7ab158
begin
    f((b, m)) = sum((b + m * x[i] - y[i])^2 for i in 1:n)
    x0 = [0.0, 0.0]
    result = optimize(f, x0)
    # result =  optimize(f, x0, BFGS())
    # result =  optimize(f, x0, BFGS(),  autodiff=:forward)
    # result =  optimize(f, x0, GradientDescent())
    # result =  optimize(f, x0, GradientDescent(),  autodiff=:forward)
    println(result)
    result.minimizer
end

# ╔═╡ c959003c-4d6e-46c2-b68d-ca843b30108b
md"""
## JuMP.jl
[JuMP.jl Documentation](https://jump.dev/JuMP.jl/stable/)

JuMP = Julia for Mathematical Programming
"""

# ╔═╡ c03d9603-8b82-420b-9e1b-a39ed5bdb53d
let
    model = JuMP.Model()

    @variable(model, b)
    @variable(model, m)

    @objective(model, Min, sum((b + m * x[i] - y[i])^2 for i in 1:n))

    JuMP.set_optimizer(model, Ipopt.Optimizer)
    JuMP.set_optimizer_attribute(model, "print_level", 0)
    JuMP.optimize!(model)

    xval = JuMP.value.([b, m])
end

# ╔═╡ aa96f306-5e40-41af-9bac-a43a1a8d5c7b
md"""
### Ejemplo sin restricciones
"""

# ╔═╡ fd5eae5f-3aa4-49ae-890b-cb1eaf079129
begin
    f1(x) = x^2 - 10 * x + 2
end

# ╔═╡ e6603629-6a99-42b1-bcbc-3d3477522a34
begin
    model = JuMP.Model()

    @variable(model, -10 <= xi <= 10)

    register(model, :f1, 1, f1, autodiff = true)
    @NLobjective(model, Min, f1(xi))

    JuMP.set_optimizer(model, Ipopt.Optimizer)
    JuMP.set_optimizer_attribute(model, "print_level", 0)
    JuMP.optimize!(model)

    xival = JuMP.value.(xi)
end

# ╔═╡ 578bb8da-0ad8-41f3-bef6-8dda2d9fe684
begin
    plot(f1, -10, 20, leg = false)
    scatter!([xival], [f1(xival)])
end

# ╔═╡ a108e20d-21df-4121-b8ad-a7489a5dfd54
md"""
### Ejemplo con restricciones
"""

# ╔═╡ 2176a717-3f0f-46a2-be89-6ee3f4fcdcad
begin
    k(x, y) = x^2 + y^2
    l(x, y) = y - x
    lb = 2
    nothing
end

# ╔═╡ 7f224fc8-7de2-4509-98e1-9b80c4e3aadd
begin
    m2 = JuMP.Model()

    @variable(m2, -10 ≤ xj ≤ 10)
    @variable(m2, -10 ≤ yj ≤ 10)

    register(m2, :k, 2, k, autodiff = true)
    register(m2, :l, 2, l, autodiff = true)

    @NLobjective(m2, Min, k(xj, yj))
    @NLconstraint(m2, l(xj, yj) == lb)

    JuMP.set_optimizer(m2, Ipopt.Optimizer)
    JuMP.set_optimizer_attribute(m2, "print_level", 0)
    JuMP.optimize!(m2)

    xjval, yjval = JuMP.value.([xj, yj])
end

# ╔═╡ 5c39efc8-2c41-47c4-a9c7-6f0fe75f0a40
begin
    r = -5:0.1:5
    contour(r, r, k, leg = false)
    contour!(r, r, l, levels = [lb], ratio = 1, lw = 3)
    scatter!([xjval], [yjval])
end

# ╔═╡ 8587734d-c29c-423f-9846-bc8893f2446f
md"""
$y - x = b$ entonces $y = x + b$

$z = x^2 + y^2 = x^2 + (x + b)^2$
"""

# ╔═╡ 4bacb36c-2a77-4a13-98fa-2657059e974e
begin
    surface(-5:0.1:5, -5:0.1:5, k, alpha = 0.5, leg = false)

    xs = -5:0.1:5
    ys = xs .+ lb
    plot!(xs, ys, k.(xs, ys), lw = 3)

    scatter!([xjval], [yjval], [k(xjval, yjval)], zlim = (-10, 50), xlim = (-5, 5), ylim = (-5, 5))
end

# ╔═╡ 9d045bfd-a492-4670-8941-f8afb33f37a5
md"""
TODO: fix plotly()

[optimization_with_JuMP](https://computationalthinking.mit.edu/Spring21/optimization_with_JuMP/)

"""

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═c349935f-7631-4fb5-a723-475798a596ec
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═dac312f0-28b6-4525-87ff-c50bab5edfaa
# ╠═901a223f-d796-4c38-b379-c7ee01943e35
# ╠═7d414528-acbb-427c-9dc1-991624b5e8e0
# ╠═2c9491b7-18cf-4145-8ead-f8c3ad11dbff
# ╠═6fe6c23b-1f1e-413f-b7c7-a5c9799ec8eb
# ╠═b10222ca-0c5b-408f-8e83-e1ad48f8febe
# ╠═47b040e6-3914-4dce-bfd0-7d5782fd3180
# ╟─76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╟─a88af8de-9885-4c7a-bf14-7461d74ed5ab
# ╠═8269be24-2a95-499e-a8cd-4b126dc9db45
# ╠═df0124c3-3421-4375-af6c-93f647d86999
# ╟─2ff1bc90-0a6f-4c05-8ed1-f826993999b1
# ╠═b605664f-ad6e-4b03-801f-9950e6a74006
# ╠═baa542e0-e707-4680-bf93-0fe114d20367
# ╟─22ad57f6-4db9-44eb-8256-8906c498a480
# ╟─daae866e-8600-4a34-b219-9c535d7bc710
# ╠═d9897112-0320-4d57-b6f8-ab4c2f7ab158
# ╟─c959003c-4d6e-46c2-b68d-ca843b30108b
# ╠═c03d9603-8b82-420b-9e1b-a39ed5bdb53d
# ╟─aa96f306-5e40-41af-9bac-a43a1a8d5c7b
# ╠═fd5eae5f-3aa4-49ae-890b-cb1eaf079129
# ╠═e6603629-6a99-42b1-bcbc-3d3477522a34
# ╠═578bb8da-0ad8-41f3-bef6-8dda2d9fe684
# ╟─a108e20d-21df-4121-b8ad-a7489a5dfd54
# ╠═2176a717-3f0f-46a2-be89-6ee3f4fcdcad
# ╠═7f224fc8-7de2-4509-98e1-9b80c4e3aadd
# ╠═5c39efc8-2c41-47c4-a9c7-6f0fe75f0a40
# ╟─8587734d-c29c-423f-9846-bc8893f2446f
# ╠═4bacb36c-2a77-4a13-98fa-2657059e974e
# ╟─9d045bfd-a492-4670-8941-f8afb33f37a5
