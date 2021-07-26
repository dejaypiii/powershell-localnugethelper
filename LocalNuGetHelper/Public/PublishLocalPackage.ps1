. $PSScriptRoot/../Private/PrepareLocalEnvironment.ps1
. $PSScriptRoot/../Private/ExtractCsprojMetaData.ps1
. $PSScriptRoot/../Private/CreatePackageToLocalFeed.ps1
. $PSScriptRoot/../Private/UpdateGlobalPackageCache.ps1

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
    PS Gallery page:  https://www.powershellgallery.com/packages/LocalNuGetHelper
#>
function Publish-LocalPackage {

    # FIXME should variables be scoped to their respective function?

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

    PrepareLocalEnvironment

    ($packageName, $packageVersion) = ExtractCsprojMetaData

    CreatePackageToLocalFeed

    UpdateGlobalPackageCache $packageName $packageVersion

    Write-Host "✓ Done" -ForegroundColor Green
    return
}