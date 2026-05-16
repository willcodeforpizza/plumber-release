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
    Invoke-Plumber -Task PublishModule
    ```
#>
if ($script:_loadedPlumberReleasePublishModule) { return }
$script:_loadedPlumberReleasePublishModule = $true

Add-BuildTask -Name PublishModule -Jobs BuildModule, {
    $config = $script:PlumberReleaseConfig
    if (-not $script:PlumberReleaseState.ShouldRelease) {
        Write-Build Yellow 'Skipping PublishModule because this version is already released.'
        return
    }
    if ('PSGallery' -notin $config.ReleaseTargets) {
        Write-Build Yellow 'Skipping PublishModule because PSGallery is not a release target.'
        return
    }

    $apiKey = $env:PSGALLERY_API_KEY
    $publishConfirmed = $env:PSGALLERY_PUBLISH_CONFIRM -eq 'true'

    if ($publishConfirmed -and -not $apiKey) {
        Write-Error 'Set PSGALLERY_API_KEY before running PublishModule.'
        return
    }

    Import-PlumberReleasePSResourceGet

    $repositoryStore = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'PSResourceGet'
    New-Item -Path $repositoryStore -ItemType Directory -Force | Out-Null
    $repository = Get-PSResourceRepository -Name PSGallery -ErrorAction SilentlyContinue
    if (-not $repository) {
        Register-PSResourceRepository -PSGallery
    }

    $publishSplat = @{
        Path       = $config.ModuleOutputRoot
        Repository = 'PSGallery'
        Verbose    = $true
        WhatIf     = -not $publishConfirmed
    }
    if ($apiKey) {
        $publishSplat.ApiKey = $apiKey
    }

    Publish-PSResource @publishSplat
}
