param(
  [Parameter(Mandatory = $true)]
  [string]$InputFile,
  [string]$BaseUrl = "http://192.168.1.80:31789",
  [string]$EnvPath = ""
)

$ErrorActionPreference = "Stop"

function Get-EnvMap([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Env file not found: $Path"
  }

  $map = @{}
  Get-Content -LiteralPath $Path | ForEach-Object {
    if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
    if ($_ -match '^\s*([^=]+)=(.*)$') {
      $map[$matches[1].Trim()] = $matches[2]
    }
  }
  return $map
}

if (-not (Test-Path -LiteralPath $InputFile)) {
  throw "Workflow JSON not found: $InputFile"
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
if ([string]::IsNullOrWhiteSpace($EnvPath)) {
  $EnvPath = Join-Path $repoRoot ".env"
}

$envMap = Get-EnvMap -Path $EnvPath
$apiKey = $envMap["N8N_API_KEY"]
if ([string]::IsNullOrWhiteSpace($apiKey)) {
  throw "N8N_API_KEY is missing in $EnvPath"
}

$raw = Get-Content -LiteralPath $InputFile -Raw | ConvertFrom-Json
$payload = [ordered]@{
  name = $raw.name
  nodes = $raw.nodes
  connections = $raw.connections
  settings = $raw.settings
}

$headers = @{
  "X-N8N-API-KEY" = $apiKey
  "Content-Type" = "application/json"
}

$result = Invoke-RestMethod -Method Post -Uri "$BaseUrl/api/v1/workflows" -Headers $headers -Body ($payload | ConvertTo-Json -Depth 100)
Write-Host ("Created workflow: {0} ({1})" -f $result.name, $result.id)
