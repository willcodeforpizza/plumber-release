<#
    .SYNOPSIS
    Creates the GitHub tag and release for a module.

    .DESCRIPTION
    Uses the module manifest version to create a v<version> git tag and a
    GitHub release with notes from the matching changelog section.

    By default this task only reports what it would do. Set
    GITHUB_RELEASE_CONFIRM to true to create and push the tag and release.

    .RUN
    ```powershell
    Invoke-Plumber -Task PublishGitHubRelease
    ```
#>
if ($script:_loadedPlumberReleasePublishGitHubRelease) { return }
$script:_loadedPlumberReleasePublishGitHubRelease = $true

Add-BuildTask -Name PublishGitHubRelease -Jobs {
    $config = $script:PlumberReleaseConfig
    if (-not $script:PlumberReleaseState.ShouldRelease) {
        Write-Build Yellow 'Skipping PublishGitHubRelease because this version is already released.'
        return
    }
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

    $changelogPath = Join-Path $config.ModuleRoot 'CHANGELOG.md'
    $changelog = Get-Content $changelogPath
    $sectionStart = [array]::IndexOf($changelog, "## $version")
    if ($sectionStart -lt 0) {
        Write-Error "No changelog section found for version $version."
        return
    }

    $sectionEnd = $changelog.Count
    for ($i = $sectionStart + 1; $i -lt $changelog.Count; $i++) {
        if ($changelog[$i] -match '^## \d') {
            $sectionEnd = $i
            break
        }
    }

    $releaseNotes = @($changelog[($sectionStart + 1)..($sectionEnd - 1)]).Trim() |
        Where-Object { $_ }
    $releaseNotesPath = Join-Path ([System.IO.Path]::GetTempPath()) "$($config.ModuleName)-release-notes.md"
    Set-Content -Path $releaseNotesPath -Value $releaseNotes

    if ($env:GITHUB_RELEASE_CONFIRM -ne 'true') {
        Write-Build Yellow "Would create and push git tag $tagName to $($config.GitRemote)"
        Write-Build Yellow "Would create GitHub release $tagName"
        Write-Build Yellow 'Set GITHUB_RELEASE_CONFIRM=true to publish the release.'
        return
    }

    git tag $tagName
    git push $config.GitRemote $tagName
    gh release create $tagName --title $tagName --notes-file $releaseNotesPath
}
