### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 47e373da-ac3c-11ec-01f3-4d2837d60a99
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

# ╔═╡ e822ad44-1238-4f6d-b7ef-1188f3062629
md"""
### Multiplicacion de Matrices
"""

# ╔═╡ 84aea32c-d096-4eb7-a8fe-f1c5ffea6b05
function m1(A, B)
    C = A * B
    return C
end

# ╔═╡ 194998c0-f256-48f5-86d3-292a4769ffbf
function m2(A, B)
    n, n2 = size(A)
    @assert n == n2
    @assert size(A) == size(B)

    C = zero(A)
    for i in 1:n
        for j in 1:n
            for k in 1:n
                C[i, j] += A[i, k] * B[k, j]
            end
        end
    end
    return C
end

# ╔═╡ 15b0ff2b-5d5c-494e-81a5-ce268741e724
function m3(A, B)
    n, n2 = size(A)
    @assert n == n2
    @assert size(A) == size(B)

    C = zero(A)
    for i in 1:n
        for j in 1:n
            a = @view A[i, :]
            b = @view B[:, j]
            C[i, j] = a' * b
        end
    end
    return C
end

# ╔═╡ 91901a6d-bb3d-47bc-b87b-ad1eabe85420
function main(n::Int, t = Float64)
    A = rand(t, n, n)
    B = rand(t, n, n)
    if t in [Int16, Int32, Int64]
        A .% 10_000
        B .% 10_000
    end
    @show t, n
    @time C1 = m1(A, B)
    @time C2 = m2(A, B)
    @time C3 = m3(A, B)
    println(n * n - sum(C1 .≈ C2), '\t', n * n - sum(C1 .== C2))
    println(n * n - sum(C1 .≈ C3), '\t', n * n - sum(C1 .== C3))
    return
end

# ╔═╡ 650a5164-69ba-4eb1-8c9a-bb35a5f99771
main(1_000, Int16)

# ╔═╡ f70cc582-eeb5-4ac4-865e-57ba1a689883
main(1_000, Int32)

# ╔═╡ 640fda51-0f51-4614-87ca-4cbbb0261581
main(1_000, Int64)

# ╔═╡ 30ba4426-7bd6-43dc-b390-a3bab06cbcce
main(1_000, Float16)

# ╔═╡ 448296ce-2293-468e-86a6-d6166b27c123
main(1_000, Float32)

# ╔═╡ d5cd7ed1-61be-41ed-8473-a54b047f22a3
main(1_000, Float64)

# ╔═╡ Cell order:
# ╟─47e373da-ac3c-11ec-01f3-4d2837d60a99
# ╟─e822ad44-1238-4f6d-b7ef-1188f3062629
# ╠═84aea32c-d096-4eb7-a8fe-f1c5ffea6b05
# ╠═194998c0-f256-48f5-86d3-292a4769ffbf
# ╠═15b0ff2b-5d5c-494e-81a5-ce268741e724
# ╠═91901a6d-bb3d-47bc-b87b-ad1eabe85420
# ╠═650a5164-69ba-4eb1-8c9a-bb35a5f99771
# ╠═f70cc582-eeb5-4ac4-865e-57ba1a689883
# ╠═640fda51-0f51-4614-87ca-4cbbb0261581
# ╠═30ba4426-7bd6-43dc-b390-a3bab06cbcce
# ╠═448296ce-2293-468e-86a6-d6166b27c123
# ╠═d5cd7ed1-61be-41ed-8473-a54b047f22a3
