function Resolve-PlumberReleaseConfig {
    <#
        .SYNOPSIS
        Resolves release task configuration.
    #>
    [CmdletBinding()]
    param(
        [hashtable]
        $Config = @{},

        [string]
        $BuildRoot
    )

    if (-not $BuildRoot) {
        $BuildRoot = Get-Location
    }

    $moduleRoot = if ($Config.ModuleRoot) {
        $Config.ModuleRoot
    } else {
        $BuildRoot
    }

    $manifestPath = if ($Config.ModuleManifest) {
        if ([System.IO.Path]::IsPathRooted($Config.ModuleManifest)) {
            $Config.ModuleManifest
        } else {
            Join-Path $moduleRoot $Config.ModuleManifest
        }
    } else {
        Get-ChildItem -Path $moduleRoot -Filter '*.psd1' -File -ErrorAction SilentlyContinue |
            Select-Object -First 1 -ExpandProperty FullName
    }

    if (-not $manifestPath -or -not (Test-Path $manifestPath)) {
        throw "Could not find module manifest for release tasks under '$moduleRoot'."
    }

    $manifest = Get-Item $manifestPath
    $moduleName = if ($Config.ModuleName) {
        $Config.ModuleName
    } else {
        $manifest.BaseName
    }

    $defaultItems = @(
        'Private',
        'Public',
        'Resource',
        'LICENSE',
        'README.md',
        'CHANGELOG.md',
        "$moduleName.psd1",
        "$moduleName.psm1"
    )

    $buildItems = if ($Config.ModuleBuildItems) {
        @($Config.ModuleBuildItems)
    } else {
        $defaultItems + @($Config.ModuleBuildExtraItems)
    }

    [pscustomobject]@{
        ModuleRoot       = $moduleRoot
        ModuleManifest   = $manifest.FullName
        ModuleName       = $moduleName
        ModuleOutputRoot = if ($Config.ModuleOutputRoot) {
            $Config.ModuleOutputRoot
        } else {
            Join-Path ([System.IO.Path]::GetTempPath()) $moduleName
        }
        ModuleBuildItems = $buildItems
        Repository       = if ($Config.Repository) { $Config.Repository } else { 'PSGallery' }
        GitRemote        = if ($Config.GitRemote) { $Config.GitRemote } else { 'origin' }
    }
}
