param(
  [string]$Message = "Update weekly BOOTH market data"
)

$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repo

function Invoke-Git {
  git -c safe.directory="$repo" @args
  if ($LASTEXITCODE -ne 0) {
    throw "Git command failed: git $($args -join ' ')"
  }
}

Invoke-Git add index.html booth-3d-dashboard.html booth-3d-data.json README.md .nojekyll publish-to-github.ps1

$changes = Invoke-Git status --short
if ($changes) {
  Invoke-Git commit -m $Message
}

Invoke-Git fetch origin main
Invoke-Git pull --rebase origin main

$ahead = Invoke-Git rev-list --count origin/main..HEAD
if ([int]$ahead -eq 0) {
  Write-Host "No dashboard changes to publish."
  exit 0
}

Invoke-Git push origin main
Write-Host "Published BOOTH 3D dashboard to GitHub Pages."
