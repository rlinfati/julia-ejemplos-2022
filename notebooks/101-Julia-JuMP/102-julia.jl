### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 00afa180-ac4b-11ec-06c5-87c2e45a34bc
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

# ╔═╡ d9f1d475-8e5c-4c27-8c19-26c3812ff99e
md"""
# Primeros pasos en Julia
"""

# ╔═╡ 00839514-e5dd-455b-aec1-487a2fbd77fd
md"""
## Variables (de programación)
"""

# ╔═╡ da2b00b0-a21e-4428-9f71-a35fb5ac3585
x = 3

# ╔═╡ 9af9cf8c-2d84-4f3f-a466-3e290eaf25c3
md"""
De forma predeterminada, Julia muestra el resultado de la última operación. (Puede suprimir la salida agregando `;` (un punto y coma) al final.
"""

# ╔═╡ 097b47e7-969f-4a45-998c-f47f0072d832
y = 2x

# ╔═╡ c00f8154-e5b7-4e28-ace7-5d07fb552cea
md"""
Podemos obtener qué tipo de datos es una variable usando `typeof`
"""

# ╔═╡ c4f41f7a-c053-4fee-8049-1983c7471a04
"Hola Mundo";

# ╔═╡ d893a1ea-78b3-4349-b85d-fb44cd1401c6
println("Hello, World!");

# ╔═╡ 680f263d-8dbe-480b-9dc6-773128a37502
typeof(y)

# ╔═╡ ff2cc0cb-ce22-4e8f-8efa-cbec80e4d3af
typeof(1 + -2)

# ╔═╡ 52889dc5-abe1-49b5-9803-7105c389d3b5
typeof(1.2 - 2.3)

# ╔═╡ 0ae41766-2562-44e0-84f3-4af9acfaaf8e
typeof(pi)

# ╔═╡ a5b9c354-a7c2-4e7d-8df2-7ed953cc0f95
typeof(π)

# ╔═╡ 8c5ec749-932a-44a8-a53a-099f37fe53d7
typeof(2 + 3im)

# ╔═╡ 9bd51d8b-b894-4fac-b428-29d0015fb179
typeof(2.0 + 3.0im)

# ╔═╡ a2e8d157-83f1-4da4-ab5f-e730f8d033f4
typeof("This is Julia")

# ╔═╡ dd358d52-6053-4d0f-aca9-ff0bcd7852dd
typeof([1, 2])

# ╔═╡ 71afab5f-2430-430c-8383-0c07154ec267
typeof([1 2])

# ╔═╡ f2934b8a-5baf-4e8c-bdd3-1db5b127205b
typeof([1 2; 3 4])

# ╔═╡ de4b8c11-93bc-489c-ba97-2786b635007a
md"""
## Funciones
"""

# ╔═╡ f7f77c73-a9dc-4159-a34d-60bd99a46958
md"""
Podemos usar una función abreviada de una línea para funciones simples
"""

# ╔═╡ 33ccbc8b-4d7e-4dda-80f9-346ae75bb40d
f(x) = 2 + x

# ╔═╡ 8b85f6e2-7fe3-430f-9e86-e6e6dc2439ad
md"""
Escribiendo el nombre de la función proporciona información sobre la función. Para llamarlo debemos usar paréntesis
"""

# ╔═╡ fddc6109-0ba3-419f-9bc1-e04d5de680b1
f

# ╔═╡ 1d3a8ca3-633c-40f7-9f00-eb4c104a3d55
f(10)

# ╔═╡ 33847b9b-c2eb-4c8b-b356-767d0624c3e3
md"""
Para funciones más largas usamos la siguiente sintaxis con la palabra clave `function` y `end`
"""

# ╔═╡ aaf59954-4118-4ef3-ad18-d489e67922cc
function g(x, y)
    z = x + y
    return z^2
end

# ╔═╡ bdbc2778-4a27-4101-b16a-e756d9f440e0
g(1, 2)

# ╔═╡ 409a4115-6945-4098-9ea9-4fb32e6df8c8
md"""
## Ciclos For
"""

# ╔═╡ 6c8326bd-3a49-4976-beab-c8eec9df028e
md"""
Use `for` para recorrer un conjunto de valores"
"""

# ╔═╡ 96389d6e-c6ba-4362-a748-dabd77f87ff4
begin
    s = 0
    for i in 1:10
        s += i # Equivalente a s = s + i
    end
    s
