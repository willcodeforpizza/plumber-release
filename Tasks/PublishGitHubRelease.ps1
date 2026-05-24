<#
    .SYNOPSIS
    Creates or updates the GitHub release for a module tag.

    .DESCRIPTION
    Uses the release state tag and notes from the matching changelog section.

    .RUN
    ```powershell
    Invoke-Plumber -Task PublishGitHubRelease
    ```
#>
if ($script:_loadedPlumberReleasePublishGitHubRelease) { return }
$script:_loadedPlumberReleasePublishGitHubRelease = $true

Add-BuildTask -Name PublishGitHubRelease -Jobs SetReleaseState, {
    $config = $script:PlumberReleaseConfig
    if ('GitHub' -notin $config.ReleaseTargets) {
        Write-Build Yellow 'Skipping PublishGitHubRelease because GitHub is not a release target.'
        return
    }

    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Error 'GitHub CLI is required to publish a GitHub release.'
        return
    }

    $version = $script:PlumberReleaseState.Version
    $tagName = $script:PlumberReleaseState.TagName
    $releaseNotesPath = Get-PlumberReleaseNote -Config $config -Version $version

    gh release view $tagName *> $null
    if ($LASTEXITCODE -eq 0) {
        gh release edit $tagName --title $tagName --notes-file $releaseNotesPath
    } else {
        gh release create $tagName --title $tagName --notes-file $releaseNotesPath
    }
}
