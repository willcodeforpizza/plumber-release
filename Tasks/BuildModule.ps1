<#
    .SYNOPSIS
    Builds a publishable module folder.

    .DESCRIPTION
    Creates a clean module folder using the configured module build item list.
    Missing items are skipped; Test-ModuleManifest is the strict gate.

    .RUN
    ```powershell
    Invoke-Plumber -Task BuildModule
    ```
#>
if ($script:_loadedPlumberReleaseBuildModule) { return }
$script:_loadedPlumberReleaseBuildModule = $true

Add-BuildTask -Name BuildModule -Jobs {
    $config = $script:PlumberReleaseConfig

    if (Test-Path $config.ModuleOutputRoot) {
        Remove-Item $config.ModuleOutputRoot -Recurse -Force
    }
    New-Item -Path $config.ModuleOutputRoot -ItemType Directory -Force | Out-Null

    foreach ($item in $config.ModuleBuildItems) {
        $sourcePattern = Join-Path $config.ModuleRoot $item
        $sources = Resolve-Path -Path $sourcePattern -ErrorAction SilentlyContinue
        if (-not $sources) {
            Write-Verbose "Skipping missing item: $item"
            continue
        }

        foreach ($source in $sources) {
            $sourceItem = Get-Item -LiteralPath $source.ProviderPath
            $relativePath = [System.IO.Path]::GetRelativePath($config.ModuleRoot, $sourceItem.FullName)
            $destination = Join-Path $config.ModuleOutputRoot $relativePath

            if ($sourceItem.PSIsContainer) {
                New-Item -Path (Split-Path $destination -Parent) -ItemType Directory -Force | Out-Null
                Copy-Item -LiteralPath $sourceItem.FullName -Destination $destination -Recurse -Force
                continue
            }

            New-Item -Path (Split-Path $destination -Parent) -ItemType Directory -Force | Out-Null
            Copy-Item -LiteralPath $sourceItem.FullName -Destination $destination -Force
        }
    }

    $manifestPath = Join-Path $config.ModuleOutputRoot "$($config.ModuleName).psd1"
    Test-ModuleManifest -Path $manifestPath | Out-Null
    Import-Module $manifestPath -Force -PassThru | Out-Null
    Write-Build Green "Built publish folder: $($config.ModuleOutputRoot)"
}
