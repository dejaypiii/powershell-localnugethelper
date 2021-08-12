function UpdateGlobalPackageCache {
    param (
        [Parameter(Mandatory)]
        [String]
        $packageName,

        [Parameter(Mandatory)]
        [String]
        $packageVersion
    )

    Write-Verbose "Calling 'dotnet nuget locals global-packages -l' to get the cache directory."
    $localCache = dotnet nuget locals global-packages -l
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Couldn't determine global-package cache directory." -ErrorAction Stop
    }

    Write-Verbose $localCache
    $cacheName, $cachePath = $localCache -split ": ", 2
    $cachePackagePath = Join-Path -Path $cachePath $packageName $packageVersion

    Write-Verbose "Testing if the package version is cached in ${cachePackagePath}."
    if (Test-Path -Path $cachePackagePath) {
        Write-Host "Cleaning cache ${cacheName} ${cachePackagePath}." -ForegroundColor Cyan
        Remove-Item $cachePackagePath -Recurse -Force -ErrorAction Stop
    }
    else {
        Write-Verbose "Cache version doesn't exist."
        return
    }

    Write-Host "Updating global-package cache." -ForegroundColor Cyan
    $localFeedPackagePath = Join-Path $LocalFeedPath "${packageName}.${packageVersion}.nupkg"
    Write-Verbose "Calling 'dotnet nuget push --source ${cachePath} ${localFeedPackagePath}"

    dotnet nuget push --source $cachePath $localFeedPackagePath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Couldn't update global-package cache directory." -ErrorAction Stop
    }
}