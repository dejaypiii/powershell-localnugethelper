$ErrorActionPreference = "Stop"

Write-Host "Preparing development environment." -ForegroundColor Cyan
if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Host "Installing module PSScriptAnalyzer." -ForegroundColor Cyan
    Install-Module PSScriptAnalyzer -Scope CurrentUser
}

Write-Host "✓ Done" -ForegroundColor Green
