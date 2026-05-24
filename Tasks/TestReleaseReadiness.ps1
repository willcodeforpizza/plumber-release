<#
    .SYNOPSIS
    Validates that the current module is ready to tag for release.

    .DESCRIPTION
    Checks that the worktree is clean, the release tag does not already exist,
    the changelog contains the manifest version, and the manifest version is
    greater than existing semantic release tags.
#>
if ($script:_loadedPlumberReleaseTestReleaseReadiness) { return }
$script:_loadedPlumberReleaseTestReleaseReadiness = $true

Add-BuildTask -Name TestReleaseReadiness -Jobs SetReleaseState, {
    $config = $script:PlumberReleaseConfig
    $state = $script:PlumberReleaseState

    if (-not $state.VersionInfo) {
        Write-Error "ModuleVersion '$($state.Version)' is not a semantic version."
        return
    }

    $dirty = git -C $config.ModuleRoot status --porcelain
    if ($dirty) {
        Write-Error 'Working tree must be clean before creating a release tag.'
        return
    }

    if ($state.ExistingLocalTag -or $state.ExistingRemoteTag) {
        Write-Error "Release tag already exists: $($state.TagName)"
        return
    }

    if ($state.LatestTagVersion -and $state.VersionInfo -le $state.LatestTagVersion) {
        Write-Error (
            "ModuleVersion $($state.VersionInfo) must be greater than " +
            "latest release tag $($state.LatestTagVersion)."
        )
        return
    }

    Get-PlumberReleaseNote -Config $config -Version $state.Version | Out-Null
    Write-Build Green "Release is ready: $($state.TagName)"
}
