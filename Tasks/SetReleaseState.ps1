<#
    .SYNOPSIS
    Determines whether the current module version should be released.

    .DESCRIPTION
    Reads the module manifest version and checks for an existing git tag. In CI,
    an existing version tag makes the release pipeline a clean no-op. Outside
    CI, an existing tag is treated as an error.
#>
if ($script:_loadedPlumberReleaseSetReleaseState) { return }
$script:_loadedPlumberReleaseSetReleaseState = $true

Add-BuildTask -Name SetReleaseState -Jobs {
    $config = $script:PlumberReleaseConfig
    $manifest = Test-ModuleManifest -Path $config.ModuleManifest
    $version = $manifest.Version.ToString()
    $tagName = "v$version"

    $existingLocalTag = git tag --list $tagName
    $existingRemoteTag = git ls-remote --tags $config.GitRemote "refs/tags/$tagName"

    $script:PlumberReleaseState = [pscustomobject]@{
        Version       = $version
        TagName       = $tagName
        ShouldRelease = -not ($existingLocalTag -or $existingRemoteTag)
    }

    if ($script:PlumberReleaseState.ShouldRelease) {
        Write-Build White "Release tag available: $tagName"
        return
    }

    if ($env:CI -eq 'true') {
        Write-Build Yellow "Release tag already exists: $tagName. Skipping release."
        return
    }

    Write-Error "Git tag already exists: $tagName"
}
