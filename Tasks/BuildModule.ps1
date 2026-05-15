<#
    .SYNOPSIS
    Builds a publishable module folder.

    .DESCRIPTION
    Creates a clean module folder using the configured module build item list.
    Missing items are skipped; Test-ModuleManifest is the strict gate.

    .RUN
    ```powershell
    Invoke-Build -File ./Release.build.ps1 BuildModule
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
        $source = Join-Path $config.ModuleRoot $item
        if (-not (Test-Path $source)) {
            Write-Verbose "Skipping missing item: $item"
            continue
        }

        Copy-Item -Path $source -Destination $config.ModuleOutputRoot -Recurse -Force
    }

    $manifestPath = Join-Path $config.ModuleOutputRoot "$($config.ModuleName).psd1"
    Test-ModuleManifest -Path $manifestPath | Out-Null
    Import-Module $manifestPath -Force -PassThru | Out-Null
    Write-Build Green "Built publish folder: $($config.ModuleOutputRoot)"
}
