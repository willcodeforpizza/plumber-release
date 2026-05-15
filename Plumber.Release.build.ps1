$module = Get-Module Plumber |
    Where-Object { $_.ModuleBase -eq (Resolve-Path (Join-Path $PSScriptRoot '../plumber')).Path } |
        Select-Object -First 1
if (-not $module) {
    $plumberManifest = Join-Path $PSScriptRoot '../plumber/Plumber.psd1'
    if (Test-Path $plumberManifest) {
        $module = Import-Module $plumberManifest -Force -PassThru
    } else {
        $module = Import-Module Plumber -PassThru
    }
}

Import-Module (Join-Path $PSScriptRoot 'Plumber.Release.psd1') -Force

. (Get-PlumberTaskLoader) -Config @{
    ModuleManifest       = 'Plumber.Release.psd1'
    PublicFunctionPrefix = 'PlumberRelease'
    VersionSource        = 'GitTag'
}

. (Get-PlumberReleaseTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
}
