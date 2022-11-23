### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 70964b64-bba1-11ec-2d9e-c9b4a3f47e09
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate(; temp = false)
    Pkg.add([
        Pkg.PackageSpec("DataFrames")
        Pkg.PackageSpec("JSON")
        Pkg.PackageSpec("XLSX")
    ])
    Pkg.status()
    md"""
    **NOTE:** remove this cell/code
    **NOTA:** remover esta celda/codigo
    """
end

# ╔═╡ d3ab311b-5035-4083-92b1-905cfd2b8280
using DataFrames

# ╔═╡ b5d830df-465d-4990-8dd4-4396e90d4106
using JSON

# ╔═╡ 9a0c4276-d2da-426a-8844-c14bb6df4dc1
using XLSX

# ╔═╡ 154fae4f-799c-4868-9d05-7a732d5e8e68
using Downloads

# ╔═╡ 730585c8-b346-4a98-8cfc-a1de7592e13e
using Dates

# ╔═╡ 70964b9e-bba1-11ec-3155-0b491028e886
XLSX.openxlsx("elmer-" * Dates.format(Dates.today(), "yyyy-mm-dd") * ".xlsx", mode = "w") do xf
    url1 = "http://www.elmercurio.com/inversiones/json/jsonTablaRankingFFMM.aspx"
    url2 = "http://www.elmercurio.com/inversiones/json/jsonTablaFull.aspx"
    r_ffmm = Downloads.download(url1)
    s_ffmm = read(r_ffmm, String)
    j_ffmm = JSON.parse(s_ffmm)
    df_ffmm = vcat(DataFrame.(j_ffmm["rows"])...)

    sxf = XLSX.addsheet!(xf, "ID-0")
    XLSX.writetable!(sxf, collect(DataFrames.eachcol(df_ffmm)), DataFrames.names(df_ffmm))

    df_ffmm_cols1 = [:Categ, :VarParIndUmes, :InvNetaUmes, :VarParIndU3meses, :InvNetaU3meses, :Patrimonio]
    df_ffmm1 = df_ffmm[!, df_ffmm_cols1]
    sxf = XLSX.addsheet!(xf, "ID-0 Par")
    XLSX.writetable!(sxf, collect(DataFrames.eachcol(df_ffmm1)), DataFrames.names(df_ffmm1))

    df_ffmm_cols2 = [:Categ, :RtbUltMes, :RtbUlt3Meses, :RtbUltAnio, :RtbUlt5anios]
    df_ffmm2 = df_ffmm[!, df_ffmm_cols2]
    sxf = XLSX.addsheet!(xf, "ID-0 Rt")
    XLSX.writetable!(sxf, collect(DataFrames.eachcol(df_ffmm2)), DataFrames.names(df_ffmm2))

    the_ffmm = DataFrame()
    for r in eachrow(df_ffmm)
        @show r[:Id], r[:Categ]
        r_ffmms = Downloads.download(url2 * "?idcategoria=" * r["Id"])
        s_ffmms = read(r_ffmms, String)
        j_ffmms = JSON.parse(s_ffmms)
        df = vcat(DataFrame.(j_ffmms["rows"])...)
        the_ffmm = vcat(the_ffmm, df)

        sxf = XLSX.addsheet!(xf, "ID-" * r[:Id])
        XLSX.writetable!(sxf, collect(DataFrames.eachcol(df)), DataFrames.names(df))
    end

    ffmmagps = unique(the_ffmm[!, :adm])
    for ffmmagp in ffmmagps
        @show ffmmagp
        df_rows = [v == ffmmagp for v in the_ffmm[!, :adm]]
        df2 = the_ffmm[df_rows, :]

        sxf = XLSX.addsheet!(xf, "AGP-" * ffmmagp)
        XLSX.writetable!(sxf, collect(DataFrames.eachcol(df2)), DataFrames.names(df2))
    end

    df_run = []
    # BANCHILE 
    push!(df_run, "8054-M", "8088-M") # Accionario Desarrollado - Emergente
    push!(df_run, "9041-M", "8525-M", "9042-M") # ESTRATEGICO
    push!(df_run, "8377-L", "9067-L", "9043-L", "8448-L", "8555-L") # PORTAFOLIO ACTIVO
    push!(df_run, "10059-DIGITAL", "10060-DIGITAL", "10058-DIGITAL") # DIGITAL
    # BCI
    push!(df_run, "8625-CLASI", "8710-CLASI") # Accionario Desarrollado - Emergente
    push!(df_run, "8813-CLASI") # Indices
    push!(df_run, "8976-INVER", "9061-INVER", "9063-INVER", "9062-INVER", "9060-INVER") # CARTERA PATRIMONIAL
    push!(df_run, "8731-CLASI", "9228-CLASI", "8638-CLASI", "8639-CLASI", "8640-CLASI") # CARTERA DINAMICA
    # FINTUAL
    push!(df_run, "9568-A", "9569-A", "9570-A") # FINTUAL
    push!(df_run, "9730-A") # FINTUAL
    # ITAU
    push!(df_run, "9922-F1", "9931-F1") # Accionario Desarrollado - Emergente
    push!(df_run, "8994-F1", "8992-F1", "8993-F1", "8971-F1") # GESTIONADO
    push!(df_run, "10020-SIMPLE", "10021-SIMPLE", "10063-SIMPLE", "10064-SIMPLE") # CARTERA

    df_cols = [Symbol("Rentb1 mes"), :Rentb3m, :RentbY, :Rentb12m]
    push!(df_cols, :FondoFull, :adm, :Run, :TAC, :Fondo)
    push!(df_cols, :invNet1m, :invNet1y, :varpar1m, :varpar1Y, :patrim, :par)

    df_rows = [v in df_run for v in the_ffmm[!, :FondoFull]]
    df2 = the_ffmm[df_rows, df_cols]

    sxf = XLSX.addsheet!(xf, "FFMM - RL")
    return XLSX.writetable!(sxf, collect(DataFrames.eachcol(df2)), DataFrames.names(df2))
end

# ╔═╡ 70964bd0-bba1-11ec-2fd4-bfc385b90f52

# ╔═╡ Cell order:
# ╟─70964b64-bba1-11ec-2d9e-c9b4a3f47e09
# ╠═d3ab311b-5035-4083-92b1-905cfd2b8280
# ╠═b5d830df-465d-4990-8dd4-4396e90d4106
# ╠═9a0c4276-d2da-426a-8844-c14bb6df4dc1
# ╠═154fae4f-799c-4868-9d05-7a732d5e8e68
# ╠═730585c8-b346-4a98-8cfc-a1de7592e13e
# ╠═70964b9e-bba1-11ec-3155-0b491028e886
# ╠═70964bd0-bba1-11ec-2fd4-bfc385b90f52
