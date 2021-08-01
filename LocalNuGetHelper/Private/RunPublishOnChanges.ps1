function RunPublishOnChanges {
    $currentLocation = Get-Location
    Write-Verbose "Initialize file system watcher for $currentLocation."
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $currentLocation
    $watcher.Filter = "*.*"
    $watcher.NotifyFilter = [IO.NotifyFilters]::FileName, [IO.NotifyFilters]::LastWrite
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true

    $binFolder = Join-Path "bin" ""
    $binFolderRegex = [regex]::escape($binFolder)
    $objFolder = Join-Path "obj" ""
    $objFolderRegex = [regex]::escape($objFolder)
    $excludeFilterRegex = "^$binFolderRegex*|^$objFolderRegex*"
    Write-Verbose "Exclude filter: $excludeFilterRegex"

    $action = {
        . $PSScriptRoot/../Private/ExtractCsprojMetaData.ps1
        . $PSScriptRoot/../Private/CreatePackageToLocalFeed.ps1
        . $PSScriptRoot/../Private/UpdateGlobalPackageCache.ps1

        $details = $event.SourceEventArgs
        $name = $details.Name
        $timestamp = $event.TimeGenerated

        $localFeedPath = $event.MessageData.LocalFeedPath
        $verbosePreferenceBackup = $VerbosePreference
        $VerbosePreference = $event.MessageData.VerboseSetting

        if ($name -match $event.MessageData.ExcludeFilterRegex) {
            Write-Host ""
            Write-Verbose "Ignoring change of $name."
            return
        }

        Clear-Host
        Write-Host "[$timestamp] $name changed." -ForegroundColor Cyan
        try {
            (($packageName, $packageVersion) = ExtractCsprojMetaData)
            CreatePackageToLocalFeed
            UpdateGlobalPackageCache $packageName $packageVersion
            Write-Host "✓ Done" -ForegroundColor Cyan
        }
        catch {
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
        finally {
            $VerbosePreference = $verbosePreferenceBackup
            Clear-Variable $localFeedPath
        }
    }

    Write-Verbose "Register event handler."
    $eventData = New-Object psobject -Property @{
        LocalFeedName      = $localFeedName;
        LocalFeedPath      = $localFeedPath;
        ExcludeFilterRegex = $excludeFilterRegex;
        VerboseSetting     = $VerbosePreference
    }

    $handlers = . {
        Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action -MessageData $eventData -SourceIdentifier FSCreate
        Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $action -MessageData $eventData -SourceIdentifier FSDelete
        Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action -MessageData $eventData -SourceIdentifier FSChange
        Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $action -MessageData $eventData -SourceIdentifier FSRename
    }

    try {
        $i = 0
        do {
            Wait-Event -Timeout 1
            Write-Progress -Activity " " -Status "Waiting for changes..." -PercentComplete $i

            if ($i -lt 100) {
                $i = $i + 1
            }
            else {
                $i = 0
            }

        } while ($true)
    }
    finally {
        Write-Host ""
        Write-Verbose "Unregister event handler."
        Unregister-Event -SourceIdentifier FSCreate
        Unregister-Event -SourceIdentifier FSDelete
        Unregister-Event -SourceIdentifier FSChange
        Unregister-Event -SourceIdentifier FSRename

        Write-Verbose "Remove background job."
        $handlers | Remove-Job

        Write-Verbose "Dispose file system watcher."
        $watcher.EnableRaisingEvents = $false
        $watcher.Dispose()
    }
}