end

# ╔═╡ 43d4cee8-a06f-4537-91ea-08d1e56e1af0
md"""
Aquí, `1:10` es un **rango** que representa los números del 1 al 10"
"""

# ╔═╡ 96ce4e55-aecf-4411-9481-bb0a0e08ee8d
typeof(1:10)

# ╔═╡ d2b7aca9-656e-46fd-84b0-66838f47208b
md"""
Arriba usamos un bloque `begin` para definir más de una linea de codigo por celda 

Abajo usaremos un bloque `let` para definir una nueva variable **local** `s2`.
Pero los bloques de código como este suelen ser mejores dentro de las funciones, por lo que pueden reutilizarse. Por ejemplo, podríamos reescribir lo anterior de las siguiente maneras:
"""

# ╔═╡ e872f7cb-315a-44bf-968e-18e0215437ee
s

# ╔═╡ 99f471cf-38df-410c-9568-e7e71e0422f2
let
    # Ejemplo no recomendado, ver siguiente cuadro
    s2 = 0
    for i in 1:10
        s2 += i # Equivalente a s = s + i
    end
    s2
end

# ╔═╡ e1f24e16-1a9b-431e-9b48-6bfcf23b80ea
s2

# ╔═╡ cc8b5e24-cfae-4cc6-8f22-1db7ac5a2976
function mysum(n)
    s = 0
    for i in 1:n
        s += i
    end
    return s
end

# ╔═╡ 66f070df-42e7-45dc-85cb-8fd7a7f58f23
mysum(10)

# ╔═╡ cb9d71dd-0f64-499b-bc57-e0a5edf8b0fc
md"""
## Condicional: `if`
"""

# ╔═╡ 73b989bd-9a56-4109-81ce-48f0b0568d88
md"""
Podemos evaluar si una condición es verdadera o falsa simplemente escribiendo la condición
"""

# ╔═╡ fa4aae9a-2170-4ceb-9df7-d1b8f1d3bb9e
a = 3

# ╔═╡ 46d7a3a6-9fa1-4101-b95f-8cd1f3c71eb2
a < 5

# ╔═╡ 09ad02f7-f451-406d-8390-6cbf6f0baa57
md"""
Vemos que las condiciones tienen un valor booleano (`true` o `false`).
Luego podemos usar `if` para controlar lo que hacemos en función de ese valor
"""

# ╔═╡ 5b6020f9-ae64-4848-a302-d6194de10366
if a < 5
    "pequeño"
else
    "grande"
end

# ╔═╡ 05a9d3dc-15d3-439d-8c40-d7470510dd18
md"""
Tenga en cuenta que `if` también devuelve el último valor que se evaluó, en este caso, el texto `"pequeño"` o `"grande"`. Dado que Pluto es reactivo, cambiar la definición de `a` anterior hará que esto se produzca automáticamente al ser reevaluado!
"""

# ╔═╡ c4ee2829-f0db-4b92-a2ef-c609e455c5d9
md"""
## Ejemplo de `for` e `if`
"""

# ╔═╡ 9fdea952-30f9-4b54-b9e5-82f59fb496c8
for i in 0:3:15
    if i < 5
        println("$i is less than 5")
    elseif i < 10
        println("$i is less than 10")
    else
        if i == 12
            println("the value is 12")
        else
            println("$i is bigger than 10")
        end
    end
end

# ╔═╡ d2cfe345-6f06-4629-91c5-f23ab9702eaf
typeof(0:3:15)

# ╔═╡ a2b957fc-a4eb-4924-9144-0ee2d41f8d00
dump(0:3:15)

# ╔═╡ 99bd23c8-1c17-4e0d-a8ed-497cc3772fef
md"""
## Vectores - *Array* 1D
"""

# ╔═╡ 9d6772dd-2855-4ef5-becc-2740596e3e7f
md"""
Podemos hacer un 'Vector' (*array* unidimensional) usando corchetes"
"""

# ╔═╡ cbcce4f8-bc6a-40dd-845c-7c104a1b691e
v = [1, 2, 3]

# ╔═╡ df58fe75-1840-48af-93ef-19711fe21402
typeof(v)

# ╔═╡ afd2dace-6dc7-4ae8-a1b8-5a923046cb21
md"""
El `1` en el tipo muestra que se trata de un *array* 1D. Accedemos a los elementos usando corchetes
"""

