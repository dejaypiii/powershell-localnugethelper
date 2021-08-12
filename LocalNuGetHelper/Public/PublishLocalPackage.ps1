. $PSScriptRoot/../Private/PrepareLocalEnvironment.ps1
. $PSScriptRoot/../Private/ExtractCsprojMetaData.ps1
. $PSScriptRoot/../Private/CreatePackageToLocalFeed.ps1
. $PSScriptRoot/../Private/UpdateGlobalPackageCache.ps1
. $PSScriptRoot/../Private/RunPublishOnChanges.ps1

<#
    .SYNOPSIS
    Packs your C# project, publish it to your local NuGet feed and updates your global-package cache.

    .Parameter PackageProjectPath
    The path to your package project (default = current location).

    .PARAMETER LocalFeedName
    The name for your local NuGet feed (default = Local NuGet feed).

    .PARAMETER LocalFeedPath
    The path to your local NuGet directory (default = $HOME/localnugetfeed).

    .PARAMETER Watch
    Publish your package continuously on each change.

    .DESCRIPTION
    After applying changes to your .NET NuGet package using `Publish-LocalPackage` will let you consume these changes instantly in another project.

    Procedure:
    1. Creates a directory for the local NuGet path under <LocalFeedPath>.
    2. Adds the directory as a NuGet source with the name <LocalFeedName>.
    3. Packs the C# project of the <PackageProjectDirectory> directory and puts the output into the local NuGet source.
    4. Purges local global-package cache of a maybe existing package version.
    5. Updates the global-package cache with the new package.

    .EXAMPLE
    Publish-LocalPackage

    .EXAMPLE
    Publish-LocalPackage -PackageProjectPath C:\dev\my-package-project

    .EXAMPLE
    Publish-LocalPackage -LocalFeedName "Fancy feed name" -LocalFeedPath C:\somedir\my-local-nuget-feed#

    .EXAMPLE
    Publish-LocalPackage -Watch

    .LINK
    PS Gallery page:  https://www.powershellgallery.com/packages/LocalNuGetHelper
#>
function Publish-LocalPackage {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $PackageProjectPath = $(Get-Location),

        [Parameter()]
        [String]
        $LocalFeedName = "Local NuGet feed",

        [Parameter()]
        [String]
        $LocalFeedPath = $(Join-Path $HOME "localnugetfeed"),

        [Parameter()]
        [switch]
        $Watch = $false
    )

    $dotnetVersion = dotnet --version
    if (($null -eq $dotnetVersion) -or ($LASTEXITCODE -ne 0)) {
        Write-Error "No dotnet CLI available." -ErrorAction Stop
    }

    if ($PackageProjectPath -eq "") {
        Write-Error "No package project path provided." -ErrorAction Stop
    }

    if ($LocalFeedName -eq "") {
        Write-Error "No local feed name provided." -ErrorAction Stop
    }

    if ($LocalFeedPath -eq "") {
        Write-Error "No local feed path provided." -ErrorAction Stop
    }

    PrepareLocalEnvironment

    ($packageName, $packageVersion) = ExtractCsprojMetaData

    CreatePackageToLocalFeed

    UpdateGlobalPackageCache $packageName $packageVersion

    if ($Watch) {
        RunPublishOnChanges
    }

    Write-Host "✓ Done" -ForegroundColor Green
    return
}