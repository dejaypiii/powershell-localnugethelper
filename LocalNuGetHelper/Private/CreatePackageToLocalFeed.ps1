function CreatePackageToLocalFeed {
    Write-Host "Packing ${packageName} ${packageVersion} to ${LocalFeedPath}." -ForegroundColor Cyan
    Write-Verbose "Calling 'dotnet build'."
    dotnet build
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed" -ErrorAction Stop
    }

    Write-Verbose "Calling 'dotnet pack -o ${LocalFeedPath}' --no-build."
    dotnet pack -o $LocalFeedPath --no-build
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Packing failed" -ErrorAction Stop
    }
}