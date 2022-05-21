### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 47e373da-ac3c-11ec-01f3-4d2837d60a99
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([Pkg.PackageSpec("Plots")])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ 6e981460-39dd-489c-940f-4eca90ca70c1
using Plots

# ╔═╡ e822ad44-1238-4f6d-b7ef-1188f3062629
md"""
### Complejidad O(n)
"""

# ╔═╡ 84aea32c-d096-4eb7-a8fe-f1c5ffea6b05
function f1(n::Int = 10)
    c = 0.0
    for i in 1:n
        c += rand()
    end
    return c
end

# ╔═╡ 194998c0-f256-48f5-86d3-292a4769ffbf
md"""
### Complejidad O(n^2)
"""

# ╔═╡ ef8867b0-a014-4ea4-9608-f0f86110d845
function f2(n::Int = 10)
    c = 0.0
    for i in 1:n
        for j in 1:n
            c += rand()
        end
    end
    return c
end

# ╔═╡ 15b0ff2b-5d5c-494e-81a5-ce268741e724
md"""
### Complejidad O(n^3)
"""

# ╔═╡ 91901a6d-bb3d-47bc-b87b-ad1eabe85420
function f3(n::Int = 10)
    c = 0.0
    for i in 1:n
        for j in 1:n
            for k in 1:n
                c += rand()
            end
        end
    end
    return c
end

# ╔═╡ 650a5164-69ba-4eb1-8c9a-bb35a5f99771
@elapsed f1(10)

# ╔═╡ f70cc582-eeb5-4ac4-865e-57ba1a689883
@elapsed f1(10_000)

# ╔═╡ 640fda51-0f51-4614-87ca-4cbbb0261581
@elapsed f2(10)

# ╔═╡ 30ba4426-7bd6-43dc-b390-a3bab06cbcce
@elapsed f2(10_000)

# ╔═╡ 448296ce-2293-468e-86a6-d6166b27c123
begin
    y1 = []
    y2 = []
    y3 = []
    for i in 100:100:700
        a = @elapsed f1(i)
        b = @elapsed f2(i)
        c = @elapsed f3(i)
        push!(y1, a)
        push!(y2, b)
        push!(y3, c)
    end
end

# ╔═╡ d5cd7ed1-61be-41ed-8473-a54b047f22a3
[y1 y2 y3]

# ╔═╡ 377c3be8-7c56-401b-9924-8c9753ed3ba0
begin
    plot(y1)
    plot!(y2)
    #plot!(y3)
end

# ╔═╡ Cell order:
# ╟─47e373da-ac3c-11ec-01f3-4d2837d60a99
# ╠═6e981460-39dd-489c-940f-4eca90ca70c1
# ╟─e822ad44-1238-4f6d-b7ef-1188f3062629
# ╠═84aea32c-d096-4eb7-a8fe-f1c5ffea6b05
# ╟─194998c0-f256-48f5-86d3-292a4769ffbf
# ╠═ef8867b0-a014-4ea4-9608-f0f86110d845
# ╟─15b0ff2b-5d5c-494e-81a5-ce268741e724
# ╠═91901a6d-bb3d-47bc-b87b-ad1eabe85420
# ╠═650a5164-69ba-4eb1-8c9a-bb35a5f99771
# ╠═f70cc582-eeb5-4ac4-865e-57ba1a689883
# ╠═640fda51-0f51-4614-87ca-4cbbb0261581
# ╠═30ba4426-7bd6-43dc-b390-a3bab06cbcce
# ╠═448296ce-2293-468e-86a6-d6166b27c123
# ╠═d5cd7ed1-61be-41ed-8473-a54b047f22a3
# ╠═377c3be8-7c56-401b-9924-8c9753ed3ba0
