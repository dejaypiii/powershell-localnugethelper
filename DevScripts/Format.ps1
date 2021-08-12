$ErrorActionPreference = "Stop"

$allScripts = Get-ChildItem -Path . -Include *.psm1, *.ps1 -Recurse | Select-Object FullName

Write-Host "Formatting all *.ps1 and *.psm1 scripts." -ForegroundColor Cyan

foreach ($script in $allScripts) {
    Write-Output "Formatting $($script.FullName)"
    $scriptDefinition = Get-Content -Path $script.FullName -Encoding UTF8BOM -Raw
    $formattedScript = Invoke-Formatter -ScriptDefinition $scriptDefinition -Settings CodeFormatting
    Set-Content -Path $script.FullName -Encoding UTF8BOM -NoNewline -Value $formattedScript
}

Write-Host "✓ Done" -ForegroundColor Green