# ╔═╡ 4b69f45c-b8ee-4da7-9b73-0c937ba2914c
v[2]

# ╔═╡ 57faa819-727c-449d-aa89-025b2b49e50a
v[2] = 10

# ╔═╡ 98ab3250-af68-4c07-a5e4-9adedaeb7e59
md"""
Tenga en cuenta que Pluto no actualiza automáticamente las celdas cuando modifica elementos de un *array*, pero el valor cambia
"""

# ╔═╡ 3f6ae998-a6a9-47cb-9cc6-b775a8a6fe0c
md"""
Una buena manera de crear un `Vector` siguiendo un cierto patrón es usar una **comprensión de array**
"""

# ╔═╡ ca4ddeb9-fe7e-4a99-8128-aca078cd1668
v2 = [i^2 for i in 1:10]

# ╔═╡ 1e56b1b1-a6fa-4147-bc9f-f19b24970fe9
[i^2 for i in 1:10 if i > 5]

# ╔═╡ 0b144761-4a1f-490f-aa65-0b6a47b50e78
[i for i in 1:10 if isodd(i)]

# ╔═╡ 47252371-80d8-45e2-a7ce-14c7fadebdb7
vv = [
    1.0
    2.0
    30
]

# ╔═╡ 9f4d5f25-318e-4bd4-b937-6c542a8fa83c
md"""
## Matrices - *Array* 2D
"""

# ╔═╡ b10c0774-b777-4762-838c-0e70317ebfe7
md"""
También podemos hacer matrices pequeñas (*array* 2D) con corchetes
"""

# ╔═╡ 4a5ed822-5a4c-4115-b160-401853797b96
M = [1 2; 3 4]

# ╔═╡ fb1c5de5-5a5a-48be-bfa4-a11df3aee404
M2 = [
    1 2
    3 4
]

# ╔═╡ 5c087f35-d1d6-4b56-a714-a472c5e97460
typeof(M)

# ╔═╡ cb7551ae-ecfe-4001-8d1b-4acf5a05e59f
md"""
El `2` en el tipo muestra que se trata de un *array* 2D. Accedemos a los elementos usando corchetes
"""

# ╔═╡ 160004cd-7c10-435c-9d3e-3504e14b7f42
M[1, 2]

# ╔═╡ 5c4458b5-19b9-4ad4-9293-bdd6312db04e
M[3]

# ╔═╡ 245cec84-efc9-4881-9dcc-e2f156a1768c
M[:]

# ╔═╡ 34b64acd-e7c8-4033-b584-1a99d3ef6891
md"""
Sin embargo, esto no funcionará para matrices más grandes. Para eso podemos usar `zeros`
"""

# ╔═╡ d655eda1-bec2-424a-962e-e334fed0e73d
zeros(2, 3)

# ╔═╡ 418ce889-fcec-438c-b4dc-5738cdff8837
zeros(Int, 3, 4)

# ╔═╡ cc2da42b-1a73-4b50-91f5-61a2823f1544
zeros(Int, 3, 4, 5)

# ╔═╡ fb193693-865a-4031-8d2a-1427babb5692
md"""
Luego podemos completar los valores que queremos manipulando los elementos con un ciclo `for`
"""

# ╔═╡ 6b65e22b-f728-40cb-9844-2fbbe9f3ef75
md"""
Una buena alternativa para crear matrices siguiendo un cierto patrón es una *comprensión de matriz* con un bucle *doble* `for`
"""

# ╔═╡ 7d6eb550-ef6c-4da5-9303-52b1a59f71bc
[i + j for i in 1:5, j in 1:6]

# ╔═╡ 6ca6a14f-5fb8-4f98-bc08-004dc112cc0d
[i * j for i in 1:5, j in 5:10]

# ╔═╡ e5e7fe5e-7bbc-423b-b9a4-92d2ef683607
[i * j for i in 1:5 for j in 5:10]

# ╔═╡ c92afd8a-9396-4fb5-b8f0-bc98ae12d813
md"""
## Sistema de ecuaciones
"""

# ╔═╡ 738e3ac2-d033-4cdd-9e16-81ec3bb12e1d
A = [1 2; 3 4]

# ╔═╡ 0569d975-5217-4c90-8dab-15e6c54f5fb4
b = [5, 6]

# ╔═╡ e714094e-8d5c-4323-811d-130adf5ffbab
xx = A \ b

