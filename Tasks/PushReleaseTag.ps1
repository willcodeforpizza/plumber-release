<#
    .SYNOPSIS
    Pushes the annotated release tag.
#>
if ($script:_loadedPlumberReleasePushReleaseTag) { return }
$script:_loadedPlumberReleasePushReleaseTag = $true

Add-BuildTask -Name PushReleaseTag -Jobs NewReleaseTag, {
    $config = $script:PlumberReleaseConfig
    $tagName = $script:PlumberReleaseState.TagName

    git -C $config.ModuleRoot push $config.GitRemote $tagName
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to push release tag $tagName to $($config.GitRemote)."
        return
    }

    Write-Build Green "Pushed release tag: $tagName"
}
