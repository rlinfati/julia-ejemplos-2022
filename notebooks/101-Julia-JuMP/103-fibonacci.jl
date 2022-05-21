### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
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

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
n = 40

# ╔═╡ 58c2ea61-c9b4-4454-b74f-6c3f8af51ec7
function fib_recursive(n::Int)
    if n == 1 || n == 0
        return n
    end
    return fib_recursive(n - 1) + fib_recursive(n - 2)
end

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
@timev fib_recursive(n)

# ╔═╡ 0c5cea8e-ec2c-42e4-9b53-cca423636d24
function fib_iterative(n::Int)
    x = 0
    y = 1
    z = 1
    for _ in 1:n
        x = y
        y = z
        z = x + y
    end
    return x
end

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
@timev fib_iterative(n)

# ╔═╡ c89a9a9e-b463-4e94-9501-ad3fe1a99101
function fib_matrix(n::Int)
    if n == 0
        return 0
    end
    F = [1 1; 1 0]^(n - 1)
    return F[1, 1]
end

# ╔═╡ 886ec68e-3134-40fd-bf61-4346e12caa25
@timev fib_matrix(n)

# ╔═╡ 70dbab2e-0520-4f51-bd01-b902e420cbc4
function fib_magic(n::Int)
    phi = (1 + sqrt(5.0)) / 2.0
    return round(Int, (phi^n) / sqrt(5.0))
end

# ╔═╡ c96fd875-b1f7-4115-8b0c-f1454343fe35
@timev fib_magic(n)

# ╔═╡ Cell order:
# ╟─ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═58c2ea61-c9b4-4454-b74f-6c3f8af51ec7
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╠═0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═c89a9a9e-b463-4e94-9501-ad3fe1a99101
# ╠═886ec68e-3134-40fd-bf61-4346e12caa25
# ╠═70dbab2e-0520-4f51-bd01-b902e420cbc4
# ╠═c96fd875-b1f7-4115-8b0c-f1454343fe35
