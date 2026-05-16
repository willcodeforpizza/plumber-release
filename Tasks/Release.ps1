<#
    .SYNOPSIS
    Runs the module release pipeline.

    .DESCRIPTION
    Builds the module, publishes it to PowerShell Gallery, and creates the
    GitHub release.

    .INCLUDES
    BuildModule
    PublishModule
    PublishGitHubRelease

    .RUN
    ```powershell
    Invoke-Plumber -Task Release
    ```
#>
if ($script:_loadedPlumberReleaseRelease) { return }
$script:_loadedPlumberReleaseRelease = $true

Add-BuildTask -Name Release -Jobs SetReleaseState, BuildModule, PublishModule, PublishGitHubRelease
