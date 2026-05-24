function Get-PlumberReleaseState {
    <#
        .SYNOPSIS
        Gets release state for the configured module.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject]
        $Config
    )

    $manifest = Test-ModuleManifest -Path $Config.ModuleManifest
    $version = $manifest.Version.ToString()
    $tagName = "v$version"

    $existingLocalTag = git -C $Config.ModuleRoot tag --list $tagName
    $existingRemoteTag = git -C $Config.ModuleRoot ls-remote --tags $Config.GitRemote "refs/tags/$tagName"

    $currentTag = $env:GITHUB_REF_NAME
    if (-not $currentTag) {
        $currentTag = git -C $Config.ModuleRoot describe --tags --exact-match 2>$null
    }

    $tagRefs = @(
        git -C $Config.ModuleRoot tag --list
        git -C $Config.ModuleRoot ls-remote --tags $Config.GitRemote
    )
    $latestVersion = $null
    foreach ($tagRef in $tagRefs) {
        $tag = if ($tagRef -match 'refs/tags/(?<TagName>[^\^]+)(?:\^\{\})?$') {
            $Matches.TagName
        } else {
            $tagRef
        }
        $parsedVersion = ConvertTo-PlumberReleaseSemVer -VersionName $tag
        if ($parsedVersion -and ($null -eq $latestVersion -or $parsedVersion -gt $latestVersion)) {
            $latestVersion = $parsedVersion
        }
    }

    [pscustomobject]@{
        Version           = $version
        VersionInfo       = ConvertTo-PlumberReleaseSemVer -VersionName $version
        TagName           = $tagName
        CurrentTag        = $currentTag
        ExistingLocalTag  = [bool]$existingLocalTag
        ExistingRemoteTag = [bool]$existingRemoteTag
        LatestTagVersion  = $latestVersion
    }
}
