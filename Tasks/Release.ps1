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
    Invoke-Build -File ./Release.build.ps1 Release
    ```
#>
if ($script:_loadedPlumberReleaseRelease) { return }
$script:_loadedPlumberReleaseRelease = $true

Add-BuildTask -Name Release -Jobs SetReleaseState, BuildModule, PublishModule, PublishGitHubRelease
Add-BuildTask -Name . -Jobs Release
