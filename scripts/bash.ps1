param (
    [Parameter(Mandatory = $true)]
    [string]$stack,

    [Parameter(Mandatory = $true)]
    [string]$service
)

# Verifica se o Docker está disponível
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker não está instalado ou não está no PATH."
    exit 1
}

# Obtém o ID do container correspondente
$containerId = docker ps --filter "name=${stack}_${service}" --format "{{.ID}}" | Select-Object -First 1

if (-not $containerId) {
    Write-Host "❌ Container para serviço '$service' na stack '$stack' não encontrado."
    exit 1
}

# Tenta abrir bash, se falhar tenta sh
docker exec -it $containerId bash  
if ($LASTEXITCODE -ne 0) {
    # Se bash falhar, tenta sh
    docker exec -it $containerId sh 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Erro ao executar terminal no container."
    }
}

