<#
    .SYNOPSIS
    Determines whether the current module version should be released.

    .DESCRIPTION
    Reads the module manifest version and git tag state for release tasks.
#>
if ($script:_loadedPlumberReleaseSetReleaseState) { return }
$script:_loadedPlumberReleaseSetReleaseState = $true

Add-BuildTask -Name SetReleaseState -Jobs {
    $config = $script:PlumberReleaseConfig
    $script:PlumberReleaseState = Get-PlumberReleaseState -Config $config
    Write-Build White "Release version: $($script:PlumberReleaseState.Version)"
    Write-Build White "Release tag: $($script:PlumberReleaseState.TagName)"
}
