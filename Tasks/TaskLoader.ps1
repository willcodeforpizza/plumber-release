<#
    .SYNOPSIS
    Loads Plumber.Release Invoke-Build tasks.

    .DESCRIPTION
    Registers release tasks in the active Invoke-Build scope.

    .PARAMETER Config
    Repository-specific release configuration. Supported keys are
    ModuleManifest, ModuleRoot, ModuleName, ModuleOutputRoot, ModuleBuildItems,
    ModuleBuildExtraItems, Repository and GitRemote.
#>
param(
    [hashtable]
    $Config = @{}
)

$moduleRoot = Split-Path $PSScriptRoot -Parent

foreach ($privateScript in Get-ChildItem (Join-Path $moduleRoot 'Private') -Filter '*.ps1') {
    . $privateScript.FullName
}

$script:PlumberReleaseConfig = Resolve-PlumberReleaseConfig -Config $Config -BuildRoot $BuildRoot

. (Join-Path $PSScriptRoot 'BuildModule.ps1')
. (Join-Path $PSScriptRoot 'PublishModule.ps1')
. (Join-Path $PSScriptRoot 'PublishGitHubRelease.ps1')
. (Join-Path $PSScriptRoot 'Release.ps1')
