param(
  [string]$Message = "Update weekly BOOTH market data"
)

$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repo

git -c safe.directory="$repo" fetch origin main
git -c safe.directory="$repo" pull --rebase origin main
git -c safe.directory="$repo" add index.html booth-3d-dashboard.html booth-3d-data.json README.md .nojekyll

$changes = git -c safe.directory="$repo" status --short
if (-not $changes) {
  Write-Host "No dashboard changes to publish."
  exit 0
}

git -c safe.directory="$repo" commit -m $Message
git -c safe.directory="$repo" push origin main
Write-Host "Published BOOTH 3D dashboard to GitHub Pages."
