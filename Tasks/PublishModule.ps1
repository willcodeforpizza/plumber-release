<#
    .SYNOPSIS
    Publishes a module to PowerShell Gallery.

    .DESCRIPTION
    Builds a clean module folder and publishes it with Publish-PSResource.
    The API key is read from PSGALLERY_API_KEY.

    Requires PSGALLERY_API_KEY and publishes the built module folder.

    .RUN
    ```powershell
    Invoke-Plumber -Task PublishModule
    ```
#>
if ($script:_loadedPlumberReleasePublishModule) { return }
$script:_loadedPlumberReleasePublishModule = $true

Add-BuildTask -Name PublishModule -Jobs BuildModule, {
    $config = $script:PlumberReleaseConfig
    if ('PSGallery' -notin $config.ReleaseTargets) {
        Write-Build Yellow 'Skipping PublishModule because PSGallery is not a release target.'
        return
    }

    $apiKey = $env:PSGALLERY_API_KEY
    if (-not $apiKey) {
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
        ApiKey     = $apiKey
    }

    Publish-PSResource @publishSplat
}
