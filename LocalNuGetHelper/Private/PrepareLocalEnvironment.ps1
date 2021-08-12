function PrepareLocalEnvironment {
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
}