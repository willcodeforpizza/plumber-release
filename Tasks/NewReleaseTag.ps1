<#
    .SYNOPSIS
    Creates the annotated release tag for the current module version.
#>
if ($script:_loadedPlumberReleaseNewReleaseTag) { return }
$script:_loadedPlumberReleaseNewReleaseTag = $true

Add-BuildTask -Name NewReleaseTag -Jobs TestReleaseReadiness, {
    $config = $script:PlumberReleaseConfig
    $tagName = $script:PlumberReleaseState.TagName

    git -C $config.ModuleRoot tag -a $tagName -m $tagName
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to create release tag $tagName."
        return
    }

    Write-Build Green "Created release tag: $tagName"
}
