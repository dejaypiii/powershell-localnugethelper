$ErrorActionPreference = "Stop"

Write-Host "Linting all *.ps1 and *.psm1 scripts." -ForegroundColor Cyan
Invoke-ScriptAnalyzer -Path . -Recurse -ExcludeRule PSAvoidUsingWriteHost -Fix

Write-Host "✓ Done" -ForegroundColor Green
