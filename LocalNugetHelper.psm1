<#
    .Synopsis
    Packs a C# project and publish it to a local nuget feed.

    .Description
    1. Creates a folder for the local nuget path under C:\p\localnugetfeed
    2. Adds the folder as a nuget source
    3. Packs the C# project of the current folder and puts the output into the local nuget source
    4. Purges local global-package cache of the created package version
    5. Updates the global-package cache with the new package
#>
function Publish-LocalPackage {
    $localFeedName = "Local nuget feed"
    $localFeedPath = "C:\p\localnugetfeed"

    # Create local feed folder
    if (-not (Test-Path -Path $localFeedPath))
    {
        Write-Output "Creating local feed path ${localFeedPath}"
        mkdir $localFeedPath
    }

    # Add local nuget source
    $sourceExists = dotnet nuget list source --format short | Select-string -Pattern "C:\\p\\localnugetfeed"
    if ($null -eq $sourceExists)
    {
        Write-Output "Adding local nuget feed source: ${localFeedName} - ${localFeedPath}"
        dotnet nuget add source $localFeedPath -n $localFeedName
    }

    # Get package name and version
    try
    {
        $csprojXml = [xml](Get-Content ./*.csproj -ErrorAction Stop)
    }
    catch
    {
        Write-Error "Couldn't load the C# project of the current folder"
        return
    }

    $packageVersion = $csprojXml.Project.PropertyGroup.Version | Where-Object {$_ -ne $null}
    $packageName = $csprojXml.Project.PropertyGroup.PackageIdentifier | Where-Object {$_ -ne $null}
    if ($null -eq $packageName)
    {
        $packageName = $csprojXml.Project.PropertyGroup.AssemblyName | Where-Object {$_ -ne $null}
    }
    if ($null -eq $packageName)
    {
        $packageName = Get-ChildItem *.csproj | ForEach-Object {$_.BaseName}
    }

    # Create package at local feed
    Write-Output "Packing ${packageName} ${packageVersion} to ${localFeedPath}"
    dotnet build
    dotnet pack -o $localFeedPath

    # Clear cached versions of the package
    $localCache = dotnet nuget locals global-packages -l
    $cacheName, $cachePath = $localCache -split ": ",2
    $cachePackagePath = "${cachePath}${packageName}\${packageVersion}"
    if (Test-Path -Path $cachePackagePath)
    {
        Write-Output "Cleaning cache ${cacheName} ${cachePackagePath}"
        Remove-Item $cachePackagePath -Recurse
    }

    # Update package cache
    dotnet nuget push --source $cachePath ${localFeedPath}\${packageName}.${packageVersion}.nupkg

    Write-Output "Done! Happy testing!"
    return
}

Set-Alias hoh-plp Publish-LocalPackage
Export-ModuleMember -Function Publish-LocalPackage -Alias hoh-plp
