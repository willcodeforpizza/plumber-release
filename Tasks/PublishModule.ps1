<#
    .SYNOPSIS
    Publishes a module to PowerShell Gallery.

    .DESCRIPTION
    Builds a clean module folder and publishes it with Publish-PSResource.
    The API key is read from PSGALLERY_API_KEY.

    By default this task runs with -WhatIf. Set PSGALLERY_PUBLISH_CONFIRM to
    true to publish for real.

    .RUN
    ```powershell
    Invoke-Build -File ./Release.build.ps1 PublishModule
    ```
#>
if ($script:_loadedPlumberReleasePublishModule) { return }
$script:_loadedPlumberReleasePublishModule = $true

Add-BuildTask -Name PublishModule -Jobs BuildModule, {
    $config = $script:PlumberReleaseConfig
    $apiKey = $env:PSGALLERY_API_KEY
    $publishConfirmed = $env:PSGALLERY_PUBLISH_CONFIRM -eq 'true'

    if ($publishConfirmed -and -not $apiKey) {
        Write-Error 'Set PSGALLERY_API_KEY before running PublishModule.'
        return
    }

    if (-not (Get-Command Publish-PSResource -ErrorAction SilentlyContinue)) {
        Write-Error 'Publish-PSResource is required. Install Microsoft.PowerShell.PSResourceGet.'
        return
    }

    $publishSplat = @{
        Path       = $config.ModuleOutputRoot
        Repository = $config.Repository
        Verbose    = $true
        WhatIf     = -not $publishConfirmed
    }
    if ($apiKey) {
        $publishSplat.ApiKey = $apiKey
    }

    Publish-PSResource @publishSplat
}
