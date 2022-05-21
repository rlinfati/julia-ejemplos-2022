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

# ╔═╡ 683b836f-45b5-4b6c-a820-890bf0ebfb9e
md"""
# Bienvenidos a Julia

## Acceso a mybinder
- [Julia + Pluto](https://mybinder.org/v2/gh/fonsp/pluto-on-binder/HEAD?urlpath=pluto)
- [Julia + Jupyter](https://mybinder.org/v2/gh/rlinfati/rhel8ubi-julia/HEAD)

## Material Online
- [Videos de Julia](https://www.youtube.com/c/TheJuliaLanguage)
- [Introduccion a Julia](https://introajulia.org/)
- [MATLAB vs Python vs Julia](https://cheatsheets.quantecon.org/)
- [Cheat-Sheet](https://juliadocs.github.io/Julia-Cheat-Sheet/)
- [Computational Thinking](https://computationalthinking.mit.edu/Spring21/)

## Instalacion de Julia en computador

### Paso 1: Instalar Julia
Ir a [Descargar Julia](https://julialang.org/downloads) y descargue la versión estable actual, Julia 1.7, para su sistema operativo (Windows, macOS, Linux, etc.)

### Paso 2: Ejecutar Julia
Después de la instalación, asegúrese de que puede ejecutar Julia. En algunos sistemas, esto significa buscar el programa "Julia" instalado en su computadora; en otros, significa ejecutar el comando julia en una terminal. Asegúrate de que puedes ejecutar: `1 + 1;`

![x](https://user-images.githubusercontent.com/6933510/91439734-c573c780-e86d-11ea-8169-0c97a7013e8d.png)

**¡Asegúrate de poder ejecutar Julia y calcular 1+1 antes de continuar!**
"""

# ╔═╡ c37e02d2-1645-4f4b-8fed-3ff98005d320
md"""
## Usar Julia + Pluto

### Paso 1: Instalar Pluto
A continuación instalaremos la [notebook Pluto](https://github.com/fonsp/Pluto.jl#readme) que usaremos durante el curso. Pluto es un entorno de programación de Julia diseñado para la interactividad y experimentos rápidos.

Abra **Julia REPL**. Esta es la interfaz de línea de comandos de Julia, similar a la captura de pantalla anterior. La sigla REPL significa Read-Eval-Print-Loop, ciclo Lectura-Evaluación-Impresión,

Aquí escribe los *comandos de Julia*, y cuando presionamos ENTER, se ejecuta y ve el resultado.

Para instalar *Pluto*, queremos ejecutar un *comando de administrador de paquetes/bibliotecas*. Para cambiar del *modo Julia* al *modo Pkg*, escriba `]` (corchete de cierre) en el indicador `julia>:`

```julia
julia> ]
(@v1.99) pkg>
```

La línea se vuelve azul y el aviso cambia a `pkg>`, indicándole que ahora está en *modo administrador de paquetes*. Este modo le permite realizar operaciones en **paquetes/bibliotecas**.

Para instalar Pluto, ejecute el siguiente comando (distingue entre mayúsculas y minúsculas) para agregar (instalar) el paquete a su sistema descargándolo desde Internet. **Solo debería necesitar hacer esto una vez que instale Julia**

```julia
(@v1.99) pkg> add Pluto
```
Esto puede tomar un par de minutos, ¡así que puedes ir a buscar una taza de té!

![x](https://user-images.githubusercontent.com/6933510/91440380-ceb16400-e86e-11ea-9352-d164911774cf.png)

Ahora puede cerrar la terminal.

### Paso 2: Iniciar Pluto
Inicie Julia REPL, como lo hizo durante la instalación. En el REPL, escriba:

```julia
julia> import Pluto
julia> Pluto.run()
```

![x](https://user-images.githubusercontent.com/6933510/91441094-eb01d080-e86f-11ea-856f-e667fdd9b85c.png)

La terminal nos dice que vayamos a http://localhost:1234/ (o una URL similar). Abramos Firefox o Chrome y escribamos eso en la barra de direcciones.

![x](https://user-images.githubusercontent.com/6933510/91441391-6a8f9f80-e870-11ea-94d0-4ef91b4e2242.png)

### Paso 3a: abrir un notebook desde la web
Este es el menú principal: aquí puede crear nuevos notebook o abrir los existentes. Para comenzar desde un *notebook Pluto* de ejemplo desde a web, puede *copiar y pegar la URL en el cuadro azul y presionar ENTRAR*.

**Lo primero que querremos hacer es guardar el notebook en algún lugar de nuestro propio computador, ver más abajo.**

### Paso 3b: abrir un notebook desde el computador
Cuando inicie Pluto, sus notebook recientes aparecerán en el menú principal. Puede hacer clic en ellos para continuar donde lo dejó.

Si desea ejecutar un notebook que no ha abierto antes, debe ingresar su ruta completa en el cuadro azul en el menú principal. Más información sobre cómo encontrar rutas completas en el paso 6.

### Paso 4: Guardar un notebook
Primero necesitamos una carpeta para guardar nuestro notebook. Abra su explorador de archivos y cree uno.

A continuación, necesitamos saber la ruta absoluta de esa carpeta.
Por ejemplo:

- `C:\\Users\\rlinfati\\tareas\\julia\\` en Windows
- `/Users/rlinfati/tareas/julia/` en MacOS
- `/home/rlinfati/tareas/julia/` en Linux

Ahora que conocemos la ruta absoluta, vuelve a tu cuaderno de Pluto y, en la parte superior de la página, haz clic en "Save notebook...".

![x](https://user-images.githubusercontent.com/6933510/91444741-77fb5880-e875-11ea-8f6b-02c1c319e7f3.png)

**Aquí es donde escribe la nueva ruta + nombre de archivo para su cuaderno:**

![x](https://user-images.githubusercontent.com/6933510/91444565-366aad80-e875-11ea-8ed6-1265ded78f11.png)

Haz clic en *Choose*.
"""

# ╔═╡ 78acc0ca-7d07-42b0-a090-bfd59dbdfbe3
md"""
## Video de la instalación de Julia y Pluto
"""

# ╔═╡ 47e45a2a-ac3c-11ec-0cca-c34a788962db
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/OOjKEgbt8AI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ Cell order:
# ╟─47e373da-ac3c-11ec-01f3-4d2837d60a99
# ╟─683b836f-45b5-4b6c-a820-890bf0ebfb9e
# ╟─c37e02d2-1645-4f4b-8fed-3ff98005d320
# ╟─78acc0ca-7d07-42b0-a090-bfd59dbdfbe3
# ╟─47e45a2a-ac3c-11ec-0cca-c34a788962db
