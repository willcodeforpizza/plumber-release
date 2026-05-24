<#
    .SYNOPSIS
    Runs the module release pipeline.

    .DESCRIPTION
    Validates release readiness, creates the annotated release tag, and pushes
    it to the configured git remote. Pushing the tag starts the CI publishing
    workflow.

    .INCLUDES
    PushReleaseTag

    .RUN
    ```powershell
    Invoke-Plumber -Task Release
    ```
#>
if ($script:_loadedPlumberReleaseRelease) { return }
$script:_loadedPlumberReleaseRelease = $true

Add-BuildTask -Name Release -Jobs PushReleaseTag
