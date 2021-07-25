<#
    .SYNOPSIS
    Packs your C# project of the current directory, publish it to your local NuGet feed and updates your global-package cache.

    .PARAMETER LocalFeedName
    The name for your local NuGet feed (default = Local NuGet feed).

    .PARAMETER LocalFeedPath
    The path to your local NuGet directory (default = $HOME/localnugetfeed).

    .DESCRIPTION
    After applying changes to your .NET NuGet package using `Publish-LocalPackage` will let you consume these changes instantly in another project.

    Procedure:
    1. Creates a directory for the local NuGet path under <LocalFeedPath>.
    2. Adds the directory as a NuGet source with the name <LocalFeedName>.
    3. Packs the C# project of the current directory and puts the output into the local NuGet source.
    4. Purges local global-package cache of a maybe existing package version.
    5. Updates the global-package cache with the new package.

    .EXAMPLE
    Publish-LocalPackage
    ...
    ✓ Done

    .LINK
    PS Gallery page:  https://www.powershellgallery.com/packages/LocalNugetHelper
#>
function Publish-LocalPackage {
    # TODO restructure script

    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $LocalFeedName = "Local NuGet feed",

        [Parameter()]
        [String]
        $LocalFeedPath = $(Join-Path $HOME "localnugetfeed")
    )

    $dotnetVersion = dotnet --version
    if (($null -eq $dotnetVersion) -or ($LASTEXITCODE -ne 0)) {
        Write-Error "No dotnet CLI available." -ErrorAction Stop
    }

    if ($LocalFeedName -eq "") {
        Write-Error "No local feed name provided." -ErrorAction Stop
    }

    if ($LocalFeedPath -eq "") {
        Write-Error "No local feed path provided." -ErrorAction Stop
    }

    # TODO maybe save a config and update the module description

    Write-Verbose "Testing if the local feed path ${LocalFeedPath} exists."
    if (-not (Test-Path -Path $LocalFeedPath)) {
        Write-Host "Creating local feed path ${LocalFeedPath}." -ForegroundColor Cyan
        Write-Verbose "Calling 'mkdir ${LocalFeedPath}'"

        New-Item -Path $LocalFeedPath -ItemType "directory" -ErrorAction Stop
    }
    else {
        Write-Verbose "The local feed path already exists."
    }

    Write-Verbose "Testing if the local feed path ${LocalFeedPath} is added as a NuGet source."
    Write-Verbose "Calling 'dotnet nuget list source --format short | Select-string -Pattern ${localFeedPathRegex}'."
    $localFeedPathRegex = [regex]::escape($LocalFeedPath)
    $sourceExists = dotnet nuget list source --format short | Select-String -Pattern $localFeedPathRegex
    if ($null -eq $sourceExists) {
        Write-Host "Adding local NuGet feed source: ${LocalFeedName} - ${LocalFeedPath}" -ForegroundColor Cyan
        Write-Verbose "Calling 'dotnet nuget add source ${LocalFeedPath} -n ${LocalFeedName}'"
        dotnet nuget add source $LocalFeedPath -n $LocalFeedName
    }
    else {
        Write-Verbose "The NuGet source already exists."
    }

    Write-Verbose "Getting csproj of ${PSScriptRoot} and extract package name and version metadata."
    $csprojXml = [xml](Get-Content ./*.csproj -ErrorAction Stop)

    $packageVersion = $csprojXml.Project.PropertyGroup.Version | Where-Object { $_ -ne $null }
    $packageName = $csprojXml.Project.PropertyGroup.PackageIdentifier | Where-Object { $_ -ne $null }
    if ($null -eq $packageName) {
        $packageName = $csprojXml.Project.PropertyGroup.AssemblyName | Where-Object { $_ -ne $null }
    }
    if ($null -eq $packageName) {
        $packageName = Get-ChildItem *.csproj | ForEach-Object { $_.BaseName }
    }

    if ($null -eq $packageName -or $null -eq $packageVersion) {
        Write-Verbose "Packagename: ${packageName}"
        Write-Verbose "Packageversion: ${packageVersion}"
        Write-Error "Couldn't extract package name and version." -ErrorAction Stop
    }

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
    }

    Write-Host "Updating global-package cache." -ForegroundColor Cyan
    $localFeedPackagePath = Join-Path $LocalFeedPath "${packageName}.${packageVersion}.nupkg"
    Write-Verbose "Calling 'dotnet nuget push --source ${cachePath} ${localFeedPackagePath}"

    dotnet nuget push --source $cachePath $localFeedPackagePath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Couldn't update global-package cache directory." -ErrorAction Stop
    }

    Write-Host "✓ Done" -ForegroundColor Green
    return
}

Set-Alias plp Publish-LocalPackage
Export-ModuleMember -Function Publish-LocalPackage -Alias plp
