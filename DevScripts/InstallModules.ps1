$ErrorActionPreference = "Stop"

Write-Host "Preparing development environment." -ForegroundColor Cyan

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Host "Installing module PSScriptAnalyzer." -ForegroundColor Cyan
    Install-Module PSScriptAnalyzer -Scope CurrentUser
}

if (-not (Get-Module -ListAvailable -Name Pester)) {
    Write-Host "Installing module Pester." -ForegroundColor Cyan
    Install-Module Pester -Scope CurrentUser
}

Write-Host "✓ Done" -ForegroundColor Green
