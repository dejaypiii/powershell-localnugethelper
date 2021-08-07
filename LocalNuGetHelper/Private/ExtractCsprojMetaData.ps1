function ExtractCsprojMetaData {
    Write-Verbose "Getting csproj of ${PSScriptRoot} and extract package name and version metadata."
    $csprojPath = Join-Path $PackageProjectPath "*.csproj"
    $csprojXml = [xml](Get-Content $csprojPath -ErrorAction Stop)

    $packageVersion = $csprojXml.Project.PropertyGroup.Version | Where-Object { $_ -ne $null }
    $packageName = $csprojXml.Project.PropertyGroup.PackageIdentifier | Where-Object { $_ -ne $null }
    if ($null -eq $packageName) {
        $packageName = $csprojXml.Project.PropertyGroup.AssemblyName | Where-Object { $_ -ne $null }
    }
    if ($null -eq $packageName) {
        $packageName = Get-ChildItem $csprojPath | ForEach-Object { $_.BaseName }
    }

    if ($null -eq $packageName -or $null -eq $packageVersion) {
        Write-Verbose "Package name: ${packageName}"
        Write-Verbose "Package version: ${packageVersion}"
        Write-Error "Couldn't extract package name and version." -ErrorAction Stop
    }

    return ($packageName, $packageVersion)
}