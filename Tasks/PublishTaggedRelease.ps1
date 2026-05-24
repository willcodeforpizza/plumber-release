<#
    .SYNOPSIS
    Publishes the module from the tag that triggered CI.
#>
if ($script:_loadedPlumberReleasePublishTaggedRelease) { return }
$script:_loadedPlumberReleasePublishTaggedRelease = $true

Add-BuildTask -Name PublishTaggedRelease -Jobs SetReleaseState, {
    $state = $script:PlumberReleaseState
    if ($state.CurrentTag -ne $state.TagName) {
        Write-Error "Current tag '$($state.CurrentTag)' does not match release tag '$($state.TagName)'."
        return
    }
}, BuildModule, PublishModule, PublishGitHubRelease
