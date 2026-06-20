# juntaPDF
# CALL: Invoke-WebRequest -Uri "https://raw.githubusercontent.com/santiago-gitcode/awscode/refs/heads/main/pshell/juntaPDF.ps1" -OutFile "juntarPDF.ps1"; powershell -ExecutionPolicy Bypass -File ".\juntarPDF.ps1"
# CALL LOCAL: powershell -ExecutionPolicy Bypass -File .\juntaPDF.ps1

#
# Instalação do Módulo PSWritePDF. Essa ação de instalação somente é realizada uma vez.
# Garante que o PowerShell usará conexões seguras para baixar o módulo
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Instala o módulo oficial de manipulação de PDF
#Install-Module -Name PSWritePDF -Scope CurrentUser -Force -AllowClobber

# --- FINAL DA INSTALAÇÃO DO PSWritePDF.


# --- Script de Junção dos PDFs ---
# $PSScriptRoot pega automaticamente a pasta onde o arquivo 'juntaPDF.ps1' está salvo

# Define a pasta /pdfs dentro da pasta do script
$pastaPDFs = Join-Path -Path $PSScriptRoot -ChildPath "pdfs"

# Define o arquivo final na raiz da pasta do script
$arquivoFinal = Join-Path -Path $PSScriptRoot -ChildPath "pdf_unificado.pdf"
# -----------------------------------------------------

# 1. Busca os PDFs na subpasta e os ordena pela data de download/modificação
$arquivos = Get-ChildItem -Path $pastaPDFs -Filter "*.pdf" | Sort-Object LastWriteTime | Select-Object -ExpandProperty FullName

# Validação: Verifica se a pasta existe e se contém arquivos
if (-not (Test-Path -Path $pastaPDFs)) {
    Write-Host "[Erro] A pasta '$pastaPDFs' não foi encontrada." -ForegroundColor Red
    Exit
}

if ($arquivos.Count -eq 0) {
    Write-Host "[Aviso] Nenhum arquivo PDF encontrado em: $pastaPDFs" -ForegroundColor Yellow
    Exit
}

# Exibe na tela a ordem exata da consolidação para conferência
Write-Host "Unificando os arquivos na seguinte ordem cronologica:" -ForegroundColor Yellow
$arquivos | ForEach-Object { Write-Host " -> $_" }

# 2. Junta todos os arquivos da lista no PDF final
Merge-PDF -InputFile $arquivos -OutputFile $arquivoFinal

Write-Host "`n[Sucesso] Todos os PDFs foram juntados em: $arquivoFinal" -ForegroundColor Green