# ╔═╡ 1484c270-0d08-4356-8b71-4fff87b259be
inv(A) * b

# ╔═╡ fbe1c054-3087-4c1f-9339-540d1631545b
A * xx == b

# ╔═╡ c9b7a2b2-5e60-4d6d-9c0a-36dc7be59e82
A'

# ╔═╡ 6211a777-80ab-464e-b05c-b53d4e717d37
A^2

# ╔═╡ 483b2416-eed1-44f3-bec5-e1de01262b0b
md"""
## Punto Flotante
"""

# ╔═╡ f2a9c774-3652-4347-afe9-85ae202b8543
sin(2π / 3) == √3 / 2

# ╔═╡ 844252d4-f13d-457d-8687-72c0a203ea01
sin(2π / 3)

# ╔═╡ 916847e9-76dd-4e1e-b627-ee706cc2f4eb
√3 / 2

# ╔═╡ 6b4e4bc9-e118-4c26-b9a9-264c125d3953
sin(2π / 3) ≈ √3 / 2

# ╔═╡ 2334a88a-6d9c-4099-9181-826af42a8e02
eps(Float64)

# ╔═╡ c41b0783-ff37-47b5-85bb-3ed69aa488ac
md"""
## Tuplas
"""

# ╔═╡ 891d32df-b85f-448f-96e6-c89c16ac3329
t1 = ("hello", 1.2, :foo)

# ╔═╡ 20ceca4b-026c-408a-af11-50814db1291b
t2 = (word = "hello", num = 1.2, sym = :foo)

# ╔═╡ 99e8c835-f03a-4346-9131-8491b1710473
t2[3]

# ╔═╡ 746ec674-d8cb-41a6-98d1-37e474c980d5
t2.num

# ╔═╡ 16bfb39a-a163-455d-a588-2b59e408e561
md"""
## Funciones y parametros
"""

# ╔═╡ 1406c71d-2c9a-4ff7-b95d-3b390b47affc
function print_it(x, prefix = "value:")
    return println("$prefix $x")
end

# ╔═╡ 9610ef49-0023-40f5-a5d7-1d3722ed5c4f
print_it(1.234)

# ╔═╡ 3f42af6a-9112-4cc7-8a2a-c78ff3226e59
print_it(1.234, "valor de x =")

# ╔═╡ 8986ef60-9ff1-4ddd-9171-1b58e3da66ce
function mult(x; y = 2.0)
    return x * y
end

# ╔═╡ cdd9b77c-1d14-411b-94e2-7b24d9767056
mult(4.0)

# ╔═╡ 188437e1-6fc0-42de-9939-d9eb87ae3bef
mult(4.0; y = 5.0)

# ╔═╡ 0938af0c-b09e-47d2-bcf6-f404c4515646
md"""
## Funciones y Punteros
"""

# ╔═╡ 7b44b8e8-14d4-4b20-89fe-47c6300fff45
function mutability_example(a, b, c)
    a .+= 100
    b += 1
    c[] += 1
    return
end

# ╔═╡ be535097-1edf-4d3e-bc49-c662cfeef457
begin
    mutable_type = [10, 20, 30]
    immutable_type = 10
    reference_type = Ref{Int}(10)
    mutability_example(mutable_type, immutable_type, reference_type)
end

# ╔═╡ 91d2d9c3-c4db-4b55-b999-848bc96e167d
mutable_type

# ╔═╡ 34e2d939-46a3-43ff-9613-b9d9d4a5af4d
immutable_type

# ╔═╡ 713617be-62a7-46c9-9b8c-641659645a1c
reference_type

# ╔═╡ a91f55ee-7997-4aa6-99c7-d54c21dd1413
reference_type[]

