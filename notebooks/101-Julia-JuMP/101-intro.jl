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

# ╔═╡ 420193a5-e8cb-4c69-a164-9182133ca847
md"""
## Usar Julia + Jupyter

### Paso 1: Instalar Jupyter
A continuación instalaremos la [notebook Jupyter](https://jupyter.org/) que usaremos durante el curso. Jupyter es un entorno de programación para Julia, Python, R y otros lenguajes.

Abra **Julia REPL**. Esta es la interfaz de línea de comandos de Julia, similar a la captura de pantalla anterior. La sigla REPL significa Read-Eval-Print-Loop, ciclo Lectura-Evaluación-Impresión.

Aquí escribe los *comandos de Julia*, y cuando presionamos ENTER, se ejecuta y ve el resultado.

Para instalar *Jupyter*, queremos ejecutar un *comando de administrador de paquetes/bibliotecas*. Para cambiar del *modo Julia* al *modo Pkg*, escriba `]` (corchete de cierre) en el indicador `julia>:`

```julia
julia> ]
(@v1.99) pkg>
```
La línea se vuelve azul y el aviso cambia a `pkg>`, indicándole que ahora está en *modo administrador de paquetes*. Este modo le permite realizar operaciones en **paquetes/bibliotecas**.

Para instalar Jupyter, ejecute el siguiente comando (distingue entre mayúsculas y minúsculas) para agregar (instalar) el paquete a su sistema descargándolo desde Internet. **Solo debería necesitar hacer esto una vez que instale Julia**

```julia
(@v1.99) pkg> add IJulia
```
Nota: Esto puede tomar un par de minutos.
Ahora puede cerrar la terminal.

### Paso 2: Iniciar Jupyter
Inicie Julia REPL, como lo hizo durante la instalación. En el REPL, escriba:

```julia
julia> import IJulia
julia> IJulia.installkernel("Julia")
julia> IJulia.jupyterlab()
```

Se nos abrirá automaticamente Jupyter en nuestro navegador predeterminado.
"""

# ╔═╡ Cell order:
# ╟─47e373da-ac3c-11ec-01f3-4d2837d60a99
# ╟─683b836f-45b5-4b6c-a820-890bf0ebfb9e
# ╟─420193a5-e8cb-4c69-a164-9182133ca847
