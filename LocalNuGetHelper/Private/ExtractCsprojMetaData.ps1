function ExtractCsprojMetaData {
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

    return ($packageName, $packageVersion)
}