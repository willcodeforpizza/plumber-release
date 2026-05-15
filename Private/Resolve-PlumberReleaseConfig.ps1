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
        'Tasks',
        'docs',
        'LICENSE',
        'README.md',
        'CHANGELOG.md',
        "$moduleName.psd1",
        "$moduleName.psm1"
    )

    $buildItems = $defaultItems + @($Config.ModuleBuildIncludeItems)
    $buildItems = @($buildItems | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

    $excludeItems = @($Config.ModuleBuildExcludeItems |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    if ($excludeItems) {
        $buildItems = @($buildItems | Where-Object {
            $item = $_
            -not ($excludeItems | Where-Object { $item -like $_ })
        })
    }

    $releaseTargets = if ($Config.ReleaseTargets) {
        @($Config.ReleaseTargets)
    } else {
        @('PSGallery', 'GitHub')
    }
    $releaseTargets = @($releaseTargets | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    $supportedTargets = @('PSGallery', 'GitHub')
    foreach ($target in $releaseTargets) {
        if ($target -notin $supportedTargets) {
            throw "Unsupported release target '$target'. Supported targets: $($supportedTargets -join ', ')."
        }
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
        ReleaseTargets   = $releaseTargets
        GitRemote        = if ($Config.GitRemote) { $Config.GitRemote } else { 'origin' }
    }
}