# ╔═╡ Cell order:
# ╟─00afa180-ac4b-11ec-06c5-87c2e45a34bc
# ╟─d9f1d475-8e5c-4c27-8c19-26c3812ff99e
# ╟─00839514-e5dd-455b-aec1-487a2fbd77fd
# ╠═da2b00b0-a21e-4428-9f71-a35fb5ac3585
# ╟─9af9cf8c-2d84-4f3f-a466-3e290eaf25c3
# ╠═097b47e7-969f-4a45-998c-f47f0072d832
# ╟─c00f8154-e5b7-4e28-ace7-5d07fb552cea
# ╠═c4f41f7a-c053-4fee-8049-1983c7471a04
# ╠═d893a1ea-78b3-4349-b85d-fb44cd1401c6
# ╠═680f263d-8dbe-480b-9dc6-773128a37502
# ╠═ff2cc0cb-ce22-4e8f-8efa-cbec80e4d3af
# ╠═52889dc5-abe1-49b5-9803-7105c389d3b5
# ╠═0ae41766-2562-44e0-84f3-4af9acfaaf8e
# ╠═a5b9c354-a7c2-4e7d-8df2-7ed953cc0f95
# ╠═8c5ec749-932a-44a8-a53a-099f37fe53d7
# ╠═9bd51d8b-b894-4fac-b428-29d0015fb179
# ╠═a2e8d157-83f1-4da4-ab5f-e730f8d033f4
# ╠═dd358d52-6053-4d0f-aca9-ff0bcd7852dd
# ╠═71afab5f-2430-430c-8383-0c07154ec267
# ╠═f2934b8a-5baf-4e8c-bdd3-1db5b127205b
# ╟─de4b8c11-93bc-489c-ba97-2786b635007a
# ╟─f7f77c73-a9dc-4159-a34d-60bd99a46958
# ╠═33ccbc8b-4d7e-4dda-80f9-346ae75bb40d
# ╟─8b85f6e2-7fe3-430f-9e86-e6e6dc2439ad
# ╠═fddc6109-0ba3-419f-9bc1-e04d5de680b1
# ╠═1d3a8ca3-633c-40f7-9f00-eb4c104a3d55
# ╟─33847b9b-c2eb-4c8b-b356-767d0624c3e3
# ╠═aaf59954-4118-4ef3-ad18-d489e67922cc
# ╠═bdbc2778-4a27-4101-b16a-e756d9f440e0
# ╟─409a4115-6945-4098-9ea9-4fb32e6df8c8
# ╟─6c8326bd-3a49-4976-beab-c8eec9df028e
# ╠═96389d6e-c6ba-4362-a748-dabd77f87ff4
# ╟─43d4cee8-a06f-4537-91ea-08d1e56e1af0
# ╠═96ce4e55-aecf-4411-9481-bb0a0e08ee8d
# ╟─d2b7aca9-656e-46fd-84b0-66838f47208b
# ╠═e872f7cb-315a-44bf-968e-18e0215437ee
# ╠═99f471cf-38df-410c-9568-e7e71e0422f2
# ╠═e1f24e16-1a9b-431e-9b48-6bfcf23b80ea
# ╠═cc8b5e24-cfae-4cc6-8f22-1db7ac5a2976
# ╠═66f070df-42e7-45dc-85cb-8fd7a7f58f23
# ╟─cb9d71dd-0f64-499b-bc57-e0a5edf8b0fc
# ╟─73b989bd-9a56-4109-81ce-48f0b0568d88
# ╠═fa4aae9a-2170-4ceb-9df7-d1b8f1d3bb9e
# ╠═46d7a3a6-9fa1-4101-b95f-8cd1f3c71eb2
# ╟─09ad02f7-f451-406d-8390-6cbf6f0baa57
# ╠═5b6020f9-ae64-4848-a302-d6194de10366
# ╟─05a9d3dc-15d3-439d-8c40-d7470510dd18
# ╠═c4ee2829-f0db-4b92-a2ef-c609e455c5d9
# ╠═9fdea952-30f9-4b54-b9e5-82f59fb496c8
# ╠═d2cfe345-6f06-4629-91c5-f23ab9702eaf
# ╠═a2b957fc-a4eb-4924-9144-0ee2d41f8d00
# ╟─99bd23c8-1c17-4e0d-a8ed-497cc3772fef
# ╟─9d6772dd-2855-4ef5-becc-2740596e3e7f
# ╠═cbcce4f8-bc6a-40dd-845c-7c104a1b691e
# ╠═df58fe75-1840-48af-93ef-19711fe21402
# ╟─afd2dace-6dc7-4ae8-a1b8-5a923046cb21
# ╠═4b69f45c-b8ee-4da7-9b73-0c937ba2914c
# ╠═57faa819-727c-449d-aa89-025b2b49e50a
# ╟─98ab3250-af68-4c07-a5e4-9adedaeb7e59
# ╟─3f6ae998-a6a9-47cb-9cc6-b775a8a6fe0c
# ╠═ca4ddeb9-fe7e-4a99-8128-aca078cd1668
# ╠═1e56b1b1-a6fa-4147-bc9f-f19b24970fe9
# ╠═0b144761-4a1f-490f-aa65-0b6a47b50e78
# ╠═47252371-80d8-45e2-a7ce-14c7fadebdb7
# ╟─9f4d5f25-318e-4bd4-b937-6c542a8fa83c
# ╟─b10c0774-b777-4762-838c-0e70317ebfe7
# ╠═4a5ed822-5a4c-4115-b160-401853797b96
# ╠═fb1c5de5-5a5a-48be-bfa4-a11df3aee404
# ╠═5c087f35-d1d6-4b56-a714-a472c5e97460
# ╟─cb7551ae-ecfe-4001-8d1b-4acf5a05e59f
# ╠═160004cd-7c10-435c-9d3e-3504e14b7f42
# ╠═5c4458b5-19b9-4ad4-9293-bdd6312db04e
# ╠═245cec84-efc9-4881-9dcc-e2f156a1768c
# ╟─34b64acd-e7c8-4033-b584-1a99d3ef6891
# ╠═d655eda1-bec2-424a-962e-e334fed0e73d
# ╠═418ce889-fcec-438c-b4dc-5738cdff8837
# ╠═cc2da42b-1a73-4b50-91f5-61a2823f1544
# ╟─fb193693-865a-4031-8d2a-1427babb5692
# ╟─6b65e22b-f728-40cb-9844-2fbbe9f3ef75
# ╠═7d6eb550-ef6c-4da5-9303-52b1a59f71bc
# ╠═6ca6a14f-5fb8-4f98-bc08-004dc112cc0d
# ╠═e5e7fe5e-7bbc-423b-b9a4-92d2ef683607
# ╟─c92afd8a-9396-4fb5-b8f0-bc98ae12d813
# ╠═738e3ac2-d033-4cdd-9e16-81ec3bb12e1d
# ╠═0569d975-5217-4c90-8dab-15e6c54f5fb4
# ╠═e714094e-8d5c-4323-811d-130adf5ffbab
# ╠═1484c270-0d08-4356-8b71-4fff87b259be
# ╠═fbe1c054-3087-4c1f-9339-540d1631545b
# ╠═c9b7a2b2-5e60-4d6d-9c0a-36dc7be59e82
# ╠═6211a777-80ab-464e-b05c-b53d4e717d37
# ╟─483b2416-eed1-44f3-bec5-e1de01262b0b
# ╠═f2a9c774-3652-4347-afe9-85ae202b8543
# ╠═844252d4-f13d-457d-8687-72c0a203ea01
# ╠═916847e9-76dd-4e1e-b627-ee706cc2f4eb
# ╠═6b4e4bc9-e118-4c26-b9a9-264c125d3953
# ╠═2334a88a-6d9c-4099-9181-826af42a8e02
# ╟─c41b0783-ff37-47b5-85bb-3ed69aa488ac
# ╠═891d32df-b85f-448f-96e6-c89c16ac3329
# ╠═20ceca4b-026c-408a-af11-50814db1291b
# ╠═99e8c835-f03a-4346-9131-8491b1710473
# ╠═746ec674-d8cb-41a6-98d1-37e474c980d5
# ╟─16bfb39a-a163-455d-a588-2b59e408e561
# ╠═1406c71d-2c9a-4ff7-b95d-3b390b47affc
# ╠═9610ef49-0023-40f5-a5d7-1d3722ed5c4f
# ╠═3f42af6a-9112-4cc7-8a2a-c78ff3226e59
# ╠═8986ef60-9ff1-4ddd-9171-1b58e3da66ce
# ╠═cdd9b77c-1d14-411b-94e2-7b24d9767056
# ╠═188437e1-6fc0-42de-9939-d9eb87ae3bef
# ╟─0938af0c-b09e-47d2-bcf6-f404c4515646
# ╠═7b44b8e8-14d4-4b20-89fe-47c6300fff45
# ╠═be535097-1edf-4d3e-bc49-c662cfeef457
# ╠═91d2d9c3-c4db-4b55-b999-848bc96e167d
# ╠═34e2d939-46a3-43ff-9613-b9d9d4a5af4d
# ╠═713617be-62a7-46c9-9b8c-641659645a1c
# ╠═a91f55ee-7997-4aa6-99c7-d54c21dd1413
